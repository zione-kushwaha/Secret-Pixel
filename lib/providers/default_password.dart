import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultPassword extends StateNotifier<String> {
  DefaultPassword() : super('0000');
  final bool isEnable = false;

  void updatePassword(String password) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('password', password);
    await pref.setBool('isEnable', true);
    state = password;
  }

  void disablePassword() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isEnable', false);
    await pref.remove('password');
    state = '0000';
  }
}
