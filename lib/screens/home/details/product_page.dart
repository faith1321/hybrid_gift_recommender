import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_gift/models/products.dart';
import 'package:hybrid_gift/utils/constants.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  const ProductPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Personal Items",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: kDefaultPaddin * 5,
            width: MediaQuery.of(context).size.width,
            child: AutoSizeText(
              product.title,
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: kDefaultPaddin),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: "Price\n"),
                    TextSpan(
                        text: "£${product.price}",
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: kDefaultPaddin),
          FittedBox(
            alignment: Alignment.bottomRight,
            child: Hero(
              tag: product.id,
              child: Image.asset(
                product.image,
                fit: BoxFit.contain,
                width: 120,
              ),
            ),
          )
        ],
      ),
    );
  }
}
