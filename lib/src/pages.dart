import 'package:flutter/material.dart';
import 'package:hybrid_gift/constants.dart';
import 'package:hybrid_gift/screens/home/home_page.dart';
import 'package:hybrid_gift/screens/order/order_page.dart';
import 'package:hybrid_gift/src/user_page.dart';

class Pages extends StatefulWidget {
  const Pages({Key? key, required this.signOut}) : super(key: key);

  final void Function() signOut;

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  int _selectedIndex = 0;
  bool _visibilityLogOut = false;
  Icon customIcon = const Icon(
    Icons.search,
    color: kTextColor,
  );
  Widget customSearchBar = const Text('Catalogue');

  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    index == 2 ? _onLogOutTapped(true) : _onLogOutTapped(false);
  }

  void _onLogOutTapped(bool vis) {
    setState(() {
      _visibilityLogOut = vis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_visibilityLogOut)
              UserPage(anotherSignOut: widget.signOut)
            else if (_selectedIndex == 0)
              const Expanded(child: HomePage())
            else if (_selectedIndex == 1)
              const OrderPage()
            else
              Container(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onNavBarItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        color: Colors.white,
        onPressed: () {},
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            setState(() {
              if (customIcon.icon == Icons.search) {
                customIcon = const Icon(
                  Icons.cancel,
                  color: kTextColor,
                );
                customSearchBar = const ListTile(
                  leading: Icon(
                    Icons.search,
                    color: kTextColor,
                    size: 28,
                  ),
                  title: TextField(
                    decoration: InputDecoration(
                      hintText: "Type in a product...",
                      hintStyle: TextStyle(
                        color: kTextColor,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: kTextColor,
                    ),
                  ),
                );
              } else {
                customIcon = const Icon(
                  Icons.search,
                  color: kTextColor,
                );
                customSearchBar = const Text("Catalogue");
              }
            });
          },
          icon: customIcon,
        ),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_bag,
              color: kTextColor,
            )),
        const SizedBox(
          width: kDefaultPaddin / 2,
        )
      ],
    );
  }
}
