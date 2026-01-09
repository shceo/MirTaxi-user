import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static SharedPreferences? preferences;

  ///init shared preferences
  static init() async {
    preferences = await SharedPreferences.getInstance();
  }

  ///save string data
  static void saveString(String key, String value) {
    preferences!.setString(key, value);
  }

  ///get string data
  static String getString(String key) {
    return preferences!.getString(key) ?? '';
  }

  ///save int data
  static void saveInt(String key, int value) {
    preferences!.setInt(key, value);
  }

  ///get int data
  static int? getInt(String key) {
    return preferences!.getInt(key);
  }

  ///save bool data
  static void saveBool(String key, bool value) {
    preferences!.setBool(key, value);
  }

  ///get bool data
  static bool getBool(String key) {
    return preferences!.getBool(key) ?? false;
  }

  ///clear
  static clear() {
    return preferences!.clear();
  }
}
