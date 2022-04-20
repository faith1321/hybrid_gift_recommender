import 'package:flutter/material.dart';
import 'package:hybrid_gift/models/products.dart';
import 'package:hybrid_gift/recommender_system/agent.dart';
import 'package:hybrid_gift/screens/home/details/add_cart.dart';
import 'package:hybrid_gift/screens/home/details/color_and_size.dart';
import 'package:hybrid_gift/screens/home/details/counter.dart';
import 'package:hybrid_gift/screens/home/details/description.dart';
import 'package:hybrid_gift/screens/home/details/details_screen.dart';
import 'package:hybrid_gift/screens/home/details/product_page.dart';
import 'package:hybrid_gift/screens/home/item_list.dart';
import 'package:hybrid_gift/utils/constants.dart';

class DetailsBody extends StatelessWidget {
  final Product product;

  const DetailsBody({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Agent _agent = Agent();

    List<Product> prediction = [];
    String predictionID = _agent.predict(product.id).toString();

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < products.length; j++) {
        if (predictionID[i] == products[j].id) {
          prediction.add(product);
        }
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 1.3,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  padding: EdgeInsets.only(
                    top: size.height * 0.12,
                    left: kDefaultPaddin,
                    right: kDefaultPaddin,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      ColorAndSize(product: product),
                      const SizedBox(height: kDefaultPaddin / 2),
                      Description(product: product),
                      const SizedBox(height: kDefaultPaddin / 2),
                      const Counter(),
                      const SizedBox(height: kDefaultPaddin / 2),
                      AddCart(product: product),
                      Flexible(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPaddin),
                          child: ListView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) => ItemList(
                              product: products[index],
                              press: () => Navigator.push<MaterialPageRoute>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                    product: products[index],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ProductPage(product: product),
              ],
            ),
          )
        ],
      ),
    );
  }
}
