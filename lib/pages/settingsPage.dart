import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/configUtil.dart';





class SettingsScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Настройки')),
      body:ListView(
        children: <Widget>[
          ListTile(
            title: Text('Профиль'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettingsScreen()));
            },
          ),
          // ListTile(
          //   title: Text('Подключения'),
          //   trailing: Icon(Icons.keyboard_arrow_right),
          //   onTap: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectionsSettingsScreen()));
          //   },
          // ),
          ListTile(
            title: Text('API Endpoint'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EndpointSettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}

// Profile Settings (name ang group)
class ProfileSettingsScreen extends StatefulWidget {

  @override
  createState() => new ProfileSettingsScreenState();

}

class EndpointSettingsScreen extends StatefulWidget {

  @override
  createState() => new EndpointSettingsScreenState();

}

class ProfileSettingsScreenState extends State<ProfileSettingsScreen>{

  TextEditingController fullnameText =new TextEditingController();
  TextEditingController groupText = new TextEditingController();




  @override
  initState() {
    super.initState();


    getStringFromLocalMemory('fio').then((value) =>
      fullnameText.text = value
    );
    getStringFromLocalMemory('group').then((value) =>
      groupText.text = value
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Настройки профиля')),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // SizedBox(
              //   height: 20.0,
              // ),
              // new Image.asset(
              //   'assets/user.jpg',
              //   fit: BoxFit.fitWidth,
              //   width: 100,
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),
              TextField(
                  controller: fullnameText ,
                  decoration: const InputDecoration(
                    labelText: 'ФИО',
                  )),
              TextField(
                  controller:  groupText,
                  decoration: const InputDecoration(
                    labelText: 'Группа',
                  )),
              SizedBox(
                height: 50.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.black87,
                ),
                onPressed: () {
                  saveStringInLocalMemory('fio', fullnameText.text);
                  saveStringInLocalMemory('group', groupText.text);
                },
                child: Text('Сохранить'),
              ),
              SizedBox(
                height: 10.0,
              ),
              OutlineButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Назад')
              )
            ]
        ),
      ),
    );
  }
}

// Connection settings (find connection
class ConnectionsSettingsScreen extends StatelessWidget {

  TextEditingController ConnectionIDText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Подключения')),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                  controller: ConnectionIDText = new TextEditingController(),
                  decoration: const InputDecoration(
                    labelText: 'ID подключения',
                  )),
              SizedBox(
                height: 50.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                      @override
                      Widget build(BuildContext context) {
                        return new ListView.builder(
                            itemBuilder: (context, i) {});
                      }
                },
                child: Text('Показать действующие рабочие места'),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: () {

                },
                child: Text('Удалить рабочий стол'),
              ),
              SizedBox(
                height: 10.0,
              ),
              OutlineButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Назад')
              )
            ]
        ),
      ),
    );
  }
}


// API Endpoint
class EndpointSettingsScreenState extends State<EndpointSettingsScreen> {

  TextEditingController endpointUrlText = new TextEditingController();

  @override
  void initState() {
    super.initState();

    getStringFromLocalMemory('apiUrl').then((value) =>
        endpointUrlText.text = value
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Endpoint')),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                  controller: endpointUrlText,
                  decoration: const InputDecoration(
                    labelText: 'Точка подключения (http://)',
                  )),
              SizedBox(
                height: 50.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  saveStringInLocalMemory('apiUrl', endpointUrlText.text);
                },
                child: Text('Сохранить'),
              ),
              SizedBox(
                height: 10.0,
              ),
              OutlineButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Назад')
              )
            ]
        ),
      ),
    );
  }
}
