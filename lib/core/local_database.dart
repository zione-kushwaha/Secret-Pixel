import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase {
  final key = 'isDark';

  Future<void> initializeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(key)) {
      await prefs.setBool(key, false);
    }
  }

  Future<void> updateMode(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool> getMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
}
