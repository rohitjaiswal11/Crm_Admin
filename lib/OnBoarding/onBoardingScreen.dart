// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lbm_crm/loginSignup/login_screen.dart';
import 'package:lbm_crm/util/Authenticatin/createPasswordScreen.dart';
import 'package:lbm_crm/util/Authenticatin/localAuthVerifyScreen.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/storage_manger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/bottom_navigationbar.dart';

class OnBoardingScreen extends StatefulWidget {
  static const id = 'OnBoarding';
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late Widget materialButton;
  int index = 0;
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

  @override
  void initState() {
    checkWalletSetup();
    checkFirstTime();
    super.initState();
    materialButton = _skipButton;
  }

  Widget get _skipButton {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () {
        print('pressed');
        CommanClass.isLogin
            ? loginPinExists == false
                ? Navigator.pushReplacementNamed(
                    context, CreatePasswordScreen.id)
                : passCodeEnable
                    ? Navigator.pushReplacementNamed(
                        context, LocalAuthVerifyScreen.id,
                        arguments: VerifyModel(
                            isForward: true, routeName: BottomBar.id))
                    : Navigator.pushReplacementNamed(context, BottomBar.id)
            : Navigator.pushReplacementNamed(context, LoginScreen.id);
      },
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
        child: Text(
          'SKIP',
          style: TextStyle(
              color: ColorCollection.backColor,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget get _doneButton {
    return Align(
      alignment: Alignment.bottomRight,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          CommanClass.isLogin
              ? loginPinExists == false
                  ? Navigator.pushReplacementNamed(
                      context, CreatePasswordScreen.id)
                  : passCodeEnable
                      ? Navigator.pushReplacementNamed(
                          context, LocalAuthVerifyScreen.id,
                          arguments: VerifyModel(
                              isForward: true, routeName: BottomBar.id))
                      : Navigator.pushReplacementNamed(context, BottomBar.id)
              : Navigator.pushReplacementNamed(context, LoginScreen.id);
        },
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent,
          child: Text(
            'DONE',
            style: TextStyle(
                color: Color(0XFFF8F6F6),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final pages = [
      PageViewModel(
        title: 'Sales Automations',
        decoration: PageDecoration(
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            bodyPadding: EdgeInsets.symmetric(horizontal: width * 0.15),
            imagePadding: EdgeInsets.symmetric(vertical: height * 0.04),
            imageFlex: 2,
            bodyTextStyle: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w500)),
        body: 'Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum',
        image: Image.asset(
          'assets/o1.png',
          fit: BoxFit.fill,
        ),
        reverse: true,
      ),
      PageViewModel(
          decoration: PageDecoration(
              titleTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              bodyPadding: EdgeInsets.symmetric(horizontal: width * 0.15),
              imagePadding: EdgeInsets.symmetric(vertical: height * 0.04),
              imageFlex: 2,
              bodyTextStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
          reverse: true,
          body: 'Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum',
          title: 'Marketing Automations',
          image: Image.asset(
            'assets/o2.png',
            fit: BoxFit.fill,
          )),
      PageViewModel(
          decoration: PageDecoration(
              titleTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              bodyPadding: EdgeInsets.symmetric(horizontal: width * 0.15),
              imagePadding: EdgeInsets.symmetric(vertical: height * 0.04),
              imageFlex: 2,
              bodyTextStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
          reverse: true,
          body: 'Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum',
          title: 'Service Automations',
          image: Image.asset(
            'assets/o3.png',
            fit: BoxFit.fill,
          )),
      PageViewModel(
          decoration: PageDecoration(
              titleTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              bodyPadding: EdgeInsets.symmetric(horizontal: width * 0.15),
              imagePadding: EdgeInsets.symmetric(vertical: height * 0.04),
              imageFlex: 2,
              bodyTextStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
          reverse: true,
          body: 'Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum',
          title: 'Analytical CRM',
          image: Image.asset(
            'assets/o4.png',
            fit: BoxFit.fill,
          )),
      PageViewModel(
          decoration: PageDecoration(
              titleTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              bodyPadding: EdgeInsets.symmetric(horizontal: width * 0.15),
              imagePadding: EdgeInsets.symmetric(vertical: height * 0.04),
              imageFlex: 2,
              bodyTextStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
          reverse: true,
          body: 'Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum',
          title: 'Collaborative CRM',
          image: Image.asset(
            'assets/o5.png',
            fit: BoxFit.fill,
          )),
    ];
    return Scaffold(
        backgroundColor: Color(0XFFF8F6F6),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RotatedBox(
                  quarterTurns: 2,
                  child: Image.asset(
                    'assets/onbStart.png',
                    height: height * 0.4,
                    width: width * 0.7,
                    color: ColorCollection.backColor,
                    fit: BoxFit.fill,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RotatedBox(
                      quarterTurns: 4,
                      child: Image.asset(
                        'assets/onbStart.png',
                        height: height * 0.4,
                        color: ColorCollection.backColor,
                        width: width * 0.7,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                height: height * 0.6,
                width: width,
                child: IntroductionScreen(
                  globalBackgroundColor: Colors.transparent,
                  onChange: (index) {
                    setState(() {
                      this.index = index;
                      print(this.index);
                    });
                  },
                  showDoneButton: true,
                  skip: _skipButton,
                  done: _doneButton,
                  showSkipButton: true,
                  pages: pages,
                  onDone: () {
                    print('done');
                    CommanClass.isLogin
                        ? loginPinExists == false
                            ? Navigator.pushReplacementNamed(
                                context, CreatePasswordScreen.id)
                            : passCodeEnable
                                ? Navigator.pushReplacementNamed(
                                    context, LocalAuthVerifyScreen.id,
                                    arguments: VerifyModel(
                                        isForward: true,
                                        routeName: BottomBar.id))
                                : Navigator.pushReplacementNamed(
                                    context, BottomBar.id)
                        : Navigator.pushReplacementNamed(
                            context, LoginScreen.id);
                  },
                  onSkip: () {
                    print('skip');
                    CommanClass.isLogin
                        ? loginPinExists == false
                            ? Navigator.pushReplacementNamed(
                                context, CreatePasswordScreen.id)
                            : passCodeEnable
                                ? Navigator.pushReplacementNamed(
                                    context, LocalAuthVerifyScreen.id,
                                    arguments: VerifyModel(
                                        isForward: true,
                                        routeName: BottomBar.id))
                                : Navigator.pushReplacementNamed(
                                    context, BottomBar.id)
                        : Navigator.pushReplacementNamed(
                            context, LoginScreen.id);
                  },
                  showNextButton: false,
                ),
              ),
            ),
          ],
        ));
  }
}

/**   return Scaffold(
        backgroundColor: Color(0XFFF8F6F6),
        body: Stack(
          children: [
            Onboarding(
              pages: pages,
              onPageChange: (int pageIndex) {
                _buildButton(pageIndex);
              },
            ),
            Container(
              margin:
                  EdgeInsets.only(bottom: height * 0.02, right: width * 0.1),
              alignment: Alignment.bottomRight,
              child: materialButton,
            )
          ],
        ));
  **/
