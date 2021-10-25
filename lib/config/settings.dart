import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

saveSettings(String name, String group) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var settings = jsonEncode({
    "name": name,
    "group": group
  });
  prefs.setString('settings', settings);
}
saveProfile(String name, String group) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('SavedName', name);
  prefs.setString('SavedGroup', group);

}

saveIDNote(String ID, String host) async{

  SharedPreferences prefs = await SharedPreferences.getInstance();
  List IDlist = prefs.getStringList("ID_host");
  IDlist.add(ID + " " + host);
  prefs.setString("ID_host", host);

}
Future<String> getSavedProfile(String flag) async{

  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (flag == "name") {
    String stringValue = prefs.getString('SavedName');
    print(prefs.getString("ID_host"));
    return stringValue;
  }
  else if (flag == "group"){
    String stringValue = prefs.getString('SavedGroup');
    return stringValue;
  }
  else if (flag == "settings"){
    String stringValue = prefs.getString('settings');
    return stringValue;
  }

}
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
          ListTile(
            title: Text('Подключения'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectionsSettingsScreen()));
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

class ProfileSettingsScreenState extends State<ProfileSettingsScreen>{

  TextEditingController fullnameText;
  TextEditingController groupText;




  @override
  initState() {

    super.initState();
    getSavedProfile("name").then((value) {fullnameText.text = value;});
    getSavedProfile("group").then((value) {groupText.text = value;});


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
              TextField(
                  controller: fullnameText = new TextEditingController(),
                  decoration: const InputDecoration(
                    labelText: 'ФИО',
                  )),
              TextField(
                  controller:  groupText = new TextEditingController(),
                  decoration: const InputDecoration(
                    labelText: 'Группа',
                  )),
              SizedBox(
                height: 50.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {
                  saveSettings(fullnameText.text, groupText.text);
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