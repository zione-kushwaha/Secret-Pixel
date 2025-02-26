import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/local_database.dart';
import '../theme/app_theme.dart';

class ThemeProvider extends StateNotifier<ThemeData?> {
  ThemeProvider() : super(null) {
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    final isDark = await LocalDatabase().getMode();
    print('isDark $isDark');
    state = isDark ? AppTheme.darkTheme() : AppTheme.lightTheme();
  }

  void toggleTheme() async {
    state = state!.brightness == Brightness.dark
        ? AppTheme.lightTheme()
        : AppTheme.darkTheme();
    await LocalDatabase().updateMode(state!.brightness == Brightness.dark);
  }

  // getter to get the current theme
  ThemeData get getTheme => state!;
}

final themeProvider = StateNotifierProvider<ThemeProvider, ThemeData?>(
  (ref) => ThemeProvider(),
);

final themeFutureProvider = FutureProvider<ThemeData>((ref) async {
  final isDark = await LocalDatabase().getMode();
  return isDark ? AppTheme.darkTheme() : AppTheme.lightTheme();
});
