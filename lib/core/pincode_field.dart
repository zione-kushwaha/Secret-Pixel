import 'package:flutter/material.dart';
import 'package:pincode_input_fields/pincode_input_fields.dart';

import '../theme/theme_color.dart';

Widget buildPincode(double height, double width, BuildContext context,
    PincodeInputFieldsController pincodeController) {
  final textColor = GetColor.textColor(context);
  return PincodeInputFields(
    controller: pincodeController,
    length: 4,
    heigth: height / 17,
    width: width / 7,
    borderRadius: BorderRadius.circular(9),
    unfocusBorder: Border.all(
      width: 1,
      color: const Color.fromARGB(255, 154, 149, 149),
    ),
    focusBorder: Border.all(
      width: 1,
      color: textColor,
    ),
    cursorColor: textColor,
    cursorWidth: 2,
    focusFieldColor: GetColor.backgroundColor(context),
    textStyle: TextStyle(
      color: GetColor.textColor(context),
      fontSize: 21,
    ),
  );
}
