import 'dart:core';

import 'package:flutter/material.dart';
import 'file:///Users/marker/VucProjects/frontend/util/theme.dart';

import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Gnu Radio',
        theme: buildThemeData(),
        home: MyHomePage(),
      ),
    );
  }
}

//ThemeData(
//           primarySwatch: Colors.blue,
//         ),
