// ignore_for_file: non_constant_identifier_names, file_names

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'colors.dart';
export 'package:cool_alert/cool_alert.dart';

class ToastShowClass {
  //Display the Toast
  static void toastShow(
      BuildContext? context, String ToastValue, MaterialColor _color) {
    Fluttertoast.showToast(
        msg: ToastValue,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: _color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void coolToastShow(
      BuildContext context, String message, CoolAlertType type) {
    FocusManager.instance.primaryFocus?.unfocus();
    CoolAlert.show(
        context: context,
        animType: CoolAlertAnimType.slideInUp,
        backgroundColor: Colors.black,
        confirmBtnColor: ColorCollection.backColor,
        type: type,
        text: '$message');
  }
}
