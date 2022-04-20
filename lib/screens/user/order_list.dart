import 'package:flutter/material.dart';
import 'package:hybrid_gift/constants.dart';
import 'package:hybrid_gift/src/order_book.dart';

class OrderList extends StatelessWidget {
  final UserOrder order;
  final Function()? press;
  const OrderList({Key? key, required this.order, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: press,
        child: Row(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Flexible(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
            child: Column(
              children: [
                Text(
                  order.orderedProduct,
                  style: const TextStyle(color: kTextLightColor),
                  // softWrap: false,
                ),
              ],
            ),
          ))
        ]));
  }
}
