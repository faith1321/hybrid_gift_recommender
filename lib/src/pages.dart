import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_gift/constants.dart';
import 'package:hybrid_gift/screens/home/home_page.dart';
import 'package:hybrid_gift/screens/user/order_page.dart';
import 'package:hybrid_gift/screens/user/user_page.dart';
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
  Widget customSearchBar = const Text("");
  final Color _color = kTextColor;

  Icon customIcon = const Icon(
    Icons.search,
    color: kTextColor,
  );
  late TextEditingController myController;
  List<List<dynamic>> data = [];
  bool isShowSearchBar = false;

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

  /// Loads the csv into a list.
  Future<List> _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/product_title.csv");
    List<List<dynamic>> _listData =
        const CsvToListConverter().convert<dynamic>(_rawData, eol: "\n");
    setState(() {
      for (int i = 0; i < _listData.length; i++) {
        data[0][i] = _listData[0][i].toString();
      }
    });
    // print(data);
    return data;
  }

  @override
  void initState() {
    myController = TextEditingController();
    super.initState();
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
        // selectedItemColor: Color.fromARGB(255, 42, 148, 100),
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
        // const SearchBar(type: "pages"),
        IconButton(
          onPressed: () {
            setState(() {
              // Displays the search bar if not shown.
              if (customIcon.icon == Icons.search) {
                isShowSearchBar = true;
                customIcon = Icon(
                  Icons.cancel,
                  color: _color,
                );
                customSearchBar = ListTile(
                    leading: Icon(
                      Icons.search,
                      color: _color,
                      size: 28,
                    ),
                    title: TextFieldSearch(
                        label: "Catalogue",
                        controller: myController,
                        future: () {
                          return _loadCSV();
                        },
                        getSelectedValue: (dynamic value) {
                          // print(value);
                        },
                        decoration: InputDecoration(
                          hintText: "Search a product",
                          hintStyle: TextStyle(
                            color: _color,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        )));
              }
              // Hides search bar if shown.
              else {
                isShowSearchBar = false;
                customIcon = Icon(
                  Icons.search,
                  color: _color,
                );
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
