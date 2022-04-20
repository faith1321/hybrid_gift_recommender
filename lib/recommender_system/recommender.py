# Imports
import pprint
import tensorflow as tf
import tensorboard
import pandas as pd
import numpy as np
import tensorflow_datasets as tfds
import tensorflow_recommenders as tfrs
import tempfile
import pathlib
from datetime import datetime
from keras import backend as k
from typing import Dict, Text

# Constants
learningRate = 0.5
seed = 1
batchSize = 10_000
folds = range(10)
keys = {"customer_id", "product_title", "star_rating"}


# ---------------------------------------------------------------------------- #
#                            Dataset Pre-processing                            #
# ---------------------------------------------------------------------------- #
# Import Dataset

# Personal Care Section Importing From amazon_us_reviews dataset
# test_ds = tfds.load('amazon_us_reviews/Personal_Care_Appliances_v1_00', split='train[:20%]'
#                     )
# val_ds = tfds.load('amazon_us_reviews/Personal_Care_Appliances_v1_00', split=[
#     f'train[{k}%:{k+8}%]' for k in range(0, 80, 8)
# ])
# train_ds = tfds.load('amazon_us_reviews/Personal_Care_Appliances_v1_00', split=[
#     f'train[:{k}%]+train[{k+8}%:]' for k in range(0, 80, 8)
# ])
test_ds = tfds.load('amazon_us_reviews/Personal_Care_Appliances_v1_00', split=[
    f'train[{k}%:{k+10}%]' for k in range(0, 100, 10)
])
train_ds = tfds.load('amazon_us_reviews/Personal_Care_Appliances_v1_00', split=[
    f'train[:{k}%]+train[{k+10}%:]' for k in range(0, 100, 10)
])

train1 = train = test1 = test = list()

# Changing dataset into dictionaries
for k in folds:
    train1.append(train_ds[k].map(lambda x: x["data"]))
    train[k] = train1[k].map(lambda x: {
        "customer_id": x["customer_id"],
        "product_title": x["product_title"],
        "star_rating": x["star_rating"]
    })
    tf.random.set_seed(seed)
    trainS = train[k].shuffle(
        10_000, seed=seed, reshuffle_each_iteration=False)

    # val1.append(val_ds[k].map(lambda x: x["data"]))
    # val[k] = val1[k].map(lambda x: {"customer_id": x["customer_id"],
    #                                 "product_title": x["product_title"],
    #                                 "star_rating": x["star_rating"]})

    test1.append(test_ds[k].map(lambda x: x["data"]))
    test[k] = test1[k].map(lambda x: {"customer_id": x["customer_id"],
                                      "product_title": x["product_title"],
                                      "star_rating": x["star_rating"]})
    testS = test[k].shuffle(
        10_000, seed=seed, reshuffle_each_iteration=False)
    # Determine Unique Customer and Product ID
    customerID = (train[k]
                  # Retain only the fields we need.
                  .map(lambda x: x["customer_id"])
                  )
    product = (train[k]
               .map(lambda x: x["product_title"])
               )

    # test1 = list(test_ds)
    # test2 = [x["data"] for x in test1]
    # test = [{key: value for key, value in d.items() if key in keys}for d in test2]

    uniqueCustomerID = np.unique(np.concatenate(list(customerID.batch(1_000))))
    uniqueProduct = np.unique(np.concatenate(list(product.batch(1_000))))

# Split into Training and Testing Sets for Cross Validation

train = trainS.take(len(trainS))
test = testS.take(len(testS))

# test = train.skip(trainNum).take(testNum)


