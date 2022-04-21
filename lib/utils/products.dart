import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class Product {
  final String image, title, description, id;
  final int price, size;
  final Color color;

  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.size,
    required this.color,
    Key? key,
  });
}

List<Product> products = [
  Product(
      id: "B00847JQZ6",
      title: "SE - Reading Glass - Spring Loaded Hinges, 4.0x - RTS62400",
      price: 234,
      size: 12,
      description: dummyText,
      image: "assets/images/logo.png",
      color: RandomColor()
          .randomColor(colorSaturation: ColorSaturation.lowSaturation)),
  Product(
      id: "B00N5HD340",
      title: "Straight Razor",
      price: 124,
      size: 8,
      description: dummyText,
      image: "assets/images/logo.png",
      color: RandomColor()
          .randomColor(colorSaturation: ColorSaturation.lowSaturation)),
  Product(
      id: "B0077L1X24",
      title:
          "Philips Sonicare Flexcare & Healthy White Plastic Travel Handle Case New Bulk Package",
      price: 4,
      size: 10,
      description: dummyText,
      image: "assets/images/logo.png",
      color: RandomColor()
          .randomColor(colorSaturation: ColorSaturation.lowSaturation)),
  Product(
      id: "B001CHCQ9I",
      title: "Massage Table Sheet Set - Poly/cotton",
      price: 24,
      size: 11,
      description: dummyText,
      image: "assets/images/logo.png",
      color: RandomColor()
          .randomColor(colorSaturation: ColorSaturation.lowSaturation)),
  Product(
      id: "B0016BJS2S",
      title: "TRIMEDICA, AlkaMax pH Plus Liquid - 1 oz",
      price: 39,
      size: 12,
      description: dummyText,
      image: "assets/images/logo.png",
      color: RandomColor()
          .randomColor(colorSaturation: ColorSaturation.lowSaturation)),
  Product(
      id: "B000V73YY6sß",
      title: "Germ Free Warm Mist Humidifier",
      price: 23,
      size: 12,
      description: dummyText,
      image: "assets/images/logo.png",
      color: RandomColor()
          .randomColor(colorSaturation: ColorSaturation.lowSaturation)),
];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";

// class ProductList extends StatefulWidget {
//   const ProductList({Key? key}) : super(key: key);

//   @override
//   State<ProductList> createState() => _ProductListState();
// }

// class _ProductListState extends State<ProductList> {
//   List<List<dynamic>> data = [];

//   /// Loads the csv into a list.
//   Future<List> _loadCSV() async {
//     final _rawData = await rootBundle.loadString("assets/product_title.csv");
//     List<List<dynamic>> _listData =
//         const CsvToListConverter().convert<dynamic>(_rawData, eol: "\n");
//     setState(() {
//       for (int i = 0; i < _listData.length; i++) {
//         products.add(Product(
//             id: i,
//             image: "",
//             title: _listData[0][i].toString(),
//             price: i,
//             description: "",
//             size: 1,
//             color: RandomColor()
//                 .randomColor(colorSaturation: ColorSaturation.lowSaturation)));
//       }
//     });
//     print(data);
//     return data;
//   }

//   @override
//   void initState() {
//     _loadCSV();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     products = _loadCSV() as List<Product>;
//     return Container();
//   }
// }
