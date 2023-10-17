// ignore_for_file: prefer_const_constructors, avoid_print, import_of_legacy_library_into_null_safe, use_key_in_widget_constructors, deprecated_member_use, await_only_futures

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/Authenticatin/createPasswordScreen.dart';
import 'package:lbm_crm/util/Authenticatin/localAuthVerifyScreen.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/storage_manger.dart';
import 'package:lbm_crm/widgets/bottom_navigationbar.dart';

import '../Plugin/lbmplugin.dart';

GlobalKey<FormState> _key = GlobalKey();

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginScreen extends StatefulWidget {
  static const id = 'loginscreen';
  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  bool _obscureText = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final _messaging = FirebaseMessaging.instance;
      SharedPreferenceClass.SetSharedData("TokenKey",
          "AAAAMue_ylA:APA91bHIASApWJVz-VTt2PJ0wVGo4lik1x9OtO290ECgYgFemSBFM6R5uRDdLHO_riqN9XQO12r2AJwu1j-BjSp7zZpHVdZopjCsOuqOLB5E0bPKtyfLauV97cRqI9ZfTCCrMu2spAHy");
      _messaging.getToken().then((token) {
        log("$token");
        SharedPreferenceClass.SetSharedData("TokenID", token);
      });
    });
    super.initState();
    initPlatformState(context);
    setState(() {
      emailController.text = 'support@lbmsolution.in';
      passwordController.text = "1234";
    });
  }

  Future<void> initPlatformState(BuildContext context) async {
    var platformVersion = await LbmPlugin.platformVersion(
        Base_Url_For_App, Purchase_Code_envato, Licence_Key_by_Admin);
    var data = json.decode(platformVersion.body);
    print(data['message']);
    if (data['message'] == "Allow") {
      if (mounted) {
        setState(() {
          CommanClass.CheckResponse = "true";
        });
      }
    } else {
      setState(() {
        CommanClass.CheckResponse = "false";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            clipShape(),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  welcomeTextRow(),
                  signInTextRow(),
                  form(),
                  forgetPassTextRow(),
                  SizedBox(height: _height / 12),
//              button(),
                  AnimatedProgressButton(),
                ],
              ),
            ),
            signUpTextRow(),
          ],
        ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorCollection.darkGreen,
                    ColorCollection.backColor
                  ],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorCollection.darkGreen,
                    ColorCollection.backColor
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height / 30
                  : (_medium ? _height / 25 : _height / 20)),
          child: Image.asset(
            'assets/logo.png',
            height: _height / 5.5,
            width: _width / 1.3,
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              color: ColorCollection.backColor,
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height / 40.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextFormField(
          onChanged: (String value) {},
          cursorColor: ColorCollection.backColor,
          controller: emailController,
          textInputAction: TextInputAction.next,
//          focusNode: _userFocus,
//          onFieldSubmitted: (term){
//            _fieldFocusChange(context,_userFocus,_passFocus);
//          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Username is Empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "username",
              prefixIcon: Material(
                elevation: 0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Icon(
                  Icons.account_circle,
                  size: 20,
                  color: ColorCollection.backColor,
                ),
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
        ),
      ),
    );
  }

  Widget passwordTextFormField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextFormField(
          onChanged: (String value) {},
          cursorColor: ColorCollection.backColor,
          obscureText: _obscureText,
          textInputAction: TextInputAction.done,
//          focusNode: _passFocus,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Password is Empty';
            }
            return null;
          },
          controller: passwordController,
          decoration: InputDecoration(
              hintText: "password",
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                  color: ColorCollection.backColor,
                ),
              ),
              prefixIcon: Material(
                elevation: 0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Icon(
                  Icons.lock,
                  size: 20,
                  color: ColorCollection.backColor,
                ),
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
        ),
      ),
    );
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              "Recover",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.green),
            ),
          )
        ],
      ),
    );
  }

  Widget button() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        foregroundColor: Colors.white,
        padding: EdgeInsets.all(0.0),
      ),
      onPressed: () {},
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[
              ColorCollection.darkGreen,
              ColorCollection.backColor
            ],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('SIGN IN',
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              // Navigator.of(context).pushNamed(SignupScreen.id);
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.green,
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          )
        ],
      ),
    );
  }
}

class AnimatedProgressButton extends StatefulWidget {
  @override
  _AnimatedProgressButtonState createState() => _AnimatedProgressButtonState();
}

