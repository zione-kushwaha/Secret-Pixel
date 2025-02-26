import 'package:flutter/material.dart';

class GetColor {
  static Color backgroundColor(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color.fromARGB(255, 45, 45, 45) : Colors.white;
  }

  static Color textColor(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return !isDark ? const Color.fromARGB(255, 45, 45, 45) : Colors.white;
  }
}
