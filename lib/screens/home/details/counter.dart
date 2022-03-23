import 'package:flutter/cupertino.dart';

import 'cart_counter.dart';

class Counter extends StatelessWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const CartCounter(),
        Container(
          padding: const EdgeInsets.all(8),
          height: 32,
          width: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFFF6464),
            shape: BoxShape.circle, 
          ),
          child: const Icon(CupertinoIcons.heart),
        )
      ],
    );
  }
}