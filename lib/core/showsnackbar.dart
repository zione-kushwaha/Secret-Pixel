import '/constants/constant.dart';
import 'package:flutter/material.dart';

void show_snackbar(BuildContext context, message) {
  // hide the previous snackbar
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  // show the new snackbar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width / 8, vertical: 50),
      content: Align(
        alignment: Alignment.center,
        child: Text(
          message,
          style: TextStyle(color: whiteColor),
        ),
      ),
    ),
  );
}
