import 'package:shared_preferences/shared_preferences.dart';

const keyName = "name";
const keyImageURL = "imageUrl";
const keyUserName = "username";
const keyPassword = "password";
const keyLnctu = "lnctu";
const keyBranch = 'branch';
const keySem = 'sem';
const keyGender = 'gender';

class MySharedPref {
  static late SharedPreferences _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future deleteAll() async {
    await _preferences.clear();
  }

  static Future setField({required String id, required String key}) async =>
      await _preferences.setString(key, id);

  static String? getField(String key) => _preferences.getString(key);
}
