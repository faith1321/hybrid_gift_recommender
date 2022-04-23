import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_gift/src/screens/order/order_book.dart';
import 'package:hybrid_gift/utils/media_upload.dart';
import 'package:hybrid_gift/utils/products.dart';

class DigitalWrapping extends StatefulWidget {
  final UserOrder order;
  const DigitalWrapping({Key? key, required this.order}) : super(key: key);

  @override
  State<DigitalWrapping> createState() => _DigitalWrappingState();
}

class _DigitalWrappingState extends State<DigitalWrapping> {
  @override
  DigitalWrapping get widget => super.widget;

  int mediaCount = 1;

  @override
  Widget build(BuildContext context) {
    var product = products.firstWhere(
      (element) => element.title == widget.order.orderedProduct,
      orElse: () => products.first,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: product.color,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.back),
          color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: () {
                _increaseMediaCount();
              },
              icon: const Icon(Icons.add_box_rounded),
              color: Colors.white),
        ],
      ),
      body: MediaUpload(mediaCount: mediaCount),
    );
  }

  void _increaseMediaCount() {
    setState(() {
      mediaCount += 1;
    });
  }
}
