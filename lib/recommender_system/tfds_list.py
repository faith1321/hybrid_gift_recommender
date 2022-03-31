import tensorflow as tf
import pandas as pd
import tensorflow_datasets as tfds
import numpy as np
import csv
from pprint import pprint

title = list()

# Load dataset
ds = tfds.load(
    'amazon_us_reviews/Personal_Care_Appliances_v1_00', split="train")

for k in range(10):
    tools1 = ds.map(lambda x: x["data"])
    product = tools1.map(lambda x: {
        "product_title": x["product_title"],
    })

product = tfds.as_numpy(product)
for x, sample in enumerate(product):
    title.append(sample)

df = pd.DataFrame(title)

df = df["product_title"].str.decode("utf-8")

df.to_csv("assets/product_title.csv")
