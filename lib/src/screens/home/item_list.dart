import 'package:flutter/material.dart';
import 'package:hybrid_gift/utils/products.dart';
import 'package:hybrid_gift/utils/constants.dart';

class ItemList extends StatelessWidget {
  final Product product;
  final Function()? press;
  const ItemList({Key? key, required this.product, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: press,
        child: Row(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: product.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(product.image),
            ),
          ),
          Flexible(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
            child: Column(
              children: [
                Text(
                  product.title,
                  style: const TextStyle(color: kTextLightColor),
                  // softWrap: false,
                ),
                Text(
                  "£${product.price}",
                  style: const TextStyle(color: kTextLightColor),
                ),
              ],
            ),
          ))
        ]));
  }
}