class _AnimatedProgressButtonState extends State<AnimatedProgressButton>
    with SingleTickerProviderStateMixin {
  // Defining Animations and Animation Controller
  late Animation<double> _animatedSize;
  late Animation<Color?> _animatedColor;
  late AnimationController _boss;
  bool _loading = false;

// Initialize Animations and AnimationController
  @override
  void initState() {
    super.initState();
    // AnimationController
    _boss =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    // Animations
    // size using Tween<double>
    _animatedSize = Tween<double>(begin: 0, end: 300).animate(_boss)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _boss.repeat();
        }
      });
    // color using a subclass of Tween, ColorTween
    _animatedColor =
        ColorTween(begin: Colors.yellow, end: Colors.red).animate(_boss);
  }

  // Never forget to dispose the AnimationController
  // to avoid memory leaks
  @override
  void dispose() {
    _boss.dispose();
    super.dispose();
  }

  void submitAction() {
    _boss.forward();
    setState(() {
      if (_key.currentState!.validate()) {
        _loading = true;
        _loginUser();
      } else {
        _loading = false;
      }
    });
    Timer(Duration(seconds: 2), () {
      _boss.stop();
      _boss.reset();
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40),
            width: _animatedSize.value,
            height: 5,
            decoration: BoxDecoration(color: _animatedColor.value),
          ),
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorCollection.backColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                disabledBackgroundColor: Colors.black,
              ),
              onPressed: _loading ? null : submitAction,
              child: Text(
                "Sign In",
                style: ColorCollection.buttonTextStyle,
              ),
            ),
          )
        ],
      );

  //hit the login api on server
  Future<void> _loginUser() async {
    final tokenId = await SharedPreferenceClass.GetSharedData("TokenID");
    final tokenKey =
        await await SharedPreferenceClass.GetSharedData("TokenKey");
    final paramDic = {
      "username": emailController.text,
      "password": passwordController.text,
      "tokenid": tokenId,
      "tokenkey": tokenKey,
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.LoginAPI, paramDic, "Get", Api_Key_by_Admin);
        log(response.body.toString());
    var data = json.decode(response.body);
    log('Login info -----' + data.toString());

    if (data["status"] == 1) {
      print(data['data'][0]['staffid'].toString());
      SharedPreferenceClass.SetSharedData("password", passwordController.text);
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
      // try {
      //   SharedPreferenceClass.SetSharedData("company_logo", data['logo'][0]['value']==null?"https://"+Base_Url_For_App+"/uploads/company/logo.png":"https://"+Base_Url_For_App+"/uploads/company/"+data['logo'][0]['value'].toString());
      // } on Exception catch (_) {
      if (data['logo'] != null)
        SharedPreferenceClass.SetSharedData(
            "company_logo",
            "http://" +
                Base_Url_For_App +
                "/crm/uploads/company/" +
                data['logo'][0]['value'].toString());
      // }
      var authPass = await SharedPreferenceClass.GetSharedData('loginPin');
      SharedPreferenceClass.SetSharedData("isLogin", "True");
      authPass == null
          ? Navigator.pushReplacementNamed(context, CreatePasswordScreen.id)
          : Navigator.of(context).pushReplacementNamed(LocalAuthVerifyScreen.id,
              arguments: VerifyModel(isForward: true, routeName: BottomBar.id));
//      Scaffold
//          .of(context)
//          .showSnackBar(SnackBar(content: Text('Login Successful')));
    } else {
        ToastShowClass.coolToastShow(context, data["message"], CoolAlertType.error);
    }
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 70);

    var firstEndPoint = Offset(size.width * .5, size.height - 30.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height - 50.0);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 50.0);
    var secondControlPoint = Offset(size.width * .75, size.height - 10);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class CustomShapeClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 20);

    var firstEndPoint = Offset(size.width * .5, size.height - 30.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height - 50.0);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 5);
    var secondControlPoint = Offset(size.width * .75, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class ResponsiveWidget {
  static bool isScreenLarge(double width, double pixel) {
    return width * pixel >= 1440;
  }

  static bool isScreenMedium(double width, double pixel) {
    return width * pixel < 1440 && width * pixel >= 1080;
  }

  static bool isScreenSmall(double width, double pixel) {
    return width * pixel <= 720;
  }
}
