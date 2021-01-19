import 'package:converter/unit.dart';
import 'package:flutter/material.dart';
import 'package:converter/category.dart';

/// Category Route (screen).
///
/// This is the 'home' screen of the Unit Converter. It shows a header and
/// a list of [Categories].
///
/// While it is named CategoryRoute, a more apt name would be CategoryScreen,
/// because it is responsible for the UI at the route's destination.
class CategoryRoute extends StatelessWidget {
  const CategoryRoute();

  static const _categories = <Category>[
    Category(
        name: "Length",
        color: Colors.teal,
        iconLocation: Icons.architecture,
        units: [Unit(name: "Inch", conversion: 2.5), Unit(name: "Mile", conversion: 250.0)]),
    Category(name: "Area", color: Colors.orange, iconLocation: Icons.blur_linear, units: []),
    Category(name: "Volume", color: Colors.pink, iconLocation: Icons.bathtub, units: []),
    Category(name: "Mass", color: Colors.blue, iconLocation: Icons.two_wheeler, units: []),
    Category(name: "Time", color: Colors.yellow, iconLocation: Icons.watch, units: []),
    Category(name: "Digital Storage", color: Colors.green, iconLocation: Icons.data_usage, units: []),
    Category(name: "Energy", color: Colors.purple, iconLocation: Icons.local_fire_department, units: []),
    Category(name: "Currency", color: Colors.red, iconLocation: Icons.account_balance_wallet, units: []),
  ];

  Widget _buildCategoryWidgets() {
    return ListView(children: _categories);
  }

  @override
  Widget build(BuildContext context) {
    final _backgroundColor = Colors.green[100];
    final _textColor = Colors.black87;

    final listViewContainer = Container(
      color: _backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: _buildCategoryWidgets(),
    );

    final appBar = AppBar(
        backgroundColor: _backgroundColor,
        centerTitle: true,
        title: Text("UNIT CONVERTER", style: TextStyle(color: _textColor)));

    return Scaffold(appBar: appBar, body: listViewContainer);
  }
}
