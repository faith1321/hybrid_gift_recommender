import 'package:flutter/material.dart';
import 'package:hybrid_gift/utils/products.dart';
import 'package:hybrid_gift/utils/constants.dart';

class Description extends StatelessWidget {
  final Product product;

  const Description({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Text(
        product.description,
        style: const TextStyle(height: 1.5),
      ),
    );
  }
}
