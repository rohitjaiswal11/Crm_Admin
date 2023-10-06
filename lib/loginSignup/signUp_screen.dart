// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, import_of_legacy_library_into_null_safe, use_key_in_widget_constructors, must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:lbm_crm/loginSignup/login_screen.dart';
import 'package:lbm_crm/util/colors.dart';

class SignupScreen extends StatefulWidget {
  static const id = 'SignUpscreen';
  @override
  State<StatefulWidget> createState() {
    return _SignupScreen();
  }
}

class _SignupScreen extends State<SignupScreen> {
  bool checkBoxValue = false;
  double? _height;
  double? _width;
  double? _pixelRatio;
  bool? _large;
  bool? _medium;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);
    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width!,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                clipShape(),
                form(),
                acceptTermsTextRow(),
                SizedBox(
                  height: _height! / 35,
                ),
                button(),
                infoTextRow(),
                //signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large!
                  ? _height! / 8
                  : (_medium! ? _height! / 7 : _height! / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.blue],
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
              height: _large!
                  ? _height! / 12
                  : (_medium! ? _height! / 11 : _height! / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.blue],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: _height! / 5.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.0,
                  color: Colors.black26,
                  offset: Offset(1.0, 10.0),
                  blurRadius: 20.0),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
              onTap: () {
                print('Adding photo');
              },
              child: Icon(
                Icons.add_a_photo,
                size: _large! ? 40 : (_medium! ? 33 : 31),
                color: ColorCollection.backColor,
              )),
        ),
//        Positioned(
//          top: _height!/8,
//          left: _width!/1.75,
//          child: Container(
//            alignment: Alignment.center,
//            height: _height!/23,
//            padding: EdgeInsets.all(5),
//            decoration: BoxDecoration(
//              shape: BoxShape.circle,
//              color:  Colors.orange[100],
//            ),
//            child: GestureDetector(
//                onTap: (){
//                  print('Adding photo');
//                },
//                child: Icon(Icons.add_a_photo, size: _large!? 22: (_medium!? 15: 13),)),
//          ),
//        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width! / 12.0, right: _width! / 12.0, top: _height! / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height! / 60.0),
            lastNameTextFormField(),
            SizedBox(height: _height! / 60.0),
            emailTextFormField(),
            SizedBox(height: _height! / 60.0),
            phoneTextFormField(),
            SizedBox(height: _height! / 60.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "First Name",
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "Last Name",
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget phoneTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      icon: Icons.phone,
      hint: "Mobile Number",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      obscureText: true,
      icon: Icons.lock,
      hint: "Password",
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: ColorCollection.backColor,
              value: checkBoxValue,
              onChanged: (bool? newValue) {
                setState(() {
                  FocusScope.of(context).requestFocus(FocusNode());
                  checkBoxValue = newValue!;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large! ? 12 : (_medium! ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    // ignore: deprecated_member_use
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(LoginScreen.id);
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        foregroundColor: Colors.white,
        padding: EdgeInsets.all(0.0),
      ),
      child: Container(
        alignment: Alignment.center,
//        height: _height! / 20,
        width:
            _large! ? _width! / 4 : (_medium! ? _width! / 3.75 : _width! / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.green, Colors.blue],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'SIGN UP',
          style: TextStyle(fontSize: _large! ? 14 : (_medium! ? 12 : 10)),
        ),
      ),
    );
  }

  Widget infoTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Or create using social media",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large! ? 12 : (_medium! ? 11 : 10)),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  String? hint;
  TextEditingController? textEditingController;
  TextInputType? keyboardType;
  bool? obscureText;
  IconData? icon;
  double? _width;
  double? _pixelRatio;
  bool? large;
  bool? medium;

  CustomTextField({
    this.hint,
    this.textEditingController,
    this.keyboardType,
    this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    medium = ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: large! ? 12 : (medium! ? 10 : 8),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: keyboardType,
        cursorColor: ColorCollection.backColor,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: ColorCollection.backColor, size: 20),
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
