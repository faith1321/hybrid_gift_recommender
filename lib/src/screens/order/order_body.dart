import 'package:flutter/material.dart';
import 'package:hybrid_gift/utils/products.dart';
import 'package:hybrid_gift/src/screens/home/details/product_page.dart';
import 'package:hybrid_gift/src/screens/order/order_book.dart';
import 'package:hybrid_gift/utils/constants.dart';
import 'package:hybrid_gift/utils/digital_templates.dart';

class OrderBody extends StatelessWidget {
  final UserOrder order;

  const OrderBody({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: [
                ProductPage(
                  product: products.firstWhere(
                    (element) => element.title == order.orderedProduct,
                    orElse: () => products.first,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                  child: DigitalTemplates(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
