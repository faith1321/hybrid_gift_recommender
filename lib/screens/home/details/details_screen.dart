import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_gift/constants.dart';
import 'package:hybrid_gift/models/products.dart';
import 'package:hybrid_gift/screens/home/details/body.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;

  const DetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Catalogue');

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
      leading: IconButton(
        icon: const Icon(CupertinoIcons.back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              if (customIcon.icon == Icons.search) {
                customIcon = const Icon(Icons.cancel);
                customSearchBar = const ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 28,
                  ),
                  title: TextField(
                    decoration: InputDecoration(
                      hintText: "Type in a product...",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              } else {
                customIcon = const Icon(Icons.search);
                customSearchBar = const Text("Catalogue");
              }
            });
          },
          icon: customIcon,
        ),
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
