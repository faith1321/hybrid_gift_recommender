import 'dart:async';
import 'package:flutter/material.dart';
import '../../../utils/widgets.dart';

class UserOrder {
  UserOrder({required this.orderedProduct});
  final String orderedProduct;
}

class OrderBook extends StatefulWidget {
  const OrderBook({required this.user, required this.products});
  final FutureOr<void> Function(String message) user;
  final List<UserOrder> products;

  @override
  _OrderBookState createState() => _OrderBookState();
}

class _OrderBookState extends State<OrderBook> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        for (var message in widget.products) Paragraph(message.orderedProduct),
        const SizedBox(height: 8),
      ],
    );
  }
}
