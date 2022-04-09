import tensorflow as tf
import numpy as np

tflite_interpreter = tf.lite.Interpreter(model_path="assets/model.tflite")
tflite_interpreter.allocate_tensors()

input_details = tflite_interpreter.get_input_details()
output_details = tflite_interpreter.get_output_details()

print("== Input details ==")
print("shape:", input_details[0]['shape'])
print("type:", input_details[0]['dtype'])
print("\n== Output details ==")
print("shape:", output_details[0]['shape'])
print("type:", output_details[0]['dtype'])

input_shape = input_details[0]['shape']
input_data = np.array(np.random.random_sample(input_shape), dtype=np.string_)
tflite_interpreter.set_tensor(input_details[0]['index'], input_data)

tflite_interpreter.invoke()

output_data = tflite_interpreter.get_tensor(output_details[0]['index'])
print(output_data)
