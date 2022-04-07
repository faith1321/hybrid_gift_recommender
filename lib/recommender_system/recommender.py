# Imports
import pprint
import tensorflow as tf
import pandas as pd

import numpy as np
import tensorflow_datasets as tfds
import tensorflow_recommenders as tfrs
import tempfile
import pathlib
from typing import Dict, Text

trainNum = 8_000
testNum = 2_000
learningRate = 0.1

# Dataset Pre-processing
# Import Dataset

# Personal Care Section Importing From amazon_us_reviews dataset
test_ds = tfds.load('amazon_us_reviews/Personal_Care_Appliances_v1_00', split=[
    f'train[{k}%:{k+10}%]' for k in range(0, 100, 10)
])
train_ds = tfds.load('amazon_us_reviews/Personal_Care_Appliances_v1_00', split=[
    f'train[:{k}%]+train[{k+10}%:]' for k in range(0, 100, 10)
])

tools1 = toolsProcessed = list()

for k in range(10):
    tools1.append(train_ds[k].map(lambda x: x["data"]))
    toolsProcessed[k] = tools1[k].map(lambda x: {
        "customer_id": x["customer_id"],
        "product_title": x["product_title"],
        "star_rating": x["star_rating"]
    })
    tf.random.set_seed(1)
    shuffledTools = toolsProcessed[k].shuffle(
        10_000, seed=1, reshuffle_each_iteration=False)

    # Determine Unique Customer and Product ID
    customerID = (toolsProcessed[k]
                  # Retain only the fields we need.
                  .map(lambda x: x["customer_id"])
                  )
    product = (toolsProcessed[k]
               .map(lambda x: x["product_title"])
               )

    uniqueCustomerID = np.unique(np.concatenate(list(customerID.batch(1_000))))
    uniqueProduct = np.unique(np.concatenate(list(product.batch(1_000))))

# Split into Training and Testing Sets

train = shuffledTools.take(trainNum)

test = shuffledTools.skip(trainNum).take(testNum)

# Model


class Model(tfrs.Model):
    def __init__(self, rating_weight: float, retrieval_weight: float) -> None:
        super().__init__()
        embeddingDim = 32

        # Model that represents customers with Matrix Factorization
        self.customer_model = tf.keras.Sequential([
            tf.keras.layers.StringLookup(
                vocabulary=uniqueCustomerID, mask_token=None),
            # Embedding for unknown tokens
            tf.keras.layers.Embedding(len(uniqueCustomerID) + 1, embeddingDim)
        ])

        # Model that represents products
        self.product_model = tf.keras.Sequential([
            tf.keras.layers.StringLookup(
                vocabulary=uniqueProduct, mask_token=None),
            # Embedding for unknown tokens
            tf.keras.layers.Embedding(len(uniqueProduct) + 1, embeddingDim)
        ])

        # RELU-based DNN
        self.rating_model = tf.keras.Sequential([
            tf.keras.layers.Dense(256, activation="relu"),
            tf.keras.layers.Dense(128, activation="relu"),
            tf.keras.layers.Dense(64, activation="relu"),
            tf.keras.layers.Dense(1, activation="relu"),
        ])

        # Loss function used to train the models using the Factorized Top-k Method for Retrieval
        # Predict the items the user will prefer.
        self.retrieval_task = tfrs.tasks.Retrieval(
            metrics=tfrs.metrics.FactorizedTopK(
                candidates=product.batch(128).cache().map(self.product_model)
            )
        )

        # Loss function for rating
        # Predict the ratings of the item
        self.rating_task = tfrs.tasks.Ranking(
            loss=tf.keras.losses.MeanAbsoluteError(),
            metrics=[tf.keras.metrics.RootMeanSquaredError()],
        )

        # The loss weights
        self.rating_weight = rating_weight
        self.retrieval_weight = retrieval_weight

    def call(self, features: Dict[Text, tf.Tensor]) -> tf.Tensor:

        # We pick out the user features and pass them into the user model.
        customer_embeddings = self.customer_model(features["customer_id"])

        # And pick out the item features and pass them into the item model.
        product_embeddings = self.product_model(features["product_title"])

        return (
            customer_embeddings,
            product_embeddings,
            # We apply the multi-layered rating model to a concatentation of
            # user and item embeddings.
            self.rating_model(
                tf.concat([customer_embeddings, product_embeddings], axis=1)
            ),
        )

    def compute_loss(self, features: Dict[Text, tf.Tensor], training=False) -> tf.Tensor:
        # ratings go here as a method to compute loss
        ratings = features.pop("star_rating")

        customer_embeddings, product_embeddings, rating_predictions = self(
            features)

        # We compute the loss for each task.
        rating_loss = self.rating_task(
            labels=ratings,
            predictions=rating_predictions,
        )

        retrieval_loss = self.retrieval_task(
            customer_embeddings, product_embeddings)

        # And combine them using the loss weights.
        return (self.rating_weight * rating_loss
                + self.retrieval_weight * retrieval_loss)


