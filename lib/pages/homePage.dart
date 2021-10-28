import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/vncClient.dart';
import 'package:frontend/pages/settingsPage.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/configUtil.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  String apiUrl = 'http://192.168.0.128:3000';

  String sessionId = "";

  String status = "";

  String connectionUrl = "";

  final TextEditingController nameTextField = new TextEditingController();
  final TextEditingController platTextField = new TextEditingController();

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
  }

  //@override
  void initState() {
    //super.initState();
    print("initState");
    getStringFromLocalMemory('fio').then((value) => {
      nameTextField.text = value
    });
    getStringFromLocalMemory('group').then((value) => {
      platTextField.text = value
    });
    getStringFromLocalMemory('apiUrl').then((value) => {
      apiUrl = value
    });

    print(apiUrl);
  }

  setStatusMessage(String status) {
    setState(() {
      status = status;
    });
  }

  showMessageDialog(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ошибка!"),
          content: Text(message),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              child: Text("Закрыть"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  createDesktop(String surname, int plat) async {
    print("create body");
    var body = jsonEncode({"plat": plat, "surname": surname});
    print(body);
    http.post(apiUrl + "/session", body: body).then((result) {
      final body = json.decode(result.body);
      print("response: " + result.body);
      if (body["error"] == "user with this plat and surname not found") {
        showMessageDialog("Студент не добавлен в базу");
      } else {
        connectionUrl = body["connection_url"];
        sessionId = body["session_id"].toString();
        showStatusAlert(this.context, sessionId);

        setStatusMessage(result.statusCode == 200
            ? json.decode(result.body)["connection_url"]
            : result.statusCode);
      }
    }).catchError((error) {
      setStatusMessage("Не удалось создать рабочий стол");
      print(error);
    });
  }



  showStatusAlert(BuildContext context, String sessionId) {
    Timer time;
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Закрыть"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
        time.cancel();
        //launchMissile();
      },
    );

    time = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      http.get(apiUrl + "/session/" + sessionId).then((result) {
        final body = json.decode(result.body);
        status = body["status"];
        switch (status) {
          case "online":
            print("Рабочий стол успешно создан!");
            timer.cancel();
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Успешно!"),
                  content: Text(""),
                  actions: [cancelButton],
                );
              },
            );
            break;
          case "running":
            break;
        }
      }).catchError((error) {
        print("Ошибка запроса!");
        status = "error";
        timer.cancel();
        Navigator.of(context).pop();
        return;
      });
    });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Проверка статуса..."),
      content: new Scaffold(
        body: new Center(
          child: CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(255, 255, 255, 0)),
        ),
      ),
      actions: [
        cancelButton,
        // continueButton,
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
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
                controller: platTextField,
                decoration: const InputDecoration(
                  labelText: 'Номер группы',
                )),
            TextField(
                controller: nameTextField,
                autofillHints: [AutofillHints.name],
                decoration: const InputDecoration(
                  labelText: 'Фамилия студента',
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
                var plat;
                try {
                  plat = int.parse(platTextField.text);
                } catch (ex) {
                  print("error int parse");
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Неправильные данные!"),
                        content: Text("Группа состоит только из целых чисел"),
                        actions: [
                          FlatButton(
                            child: Text("Закрыть"),
                            onPressed: () {
                              Navigator.of(context).pop(); // dismiss dialog
                            },
                          )
                        ],

                      );
                    },
                  );
                  return;
                }
                if (nameTextField.text.length == 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Неправильные данные!"),
                        content: Text("Не указана фамилия студента"),
                        actions: [
                          FlatButton(
                            child: Text("Закрыть"),
                            onPressed: () {
                              Navigator.of(context).pop(); // dismiss dialog
                            },
                          )
                        ],
                      );
                    },
                  );
                  return;
                }
                createDesktop(nameTextField.text, plat);
              },
              child: Text('Создать рабочий стол'),
            ),

            OutlineButton(
              onPressed: () {
                launchVNC(this.context, connectionUrl);
              },
              child: Text(
                'Подключиться',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            OutlineButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                ).whenComplete(() => initState());
              },
              child: Text(
                'Настройки',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              connectionUrl,
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
