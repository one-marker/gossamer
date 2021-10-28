import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


//VNC CLIENT
final String playMarket = 'https://play.google.com/store/apps/details?id=com.realvnc.viewer.android&hl=ru&gl=US';
final String appStore = 'https://apps.apple.com/ru/app/vnc-viewer-remote-desktop/id352019548';


launchShop(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

launchVNC(BuildContext context, String url) async {
  launch(url)
      .then((value) => {if (value == false) showAlertDialog(context)});
  print('launched $url');
}

openMarket() {
  if (Platform.isAndroid) {
    launchShop(playMarket);
  } else if (Platform.isIOS) {
    launchShop(appStore);
  }
}


//VNC not found
showAlertDialog(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Не найден VNC Viewer"),
    content: Text(
        "Хотите перейти в магазин приложений, чтобы скачать VNC Viewer?"),
    actions: [
      // ignore: deprecated_member_use
      FlatButton(
        child: Text("Позже"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      // ignore: deprecated_member_use
      FlatButton(
        child: Text("СКАЧАТЬ"),
        onPressed: () {
          openMarket();
          Navigator.of(context).pop(); // dismiss dialog
        },
      ),
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