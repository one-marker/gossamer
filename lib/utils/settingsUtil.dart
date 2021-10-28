import 'package:shared_preferences/shared_preferences.dart';

/*
  * It saves the int value to the local memory.
  * */
Future<String> getIntFromLocalMemory(String key) async {
  var pref = await SharedPreferences.getInstance();
  var value = pref.getString(key) ??  "";
  return value;
}

/*
  * It returns the saved the int value from the memory.
  * */
Future<void> saveIntInLocalMemory(String key, String value) async {
  var pref = await SharedPreferences.getInstance();
  pref.setString(key, value);
}