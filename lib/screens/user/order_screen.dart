import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_gift/screens/user/order_list.dart';
import 'package:hybrid_gift/src/order_book.dart';

/// Creates the item details screen.

class OrderScreen extends StatefulWidget {
  final UserOrder order;

  const OrderScreen({Key? key, required this.order}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text("");

  @override
  OrderScreen get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: OrderList(
        order: widget.order,
        press: () {},
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: customSearchBar,
      leading: IconButton(
        icon: const Icon(CupertinoIcons.back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      // actions: [
      //   // Search Function
      //   const SearchBar(type: "details"),

      //   // IconButton(
      //   //   onPressed: () {
      //   //     setState(() {
      //   //       // Displays the search bar if not shown.
      //   //       if (customIcon.icon == Icons.search) {
      //   //         customIcon = const Icon(Icons.cancel);
      //   //         customSearchBar = const ListTile(
      //   //           leading: Icon(
      //   //             Icons.search,
      //   //             color: Colors.white,
      //   //             size: 28,
      //   //           ),
      //   //           title: TextField(
      //   //             decoration: InputDecoration(
      //   //               hintText: "Search a product",
      //   //               hintStyle: TextStyle(
      //   //                 color: Colors.white,
      //   //                 fontSize: 14,
      //   //                 fontStyle: FontStyle.italic,
      //   //               ),
      //   //               border: InputBorder.none,
      //   //             ),
      //   //             style: TextStyle(
      //   //               color: Colors.white,
      //   //             ),
      //   //           ),
      //   //         );
      //   //       }
      //   //       // Hides search bar if shown.
      //   //       else {
      //   //         customIcon = const Icon(Icons.search);
      //   //         customSearchBar = const Text("");
      //   //       }
      //   //     });
      //   //   },
      //   //   icon: customIcon,
      //   // ),
      //   // Shopping Bag Function
      //   IconButton(
      //       onPressed: () {
      //         setState(() {});
      //       },
      //       icon: const Icon(Icons.shopping_bag)),
      //   const SizedBox(width: kDefaultPaddin / 2),
      // ],
    );
  }
}
