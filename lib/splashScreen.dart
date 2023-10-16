// ignore_for_file: prefer_const_constructors, file_names, avoid_print, non_constant_identifier_names, import_of_legacy_library_into_null_safe, await_only_futures, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/OnBoarding/onBoardingScreen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/storage_manger.dart';

import '../LBM_Plugin/lbmplugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'util/Authenticatin/createPasswordScreen.dart';
import 'util/Authenticatin/localAuthVerifyScreen.dart';
import 'widgets/bottom_navigationbar.dart';

class SplashScreen extends StatefulWidget {
  static const id = '/';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loginPinExists = false;
  bool passCodeEnable = false;
  checkFirstTime() async {
    CommanClass.dashBoardfirtsTime =
        await SharedPreferenceClass.GetSharedData('dashBoardFirstTime') ?? true;
    CommanClass.taskDetailfirtsTime =
        await SharedPreferenceClass.GetSharedData('taskDetailFirstTime') ??
            true;
    bool showTask =
        await SharedPreferenceClass.GetSharedData('showTasks') ?? false;
    bool showSupport =
        await SharedPreferenceClass.GetSharedData('showSupport') ?? false;
    bool showProject =
        await SharedPreferenceClass.GetSharedData('showProjects') ?? false;
    CommanClass.showTask = showTask;
    CommanClass.showSupport = showSupport;
    CommanClass.showProjects = showProject;
  }

  checkWalletSetup() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('loginPin') != null) {
      final pass =
          await SharedPreferenceClass.GetSharedData('isPasscode') ?? true;
      setState(() {
        loginPinExists = true;
        passCodeEnable = pass;
      });
    } else {
      setState(() {
        loginPinExists = false;
      });
    }
  }

  /// Declare startTime to InitState
  @override
  void initState() {
    Timer(Duration(seconds: 4), () async {
      await checkWalletSetup();
      await checkFirstTime();
      initPlatformState(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/splash.jpg'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _CheckLogin() async {
    final paramDic = {
      "username": await SharedPreferenceClass.GetSharedData("email") ?? '',
      "password": await SharedPreferenceClass.GetSharedData("password") ?? '',
      "tokenid": await SharedPreferenceClass.GetSharedData("TokenID") ?? '',
      "tokenkey": await SharedPreferenceClass.GetSharedData("TokenKey") ?? '',
    };
    log("==>  $paramDic");

    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.LoginAPI, paramDic, "Get", Api_Key_by_Admin);
      var data = json.decode(response.body);
      print(data);
      if (data["status"] == 1) {
        log('passed' + response.statusCode.toString());

        SharedPreferenceClass.SetSharedData("ShowScreen", "True");
        SharedPreferenceClass.SetSharedData(
            "staff_id", data['data'][0]['staffid'].toString());
        SharedPreferenceClass.SetSharedData(
            "email", data['data'][0]['email'].toString());
        SharedPreferenceClass.SetSharedData(
            "firstname", data['data'][0]['firstname'].toString());
        SharedPreferenceClass.SetSharedData(
            "lastname", data['data'][0]['lastname'].toString());
        SharedPreferenceClass.SetSharedData(
            "phonenumber", data['data'][0]['phonenumber'].toString());
        SharedPreferenceClass.SetSharedData(
            "datecreated", data['data'][0]['datecreated'].toString());
        SharedPreferenceClass.SetSharedData(
            "datecreated", data['data'][0]['datecreated'].toString());
        SharedPreferenceClass.SetSharedData(
            "profile_image", data['data'][0]['profile_image'].toString());
        setState(() {
          CommanClass.StaffId = data['data'][0]['staffid'].toString();
        });
        // try {
        //   SharedPreferenceClass.SetSharedData("company_logo", data['logo'][0]['value']==null?"https://"+Base_Url_For_App+"/uploads/company/logo.png":"https://"+Base_Url_For_App+"/uploads/company/"+data['logo'][0]['value'].toString());
        // } on Exception catch (_) {
        SharedPreferenceClass.SetSharedData(
            "company_logo",
            "http://" +
                Base_Url_For_App +
                "/crm/uploads/company/" +
                data['logo'][0]['value'].toString());
        // }
        CommanClass.isLogin = true;
        SharedPreferenceClass.SetSharedData("isLogin", "True");
        loginPinExists == false
            ? Navigator.pushReplacementNamed(context, CreatePasswordScreen.id)
            : passCodeEnable
                ? Navigator.pushReplacementNamed(
                    context, LocalAuthVerifyScreen.id,
                    arguments:
                        VerifyModel(isForward: true, routeName: BottomBar.id))
                : Navigator.pushReplacementNamed(context, BottomBar.id);
      } else {
        print('Failed' + response.statusCode.toString());
        CommanClass.isLogin = false;
        Navigator.of(context).pushReplacementNamed(OnBoardingScreen.id);
      }
    } catch (e) {
      log('Error $e');
      CommanClass.isLogin = false;
      Navigator.of(context).pushReplacementNamed(OnBoardingScreen.id);
    }
  }

  Future<void> initPlatformState(BuildContext context) async {
    try {
      var platformVersion = await LbmPlugin.platformVersion(
          Base_Url_For_App, Purchase_Code_envato, Licence_Key_by_Admin);
      var data = json.decode(platformVersion.body);
      print(data['message']);
      if (data['message'] == "Allow") {
        setState(() {
          _CheckLogin();
          CommanClass.CheckResponse = "true";
        });
      } else {
        log('Error else init platform $data');
        setState(() {
          ToastShowClass.toastShow(context, 'UnAuthorised', Colors.red);
          CommanClass.CheckResponse = "false";
        });
      }
    } catch (e) {
      log('Error Occoured $e');
    }
  }
}
