import 'package:flutter/material.dart';
import 'package:hybrid_gift/src/screens/order/order_book.dart';
import 'package:hybrid_gift/utils/constants.dart';
import 'package:hybrid_gift/utils/products.dart';

class OrderList extends StatelessWidget {
  final UserOrder order;
  final Function()? press;
  const OrderList({Key? key, required this.order, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product = products.firstWhere(
      (element) => element.title == order.orderedProduct,
      orElse: () => products.first,
    );

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
                  order.orderedProduct,
                  style: const TextStyle(color: kTextColor),
                  // softWrap: false,
                ),
              ],
            ),
          ))
        ]));
  }
}
