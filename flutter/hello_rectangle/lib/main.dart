// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';



void main() {
  runApp(
    // takes any widget as argument, e. g. Container(color: Colors.greenAccent)
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hello Rectangle',
      home: Scaffold(
        // offers drawers, navigation tabs, ...
        appBar: AppBar(
          title: Text('Hello Rectangle'),
        ),
        body: HelloRectangle(),
      ),
    ),
  );
}

class HelloRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        // centering applies only to the immediate child
        child: Container(
      // Container ~ <div> in Web or View in ReactNative
      color: Colors.purple,
      width: 300.0,
      height: 400.0,
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text("Hello Everyone!", textScaleFactor: 3),
          Text("Goodbye Everyone!", style: TextStyle(fontSize: 40.0)),
        ],
      ),
    ));
  }
}
