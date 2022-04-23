import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_gift/src/screens/order/order_book.dart';
import 'package:hybrid_gift/utils/constants.dart';
import 'package:hybrid_gift/utils/digital_wrapping.dart';
import 'package:hybrid_gift/utils/products.dart';

class OrderBody extends StatelessWidget {
  final UserOrder order;

  const OrderBody({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var product = products.firstWhere(
      (element) => element.title == order.orderedProduct,
      orElse: () => products.first,
    );
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: kDefaultPaddin * .5),
                    SizedBox(
                      height: kDefaultPaddin * 5,
                      width: MediaQuery.of(context).size.width,
                      child: AutoSizeText(
                        order.orderedProduct,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: product.color, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  product.image,
                  fit: BoxFit.contain,
                  width: 200,
                ),
                SizedBox(
                  height: 50,
                  child: TextButton(
                    child: Text(
                      "Edit Digital Wrapping".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: product.color,
                      onSurface: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                    ),
                    onPressed: () {
                      Navigator.push<MaterialPageRoute>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DigitalWrapping(order: order),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
