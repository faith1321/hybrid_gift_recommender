import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Agent {
  final _modelFile = "model.tflite";

  late Interpreter _interpreter;

  Agent() {
    _loadModel();
  }

  void _loadModel() async {
    _interpreter = await Interpreter.fromAsset(_modelFile);
  }

  List predict(String itemID) {
    var input = itemID;
    var output = List.filled(3, "0");

    // Inference
    _interpreter.run(input, output);

    debugPrint(output.toString());

    return output;
  }
}
