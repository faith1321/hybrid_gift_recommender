import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_gift/constants.dart';
import 'package:hybrid_gift/models/products.dart';
import 'package:hybrid_gift/screens/home/details/body.dart';
import 'package:hybrid_gift/search_bar.dart';

/// Creates the item details screen.

class DetailsScreen extends StatefulWidget {
  final Product product;

  const DetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text("");

  @override
  DetailsScreen get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.product.color,
      appBar: buildAppBar(context),
      body: Body(product: widget.product),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: widget.product.color,
      elevation: 0,
      title: customSearchBar,
      leading: IconButton(
        icon: const Icon(CupertinoIcons.back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        // Search Function
        const SearchBar(type: "details"),

        // IconButton(
        //   onPressed: () {
        //     setState(() {
        //       // Displays the search bar if not shown.
        //       if (customIcon.icon == Icons.search) {
        //         customIcon = const Icon(Icons.cancel);
        //         customSearchBar = const ListTile(
        //           leading: Icon(
        //             Icons.search,
        //             color: Colors.white,
        //             size: 28,
        //           ),
        //           title: TextField(
        //             decoration: InputDecoration(
        //               hintText: "Search a product",
        //               hintStyle: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 14,
        //                 fontStyle: FontStyle.italic,
        //               ),
        //               border: InputBorder.none,
        //             ),
        //             style: TextStyle(
        //               color: Colors.white,
        //             ),
        //           ),
        //         );
        //       }
        //       // Hides search bar if shown.
        //       else {
        //         customIcon = const Icon(Icons.search);
        //         customSearchBar = const Text("");
        //       }
        //     });
        //   },
        //   icon: customIcon,
        // ),
        // Shopping Bag Function
        IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.shopping_bag)),
        const SizedBox(width: kDefaultPaddin / 2),
      ],
    );
  }
}
