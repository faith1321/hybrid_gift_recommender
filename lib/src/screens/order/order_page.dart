import 'package:flutter/material.dart';
import 'package:hybrid_gift/application_state.dart';
import 'package:hybrid_gift/src/screens/order/order_list.dart';
import 'package:hybrid_gift/src/screens/order/order_screen.dart';
import 'package:hybrid_gift/utils/constants.dart';
import 'package:hybrid_gift/utils/products.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  OrderPage({Key? key}) : super(key: key);
  final orderedItem = products.first.title;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              context.read<ApplicationState>().clearUserOrders();
            },
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      Center(
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) => SizedBox(
            height: MediaQuery.of(context).size.height * .75,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: appState.userOrders.length,
                itemBuilder: (context, index) => OrderList(
                  order: appState.userOrders[index],
                  press: () => Navigator.push<MaterialPageRoute>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderScreen(
                        order: appState.userOrders[index],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
