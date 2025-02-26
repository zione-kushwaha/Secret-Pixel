import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsEnableNotifier extends StateNotifier<bool> {
  IsEnableNotifier() : super(false) {
    _loadIsEnable();
  }

  Future<void> _loadIsEnable() async {
    final pref = await SharedPreferences.getInstance();
    state = pref.getBool('isEnable') ?? false;
  }

  Future<void> updateIsEnable(bool value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isEnable', value);
    state = value;
  }
}

final isEnableProvider = StateNotifierProvider<IsEnableNotifier, bool>((ref) {
  return IsEnableNotifier();
});
