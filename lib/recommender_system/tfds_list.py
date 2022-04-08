import tensorflow as tf
import pandas as pd
import tensorflow_datasets as tfds
import numpy as np
import csv
from pprint import pprint

data = list()

# Load dataset
ds = tfds.load(
    'amazon_us_reviews/Personal_Care_Appliances_v1_00', split="train")

tools1 = ds.map(lambda x: x["data"])
product = tools1.map(lambda x: {
    "Product ID": x["product_id"],
    "Product Title": x["product_title"],
})

product = tfds.as_numpy(product)
for x, sample in enumerate(product):
    data.append(sample)

df = pd.DataFrame(data)

df["Product ID"] = df["Product ID"].str.decode("utf-8")
df["Product Title"] = df["Product Title"].str.decode("utf-8")

print(df)

df.to_csv("assets/product_title.csv", index=False)
