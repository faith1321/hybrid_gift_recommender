import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_gift/constants.dart';
import 'package:textfield_search/textfield_search.dart';

class SearchBar extends StatefulWidget {
  final String type;

  const SearchBar({Key? key, required this.type}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Color _color = Colors.white;
  Icon customIcon = const Icon(
    Icons.search,
    color: kTextColor,
  );
  Widget customSearchBar = const Text('Catalogue');
  var myController = TextEditingController();
  List<List<dynamic>> _data = [];

  /// Loads the csv into a list.
  Future<void> _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/product_title.csv");
    List<List<dynamic>> _listData =
        const CsvToListConverter().convert<dynamic>(_rawData);
    setState(() {
      _data = _listData;
    });
  }

  ///Selects colour of the search bar according to the destination.
  void _setColour(String type) {
    type == "pages" ? _color = kTextColor : Colors.white;
  }

  @override
  void initState() {
    _setColour(widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _loadCSV();
        setState(() {
          // Displays the search bar if not shown.
          if (customIcon.icon == Icons.search) {
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
              // title: TextFieldSearch(
              //   label: "Label",
              //   controller: myController,
              //   decoration: InputDecoration(
              //     hintText: "Search a product",
              //     hintStyle: TextStyle(
              //       color: _color,
              //       fontSize: 14,
              //       fontStyle: FontStyle.italic,
              //     ),
              //     border: InputBorder.none,
              //   ),
              //   // style: const TextStyle(
              //   //   color: kTextColor,
              //   // ),
              // ),
              title: TextField(
                decoration: InputDecoration(
                  hintText: "Search a product",
                  hintStyle: TextStyle(
                    color: _color,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: _color,
                ),
              ),
            );
          }
          // Hides search bar if shown.
          else {
            customIcon = Icon(
              Icons.search,
              color: _color,
            );
            customSearchBar = const Text("");
          }
        });
      },
      icon: customIcon,
    );
  }
}
