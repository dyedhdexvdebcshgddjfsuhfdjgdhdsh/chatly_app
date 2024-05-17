import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

AwesomeDialog AweasomeWidget({
  required BuildContext context,
  required DialogType dialogType,
  required AnimType animType,
  String? title,
  String? desc ,
void Function()? btnOkOnPress ,
void Function()? btnCancelOnPress
}) {
  return AwesomeDialog(
    context: context,
    dialogType:dialogType,
    animType:animType,
    title: title,
    desc: desc,
    btnCancelOnPress:btnCancelOnPress,
    btnOkOnPress:btnOkOnPress
  )..show();
}
