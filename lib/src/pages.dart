import 'package:flutter/material.dart';
import 'package:hybrid_gift/constants.dart';
import 'package:hybrid_gift/screens/home/home_page.dart';
import 'package:hybrid_gift/screens/order/order_page.dart';
import 'package:hybrid_gift/src/user_page.dart';
import 'package:textfield_search/textfield_search.dart';

/// Creates the main app interface after login.

class Pages extends StatefulWidget {
  const Pages({Key? key, required this.signOut}) : super(key: key);

  final void Function() signOut;

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  /// Sets the default landing page, where 0 is the homepage.
  int _selectedIndex = 0;
  bool _visibilityLogOut = false;
  Icon customIcon = const Icon(
    Icons.search,
    color: kTextColor,
  );
  Widget customSearchBar = const Text('Catalogue');

  var myController = TextEditingController();

  /// Sets the conditions to switch between the different pages.
  ///
  /// Sets the given [index] as the current page index.
  /// Calls [_onLogOutTapped] if the current page is the User Page (Page 2).
  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    index == 2 ? _onLogOutTapped(true) : _onLogOutTapped(false);
  }

  /// Controls the login status of the user.
  ///
  /// Changes [_visibilityLogOut] according to [vis].
  void _onLogOutTapped(bool vis) {
    setState(() {
      _visibilityLogOut = vis;
    });
  }

  @override
  void dispose() {
    // Cleans up controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    print("Text Field Value: ${myController.text}");
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
            // Triggers sign out process if [_visibilityLogOut] is true.
            if (_visibilityLogOut)
              UserPage(anotherSignOut: widget.signOut)

            // Otherwise, change to the selected page.
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
      title: customSearchBar,
      actions: <Widget>[
        // Search Function
        IconButton(
          onPressed: () {
            setState(() {
              // Displays the search bar if not shown.
              if (customIcon.icon == Icons.search) {
                customIcon = const Icon(
                  Icons.cancel,
                  color: kTextColor,
                );
                customSearchBar = ListTile(
                  leading: const Icon(
                    Icons.search,
                    color: kTextColor,
                    size: 28,
                  ),
                  title: TextFieldSearch(
                    label: "Label",
                    controller: myController,
                    decoration: const InputDecoration(
                      hintText: "Search a product",
                      hintStyle: TextStyle(
                        color: kTextColor,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      border: InputBorder.none,
                    ),
                    // style: const TextStyle(
                    //   color: kTextColor,
                    // ),
                  ),
                );
              }
              // Hides search bar if shown.
              else {
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
        // Shopping Bag Function
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
