import 'dart:core';

import 'package:flutter/material.dart';
import 'config/theme.dart';

import 'pages/homePage.dart';

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
