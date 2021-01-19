import 'package:flutter/material.dart';

class OptionsRoute extends StatelessWidget {
  const OptionsRoute();

  @override
  Widget build(BuildContext context) {
    final _backgroundColor = Colors.green[100]; // TODO colors to common file (style)
    final _textColor = Colors.black87;

    final container = Container(
      color: _backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(children: [
        Text("Setting one"),
        Text("Setting 2"),
        GridView.count(crossAxisCount: 2, children: [Text("I'm in grid 1"), Text("I'm in grid 2")])
      ]),
    );

    // TODO app bar to separate view
    final appBar = AppBar(
        backgroundColor: _backgroundColor,
        centerTitle: true,
        title: Text("UNIT CONVERTER", style: TextStyle(color: _textColor)));

    return Scaffold(appBar: appBar, body: container);
  }
}
