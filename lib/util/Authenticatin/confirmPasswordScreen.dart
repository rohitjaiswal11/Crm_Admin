// ignore_for_file: must_be_immutable, deprecated_member_use, prefer_const_constructors, file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/storage_manger.dart';
import 'package:lbm_crm/widgets/bottom_navigationbar.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';

import '../colors.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  static const id = '/confirmPassword';

  String password;
  ConfirmPasswordScreen({required this.password});

  @override
  State<ConfirmPasswordScreen> createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  bool isDark = false;

  String confirmPassword = '';
  String displayPassword = '';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Image.asset(
              'assets/appLogo.png',
              height: height * 0.1,
              width: height * 0.1,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Text(
              KeyValues.confirmPasscode,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Container(
              height: height * 0.06,
              width: width * 0.7,
              decoration: BoxDecoration(
                  color: isDark ? Colors.black45 : Color(0xfff1f1f1),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                  child: Text(
                displayPassword,
                style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 5),
              )),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            NumericKeyboard(
                onKeyboardTap: (value) {
                  if (confirmPassword.length == 6) {
                    ToastShowClass.coolToastShow(
                        context,
                        'Passcode can not be more than 6 digits!',
                        CoolAlertType.info);
                  } else {
                    setState(() {
                      confirmPassword = confirmPassword + value;
                      displayPassword = displayPassword + '*';
                    });

                    if (confirmPassword.length == 6) {
                      if (confirmPassword == widget.password) {
                        SharedPreferenceClass.SetSharedData(
                            'loginPin', confirmPassword.toString());

                        Navigator.pushNamedAndRemoveUntil(
                            context, BottomBar.id, (route) => false);
                      } else {
                        ToastShowClass.coolToastShow(context,
                            'Passcode not matched', CoolAlertType.info);
                      }
                    }
                  }
                  // setState(() {
                  //   confirmPassword = confirmPassword + value;
                  //   displayPassword = displayPassword + '*';
                  // });
                  // if (confirmPassword.length == 6) {
                  //   if (confirmPassword == widget.password) {
                  //     SharedPreferenceClass.SetSharedData(
                  //         'loginPin', confirmPassword.toString());

                  //     Navigator.pushNamedAndRemoveUntil(
                  //         context, BottomBar.id, (route) => false);
                  //   } else {
                  //     ToastShowClass.toastShow(
                  //         context, 'Passcode not matched', Colors.red);
                  //   }
                  // }
                },
                textColor: isDark ? Colors.white : Colors.black,
                rightButtonFn: () {
                  if (confirmPassword.isEmpty) {
                    return;
                  }
                  setState(() {
                    confirmPassword = confirmPassword.substring(
                        0, confirmPassword.length - 1);
                    displayPassword = displayPassword.substring(
                        0, displayPassword.length - 1);
                  });
                },
                rightIcon: Icon(
                  Icons.backspace,
                  color: Colors.black,
                ),
                mainAxisAlignment: MainAxisAlignment.spaceBetween),
            SizedBox(
              height: height * 0.05,
            ),
            GestureDetector(
              onTap: () async {
                if (confirmPassword == widget.password) {
                  SharedPreferenceClass.SetSharedData(
                      'loginPin', confirmPassword.toString());

                  Navigator.pushNamedAndRemoveUntil(
                      context, BottomBar.id, (route) => false);
                } else {
                   ToastShowClass.coolToastShow(
                      context, 'Passcode not matched', CoolAlertType.info);
                }
              },
              child: Container(
                  width: width * 0.9,
                  decoration: BoxDecoration(
                      color: confirmPassword.length == 6
                          ? ColorCollection.backColor
                          : ColorCollection.lightgreen,
                      borderRadius: BorderRadius.circular(9)),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                      child: Text(
                    KeyValues.next,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ))),
            ),
            SizedBox(
              height: height * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}
