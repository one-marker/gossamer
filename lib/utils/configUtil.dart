import 'package:shared_preferences/shared_preferences.dart';

/*
  * It saves the String value to the local memory.
  * */
Future<String> getStringFromLocalMemory(String key) async {
  var pref = await SharedPreferences.getInstance();
  var value = pref.getString(key) ??  "";
  return value;
}

/*
  * It returns the saved the String value from the memory.
  * */
Future<void> saveStringInLocalMemory(String key, String value) async {
  var pref = await SharedPreferences.getInstance();
  pref.setString(key, value);
}