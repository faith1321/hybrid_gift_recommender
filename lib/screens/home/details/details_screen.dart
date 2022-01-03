import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_gift/constants.dart';
import 'package:hybrid_gift/models/products.dart';
import 'package:hybrid_gift/screens/home/details/body.dart';

class DetailsScreen extends StatelessWidget {
  final Product product;

  const DetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: product.color,
      appBar: buildAppBar(context),
      body: Body(product: product),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: product.color,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(CupertinoIcons.back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_bag)),
        const SizedBox(width: kDefaultPaddin / 2),
      ],
    );
  }
}