# ---------------------------------------------------------------------------- #
#                                     Model                                    #
# ---------------------------------------------------------------------------- #
class Model(tfrs.Model):
    def __init__(self, rank_weight: float, retr_weight: float) -> None:
        super().__init__()

        # Query Tower
        embeddingDim = 32

        # Model that represents customers with Matrix Factorization
        self.customer_model = tf.keras.Sequential([
            tf.keras.layers.StringLookup(
                vocabulary=uniqueCustomerID, mask_token=None),
            # Embedding for unknown tokens
            tf.keras.layers.Embedding(len(uniqueCustomerID) + 1, embeddingDim)
        ])

        # Candidate Tower
        # Model that represents products
        self.product_model = tf.keras.Sequential([
            tf.keras.layers.StringLookup(
                vocabulary=uniqueProduct, mask_token=None),
            # Embedding for unknown tokens
            tf.keras.layers.Embedding(len(uniqueProduct) + 1, embeddingDim)
        ])

        # RELU-based DNN
        self.rank_model = tf.keras.Sequential([
            tf.keras.layers.Dense(256, activation="relu"),
            tf.keras.layers.Dense(128, activation="relu"),
            tf.keras.layers.Dense(64, activation="relu"),
            tf.keras.layers.Dense(1, activation="relu"),
        ])

        # Loss function for Retrieval, used to train the models using the Factorized Top-k Method
        # Predict the items the user will prefer.
        self.retr_task = tfrs.tasks.Retrieval(
            metrics=tfrs.metrics.FactorizedTopK(
                candidates=product.batch(128).cache().map(self.product_model)
            )
        )

        # Loss function for Ranking
        # Predict the ratings of the item
        self.rank_task = tfrs.tasks.Ranking(
            loss=tf.keras.losses.MeanAbsoluteError(),
            metrics=[tf.keras.metrics.RootMeanSquaredError()],
        )

        # The loss weights
        self.rank_weight = rank_weight
        self.retr_weight = retr_weight

    def call(self, features: Dict[Text, tf.Tensor]) -> tf.Tensor:

        # We pick out the user features and pass them into the user model.
        customer_embeddings = self.customer_model(features["customer_id"])

        # And pick out the item features and pass them into the item model.
        product_embeddings = self.product_model(features["product_title"])

        return (
            customer_embeddings,
            product_embeddings,
            # Multi-layered rating model applied to a concatentation of
            # user and item embeddings.
            self.rank_model(
                tf.concat([customer_embeddings, product_embeddings], axis=1)
            ),
        )

    def compute_loss(self, features: Dict[Text, tf.Tensor], training=False) -> tf.Tensor:
        # ratings go here as a method to compute loss
        ratings = features.pop("star_rating")

        customer_embeddings, product_embeddings, rating_predictions = self(
            features)

        # We compute the loss for each task.
        rank_loss = self.rank_task(
            labels=ratings,
            predictions=rating_predictions,
        )

        retr_loss = self.retr_task(
            customer_embeddings, product_embeddings)

        # And combine them using the loss weights.
        return (self.rank_weight * rank_loss
                + self.retr_weight * retr_loss)


# ---------------------------------------------------------------------------- #
#                       Model Initialization and Training                      #
# ---------------------------------------------------------------------------- #
# Early stopping function to prevent overfitting
earlystopping = tf.keras.callbacks.EarlyStopping(monitor="root_mean_squared_error",
                                                 mode="min", patience=5,
                                                 restore_best_weights=True, baseline=None)


def rmse(true, pred):
    return tf.sqrt(tf.reduce_mean(tf.square(pred - true)))


# Graph plotting variables
logdir = "assets/logs/fit/" + datetime.now().strftime("%Y%m%d-%H%M%S")
tensorboard_callback = tf.keras.callbacks.TensorBoard(log_dir=logdir)

model = Model(retr_weight=0.5, rank_weight=0.5)

model.compile(optimizer=tf.keras.optimizers.Adam(
    learning_rate=learningRate), loss="rmse")

# Model Fitting and Evaluation
train = train.shuffle(10_000).batch(8192).cache()
test = test.batch(4096).cache()

# for k in folds:
#     model.fit(train, epochs=100, callbacks=[earlystopping])
#     metric = model.evaluate(val, return_dict=True)
#     total_rmse = metric["root_mean_squared_error"]


model.fit(train, epochs=100, callbacks=[earlystopping, tensorboard_callback])
# model.fit(cachedTrain, epochs=10)

# ---------------------------------------------------------------------------- #
#                               Model Evaluation                               #
# ---------------------------------------------------------------------------- #
metrics = model.evaluate(test, return_dict=True)

print(
    f"Retrieval top-100 accuracy: {metrics['factorized_top_k/top_100_categorical_accuracy']:.3f}.")
print(f"Ranking RMSE: {metrics['root_mean_squared_error']:.3f}.")


# Save model to SavedModel format
tflite_model_dir = "assets"

# model.retrieval_task = tfrs.tasks.Retrieval()  # Removes the metrics.
# model.compile()

saved_model = model.save_weights(tflite_model_dir, save_format="tf")

# Convert the model to standard TensorFlow Lite model
converter = tf.lite.TFLiteConverter.from_saved_model(tflite_model_dir)
tflite_model = converter.convert()

# Save the model.
with open('assets/model.tflite', 'wb') as f:
    f.write(tflite_model)

# ---------------------------------------------------------------------------- #
#                                Output Testing                                #
# ---------------------------------------------------------------------------- #

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