# Early stopping function to prevent overfitting
earlystopping = tf.keras.callbacks.EarlyStopping(monitor="loss",
                                                 mode="min", patience=5,
                                                 restore_best_weights=True)

model = Model(retrieval_weight=0.5, rating_weight=0.5)

model.compile(optimizer=tf.keras.optimizers.Adagrad(
    learning_rate=learningRate), loss="mean_squared_error")

# Model Fitting and Evaluation
cachedTrain = train.shuffle(10_000).batch(8192).cache()
cachedTest = test.batch(4096).cache()

model.fit(cachedTrain, epochs=100, callbacks=[earlystopping])
# model.fit(cachedTrain, epochs=10)
metrics = model.evaluate(cachedTest, return_dict=True)

print(
    f"Retrieval top-100 accuracy: {metrics['factorized_top_k/top_100_categorical_accuracy']:.3f}.")
print(f"Ranking RMSE: {metrics['root_mean_squared_error']:.3f}.")

# Convert into Tensorflow Lite
tflite_model_dir = "/tflite_models/"

model.retrieval_task = tfrs.tasks.Retrieval()  # Removes the metrics.
model.compile()

saved_model = tf.saved_model.save(model, tflite_model_dir)

converter = tf.lite.TFLiteConverter.from_saved_model(tflite_model_dir)
tflite_model = converter.convert()

# Save the model.
with open('model.tflite', 'wb') as f:
    f.write(tflite_model)
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.target_spec.supported_ops = [
    tf.lite.OpsSet.TFLITE_BUILTINS,  # enable TensorFlow Lite ops.
    tf.lite.OpsSet.SELECT_TF_OPS  # enable TensorFlow ops.
]

converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.target_spec.supported_types = [tf.float16]

tflite_f16_model = converter.convert()
tflite_f16_file = tflite_model_dir/"recommender_f16.tflite"
tflite_f16_file.write_bytes(tflite_f16_model)

# Retrieving Top-K Candidates
# Dummy values created to simulate larger dataset
uniqueProduct = tf.data.Dataset.from_tensor_slices(uniqueProduct)

toolsWithDummy = tf.data.Dataset.concatenate(
    uniqueProduct.batch(4096),
    uniqueProduct.batch(4096).repeat(1_000).map(lambda x: tf.zeros_like(x))
)

toolsWithDummyEmb = tf.data.Dataset.concatenate(
    uniqueProduct.batch(4096).map(model.product_model),
    uniqueProduct.batch(4096).repeat(1_000)
    .map(lambda x: model.product_model(x))
    .map(lambda x: x * tf.random.uniform(tf.shape(x)))
)
brute_force = tfrs.layers.factorized_top_k.BruteForce(model.customer_model)
brute_force.index_from_dataset(
    uniqueProduct.batch(100).map(
        lambda prod: (prod, model.product_model(prod)))
)
# Get predictions for user.
id_input = input("Enter the customer ID: ")
_, titles = brute_force(np.array([str(id_input)]), k=3)

print(f"Top recommendations: {titles[0]}")
