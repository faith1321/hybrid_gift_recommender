import tensorflow as tf
import tensorflow_recommenders as tfrs
import numpy as np
from recommender import uniqueProduct, model

# ---------------------------------------------------------------------------- #
#                                  Test Output                                 #
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
