import 'package:flutter/material.dart';
import 'package:hybrid_gift/models/products.dart';
import 'package:hybrid_gift/screens/order/order_list.dart';
import 'package:hybrid_gift/screens/order/order_screen.dart';
import 'package:hybrid_gift/src/application_state.dart';
import 'package:hybrid_gift/utils/constants.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  OrderPage({Key? key}) : super(key: key);
  final orderedItem = products.first.title;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            alignment: Alignment.topRight,
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {
              context.read<ApplicationState>().addOrderToUser(orderedItem);
            },
          ),
          IconButton(
            onPressed: () {
              context.read<ApplicationState>().clearList();
            },
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      Center(
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) => SizedBox(
            height: .5 * MediaQuery.of(context).size.height,
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
          // UserBook(orders: appState.userOrders),
        ),

        // builder: ((context, appState, _) => CustomScrollView(
        //       shrinkWrap: true,
        //       slivers: <Widget>[
        //         SliverPadding(
        //           padding: const EdgeInsets.all(20.0),
        //           sliver: SliverList(
        //             delegate: SliverChildBuilderDelegate(
        //               (context, index) => OrderList(
        //                 order: appState.userOrders[index],
        //                 press: () => Navigator.push<MaterialPageRoute>(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) => const OrderScreen(),
        //                   ),
        //                 ),
        //               ),
        //               childCount: appState.userOrders.length,
        //             ),
        //           ),
        //         ),
        //         // UserBook(orders: appState.userOrders),
        //       ],
        //     )),
      )
    ]);
  }
}
