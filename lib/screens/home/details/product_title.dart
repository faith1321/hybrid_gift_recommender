import 'package:flutter/material.dart';
import 'package:hybrid_gift/constants.dart';
import 'package:hybrid_gift/models/products.dart';

class ProductTitle extends StatelessWidget {
  final Product product;

  const ProductTitle({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Aristocratic Hand Bag",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            product.title,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: kDefaultPaddin),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: "Price\n"),
                    TextSpan(
                      text: "\$${product.price}",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: kDefaultPaddin),
          FittedBox(
            alignment: Alignment.bottomRight,
            child: Hero(
              tag: "${product.id}",
              child: Image.asset(
                product.image,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
    );
  }
}
