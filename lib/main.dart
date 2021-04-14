import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io' show Platform;
import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'pref.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  static final String uploadEndPoint = 'http://localhost:80/desktop/';

  String session_id = "234";
  String status = '';
  String errMessage = 'Не удалось создать рабочий стол';

  TextEditingController nameText;
  TextEditingController platText;

  @override
  void initState() {

  }

  setStatus(String message) {

    setState(() {
      status = message;
    });
  }

  launchApp(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchVNC() async {

    //print(prefs?.getString('session_id') ?? 'NULL');
    const url = 'vnc://vnc@xxx.engineer';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showAlertDialog(this.context);
    }
  }


  openMarket() {
    String linkShop;
    // Or, use a predicate getter.
    if (Platform.isAndroid) {
      linkShop =  "https://play.google.com/store/apps/details?id=com.realvnc.viewer.android&hl=ru&gl=US";
    } else if (Platform.isIOS) {
      linkShop =  "https://apps.apple.com/ru/app/vnc-viewer-remote-desktop/id352019548";
    }
    launchApp(linkShop);
  }

  createDesktop(String plat, String name) async {
    //setStatus(plat + " " + name);


    print(plat + " " + name);
    http.post(uploadEndPoint, body: {
      "plat": 'plat',
      "name": 'name',
    }).then((result) {
      final body = json.decode(result.body);
      print(body["vnc"]);
      print(body["session_id"]);
      session_id = body["session_id"];
      launchApp(status);
      setStatus(result.statusCode == 200 ? json.decode(result.body)["vnc"] : errMessage);
    }).catchError((error) {
      setStatus(errMessage);
      print(error);
    });
  }

  //VNC not found
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Позже"),
      onPressed:  () {
        Navigator.of(context).pop(); // dismiss dialog
        //launchMissile();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("СКАЧАТЬ"),
      onPressed:  () {

        //String linkShop = prepareVncClient();
        //launchApp(linkShop);
        openMarket();
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Не найден VNC Viewer"),
      content: Text("Хотите перейти в магазин приложений, чтобы скачать VNC Viewer?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("GnuRadio"),
      // ),
      appBar: AppBar(
        title: Text(session_id),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            new Image.asset(
              'assets/icon.jpg',
              fit: BoxFit.fitWidth,
              //width: MediaQuery.of(context).size.width * 0.50,
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
                controller: platText = new TextEditingController(),
                decoration: const InputDecoration(
                  labelText: 'Номер группы',
                )),

            TextField(
                controller: nameText = new TextEditingController(),
                decoration: const InputDecoration(
                  labelText: 'ФИО',
                )),
            SizedBox(
              height: 20.0,
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.orange,
              ),
              onPressed: () {
                createDesktop(platText.text, nameText.text);
              },
              child: Text('Создать рабочий стол'),
            ),
            SizedBox(
              height: 10.0,
            ),
            OutlineButton(
              onPressed: () {
                launchVNC();
              },
              child: Text('Подключиться к рабочему столу'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "session_id: " + session_id,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
