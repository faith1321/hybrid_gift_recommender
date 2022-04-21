# Imports
from datetime import datetime
import json
import os
import pprint
from matplotlib.font_manager import json_dump
import tensorflow as tf
import pandas as pd

import numpy as np
import tensorflow_datasets as tfds
import tensorflow_recommenders as tfrs
import tempfile
import pathlib
from typing import Dict, Text

LEARNING_RATE = 0.5
SEED = 1
BATCH_SIZE = 10_000
FOLDS = range(10)
EMBEDDING_DIM = 32
KEYS = {"customer_id", "product_title", "star_rating"}


# ---------------------------------------------------------------------------- #
#                            Dataset Pre-processing                            #
# ---------------------------------------------------------------------------- #
# Import Dataset

# Personal Care Section Importing From amazon_us_reviews dataset
test_ds = tfds.load('amazon_us_reviews/Personal_Care_Appliances_v1_00', split=[
    f'train[{k}%:{k+10}%]' for k in range(0, 100, 10)
])
train_ds = tfds.load('amazon_us_reviews/Personal_Care_Appliances_v1_00', split=[
    f'train[:{k}%]+train[{k+10}%:]' for k in range(0, 100, 10)
])

train1 = train = test1 = test = list()

for k in FOLDS:
    train1.append(train_ds[k].map(lambda x: x["data"]))
    train[k] = train1[k].map(lambda x: {
        "customer_id": x["customer_id"],
        "product_title": x["product_title"],
        "star_rating": x["star_rating"]
    })
    tf.random.set_seed(SEED)
    trainS = train[k].shuffle(
        BATCH_SIZE, seed=SEED, reshuffle_each_iteration=False)

    test1.append(test_ds[k].map(lambda x: x["data"]))
    test[k] = test1[k].map(lambda x: {"customer_id": x["customer_id"],
                                      "product_title": x["product_title"],
                                      "star_rating": x["star_rating"]})
    testS = test[k].shuffle(
        10_000, seed=SEED, reshuffle_each_iteration=False)
    # Determine Unique Customer and Product ID
    customerID = (train[k]
                  # Retain only the fields we need.
                  .map(lambda x: x["customer_id"])
                  )
    product = (train[k]
               .map(lambda x: x["product_title"])
               )

    uniqueCustomerID = np.unique(
        np.concatenate(list(customerID.batch(BATCH_SIZE))))
    uniqueProduct = np.unique(np.concatenate(list(product.batch(BATCH_SIZE))))

# Split into Training and Testing Sets

train = trainS.take(len(trainS))
test = testS.take(len(testS))


# ---------------------------------------------------------------------------- #
#                                     Model                                    #
# ---------------------------------------------------------------------------- #
class Model(tfrs.Model):
    def __init__(self, rank_weight: float, retr_weight: float) -> None:
        super().__init__()

        # Query Tower

        # Model that represents customers with Matrix Factorization
        self.customer_model = tf.keras.Sequential([
            tf.keras.layers.StringLookup(
                vocabulary=uniqueCustomerID, mask_token=None),
            # Embedding for unknown tokens
            tf.keras.layers.Embedding(len(uniqueCustomerID) + 1, EMBEDDING_DIM)
        ])

        # Candidate Tower
        # Model that represents products
        self.product_model = tf.keras.Sequential([
            tf.keras.layers.StringLookup(
                vocabulary=uniqueProduct, mask_token=None),
            # Embedding for unknown tokens
            tf.keras.layers.Embedding(len(uniqueProduct) + 1, EMBEDDING_DIM)
        ])

        # RELU-based DNN
        self.rank_model = tf.keras.Sequential([
            tf.keras.layers.Dense(256),
            tf.keras.layers.Dense(128),
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
                                                 restore_best_weights=True)


def rmse(true, pred):
    return tf.sqrt(tf.reduce_mean(tf.square(pred - true)))


# Graph plotting variables
logdir = "assets/logs/fit/" + datetime.now().strftime("%Y%m%d-%H%M%S")
tensorboard_callback = tf.keras.callbacks.TensorBoard(log_dir=logdir)

model = Model(retr_weight=0.5, rank_weight=0.5)

model.compile(optimizer=tf.keras.optimizers.Adam(
    learning_rate=LEARNING_RATE), loss=rmse)

# Model Fitting and Evaluation
train = train.shuffle(BATCH_SIZE).batch(BATCH_SIZE).cache()
test = test.batch(BATCH_SIZE).cache()

model.fit(train, epochs=100, callbacks=[earlystopping, tensorboard_callback])
metrics = model.evaluate(test, return_dict=True)

print(
    f"Retrieval top-100 accuracy: {metrics['factorized_top_k/top_100_categorical_accuracy']:.3f}.")
print(f"Ranking RMSE: {metrics['root_mean_squared_error']:.3f}.")

# Save model to SavedModel format
tflite_model_dir = "assets"

model.retr_task = tfrs.tasks.Retrieval()  # Removes the metrics.
model.compile()

saved_model = tf.saved_model.save(model, tflite_model_dir)

# Convert the model to standard TensorFlow Lite model
converter = tf.lite.TFLiteConverter.from_saved_model(tflite_model_dir)
tflite_model = converter.convert()

# Save the model.
with open('assets/model.tflite', 'wb') as f:
    f.write(tflite_model)

# ---------------------------------------------------------------------------- #
#                      Save metrics results into JSON file                     #
# ---------------------------------------------------------------------------- #
metrics = {key: round(float(a), 3) for key, a in metrics.items()}
metrics = {datetime.now().strftime("%Y%m%d-%H%M%S"): metrics}
RESULTS_PATH = "assets/results/results.json"

# os.makedirs(RESULTS_PATH, exist_ok=True)

jsonFile = json.load(open(RESULTS_PATH, "r"))
jsonFile.update(metrics)

json.dump(jsonFile, open(RESULTS_PATH, "w"))
