// ignore_for_file: must_be_immutable, deprecated_member_use, prefer_const_constructors, file_names, use_key_in_widget_constructors, empty_catches, unused_local_variable, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/storage_manger.dart';
import 'package:local_auth/local_auth.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthVerifyScreen extends StatefulWidget {
  static const id = '/localAuthVerify';

  VerifyModel navigationDetails;
  LocalAuthVerifyScreen({required this.navigationDetails});

  @override
  State<LocalAuthVerifyScreen> createState() => _LocalAuthVerifyScreenState();
}

class _LocalAuthVerifyScreenState extends State<LocalAuthVerifyScreen> {
  bool isDark = false;
  bool isOnlyPasscode = false;

  String password = '';
  String displayPassword = '';

  void _checkBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();
    try {} catch (e) {
      print(e);
    }

    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } catch (e) {
      print('biometric error $e');
    }

    if (availableBiometrics.isNotEmpty) {
      for (var ab in availableBiometrics) {
        print(ab);
      }
    } else {}

    bool authenticated = false;
    try {
      CommanClass.appLockStatus = 'biometricOff';

      authenticated = await auth.authenticate(
          localizedReason: 'Touch your finger on the sensor to login',
          options: const AuthenticationOptions(
            useErrorDialogs: false,
            stickyAuth: true,
          ));

      if (authenticated) {
        CommanClass.appLockStatus = 'unlock';
        if (widget.navigationDetails.isForward) {
          Navigator.pushReplacementNamed(
              context, widget.navigationDetails.routeName);
        } else {
          Navigator.pop(context, true);
        }
      } else {
        CommanClass.appLockStatus = 'biometricOff';
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  checkVerificationMethod() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('lockMethod') != null) {
      if (prefs.getString('lockMethod').toString() == 'Passcode/Biometric') {
        setState(() {
          isOnlyPasscode = true;
        });
        _checkBiometric();
      } else {
        setState(() {
          isOnlyPasscode = false;
        });
      }
    } else {
      setState(() {
        isOnlyPasscode = true;
      });
      _checkBiometric();
    }
  }

  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    checkVerificationMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.1,
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: isOnlyPasscode
                ? IconButton(
                    onPressed: () async {
                      _checkBiometric();
                    },
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.fingerprint,
                      color: Colors.black,
                      size: 48,
                    ),
                  )
                : null,
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (widget.navigationDetails.canGoBack == true) {
            return true;
          } else {
            exit(0);
          }
        },
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              Text(
                KeyValues.enterPasscode,
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
                  onKeyboardTap: _onKeyboardTap,
                  textColor: isDark ? Colors.white : Colors.black,
                  rightButtonFn: () {
                    if (password.isEmpty) {
                      return;
                    }
                    setState(() {
                      password = password.substring(0, password.length - 1);
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
                  if (password.length == 6) {
                    String authPass =
                        await SharedPreferenceClass.GetSharedData('loginPin');
                    if (authPass == password) {
                      CommanClass.appLockStatus = 'unlock';
                      if (widget.navigationDetails.isForward) {
                        Navigator.pushReplacementNamed(
                            context, widget.navigationDetails.routeName);
                      } else {
                        Navigator.pop(context, true);
                      }
                    } else if (password.isEmpty) {
                      ToastShowClass.coolToastShow(
                          context, 'Enter Passcode!', CoolAlertType.info);
                    } else {
                      setState(() {
                        ToastShowClass.coolToastShow(
                            context, 'Wrong Passcode!', CoolAlertType.info);
                        password = '';
                        displayPassword = '';
                      });
                    }
                  } else {
                    setState(() {
                      ToastShowClass.coolToastShow(
                          context, 'Wrong Passcode!', CoolAlertType.info);
                      password = '';
                      displayPassword = '';
                    });
                  }
                },
                child: Container(
                    width: width * 0.9,
                    decoration: BoxDecoration(
                        color: ColorCollection.backColor,
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
      ),
    );
  }

  _onKeyboardTap(String value) async {
    if (password.length >= 6) {
      ToastShowClass.coolToastShow(
          context, 'Wrong Passcode!', CoolAlertType.info);
    } else {
      setState(() {
        password = password + value;
        displayPassword = displayPassword + '*';
      });

      if (password.length == 6) {
        String authPass = await SharedPreferenceClass.GetSharedData('loginPin');
        print(authPass);
        if (authPass == password) {
          //Navigator.pushNamed(context, BottomNavigationBarScreen.id);
          CommanClass.appLockStatus = 'unlock';
          if (widget.navigationDetails.isForward) {
            Navigator.pushReplacementNamed(
                context, widget.navigationDetails.routeName);
          } else {
            Navigator.pop(context, true);
          }
        } else {
          setState(() {
            ToastShowClass.coolToastShow(
                context, 'Wrong Passcode!', CoolAlertType.info);
            password = '';
            displayPassword = '';
          });
        }
      }
    }
  }
}

class VerifyModel {
  bool isForward;
  String routeName;
  bool? canGoBack;

  VerifyModel(
      {required this.isForward, required this.routeName, this.canGoBack});
}
