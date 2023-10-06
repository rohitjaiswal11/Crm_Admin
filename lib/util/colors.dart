// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/storage_manger.dart';

var appcolors;
var textColor;
var appbarTextColor;
var containerColor;

class ColorCollection with ChangeNotifier {
  static Color grey = Color(0xFFF2F2F2);
  static Color green = Color(int.parse(appcolors.toString()));
  static Color lightgreen =
      lighten(Color(int.parse(appcolors.toString())), 0.4);

  static Color backColor =
      Color(int.parse(appcolors.toString())); //  Background Color
  static Color tabBarEnabled =
      Color(int.parse(appcolors.toString())); // DashBoard Tabs Color
  static Color tabBarDisabled = Color(0xFFEEF1ED); // DashBoard Tabs Color
  static Color iconBack = lighten(Color(int.parse(appcolors.toString())),
      0.4); // Bottom Navigation Bar Icon Background Color
  static Color iconColor = Color(
      int.parse(appcolors.toString())); // Bottom Navigation Bar Icon Color
  static Color navBarColor = lighten(Color(int.parse(appcolors.toString())),
      0.3); // Bottom Navigation Bar Color
  static Color titleColor =
      Color(int.parse(appcolors.toString())); // Titles Color
  static Color totalItem = lighten(Color(int.parse(appcolors.toString())), 0.3);
  static Color white = Color(int.parse(appbarTextColor.toString()));
  static Color black = Color(int.parse(textColor.toString()));
  static Color containerC = Color(int.parse(containerColor.toString()));

  static Color darkGreen = darken(Color(int.parse(appcolors.toString())), 0.2);

  //Title Styles (GREEN COLOR)
  static TextStyle titleStyleGreen = TextStyle(
      color: Color(int.parse(appcolors.toString())),
      fontSize: 18,
      fontWeight: FontWeight.w600);
  static TextStyle titleStyleGreen2 = TextStyle(
      color: Color(int.parse(appcolors.toString())),
      fontSize: 14,
      fontWeight: FontWeight.w600);
  static TextStyle titleStyleGreen3 = TextStyle(
      color: Color(int.parse(appcolors.toString())),
      fontSize: 12,
      fontWeight: FontWeight.w600);

  //Title Styles (DARK GREEN COLOR)
  static TextStyle darkGreenStyle = TextStyle(
      color: Color(int.parse(appcolors.toString())),
      fontWeight: FontWeight.bold,
      fontSize: 13);
  static TextStyle darkGreenStyle2 = TextStyle(
      color: Color(int.parse(appcolors.toString())),
      fontWeight: FontWeight.w500,
      fontSize: 11);

  // Screen's Main Heading Text Style
  static TextStyle screenTitleStyle = TextStyle(
      fontSize: 22,
      color: Color(int.parse(appbarTextColor.toString())),
      fontWeight: FontWeight.w600);

  //Button's Text Style
  static TextStyle buttonTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Color(int.parse(appbarTextColor.toString())));

  //Title Styles (BLACK COLOR)
  static TextStyle smalltTtleStyle = TextStyle(
      fontSize: 10,
      color: Color(int.parse(textColor.toString())),
      fontWeight: FontWeight.w600);
  static TextStyle titleStyle = TextStyle(
      fontSize: 12,
      color: Color(int.parse(textColor.toString())),
      fontWeight: FontWeight.w600);
  static TextStyle titleStyle2 = TextStyle(
      fontSize: 14,
      color: Color(int.parse(textColor.toString())),
      fontWeight: FontWeight.w600);

  //Subtitle Styles (GREY COLOR)
  static TextStyle subTitleStyle =
      TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500);
  static TextStyle subTitleStyle2 =
      TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500);
  static TextStyle subTitleStyle3 =
      TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w700);

  //Title Styles (WHITE COLOR)
  static TextStyle titleStyleWhite = TextStyle(
      fontSize: 12,
      color: Color(int.parse(appbarTextColor.toString())),
      fontWeight: FontWeight.bold);
  static TextStyle titleStyleWhite2 = TextStyle(
      color: Color(int.parse(appbarTextColor.toString())),
      fontSize: 10,
      fontWeight: FontWeight.bold);

  static TextStyle subTitleStyleRed =
      TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.red);

  changeColor(
      String color, String tcolor, String appBarColor, String ContainerColor) {
    SharedPreferenceClass.SetSharedData('appBarColor', color);
    SharedPreferenceClass.SetSharedData('textColor', tcolor);
    SharedPreferenceClass.SetSharedData('appBarTextColor', appBarColor);
    SharedPreferenceClass.SetSharedData('containerC', ContainerColor);

    SharedPreferenceClass.SetSharedData('themeBool', "True");

    ColorCollection.backColor = Color(int.parse(color.toString()));
    ColorCollection.tabBarEnabled = Color(int.parse(color.toString()));
    ColorCollection.iconBack = lighten(Color(int.parse(color.toString())), 0.4);
    ColorCollection.iconColor = Color(int.parse(color.toString()));
    ColorCollection.navBarColor =
        lighten(Color(int.parse(color.toString())), 0.3);
    ColorCollection.titleColor = Color(int.parse(color.toString()));
    ColorCollection.totalItem =
        lighten(Color(int.parse(color.toString())), 0.3);
    ColorCollection.black = Color(int.parse(tcolor.toString()));
    ColorCollection.white = Color(int.parse(appBarColor.toString()));
    ColorCollection.green = Color(int.parse(color.toString()));
    ColorCollection.darkGreen = Color(int.parse(color.toString()));
    ColorCollection.lightgreen =
        lighten(Color(int.parse(color.toString())), 0.4);
    ColorCollection.containerC = Color(int.parse(ContainerColor.toString()));
    //Title Styles (GREEN COLOR)
    titleStyleGreen = TextStyle(
        color: Color(int.parse(color.toString())),
        fontSize: 18,
        fontWeight: FontWeight.w600);
    titleStyleGreen2 = TextStyle(
        color: Color(int.parse(color.toString())),
        fontSize: 14,
        fontWeight: FontWeight.w600);
    titleStyleGreen3 = TextStyle(
        color: Color(int.parse(color.toString())),
        fontSize: 12,
        fontWeight: FontWeight.w600);

    //Title Styles (DARK GREEN COLOR)
    darkGreenStyle = TextStyle(
        color: Color(int.parse(color.toString())),
        fontWeight: FontWeight.bold,
        fontSize: 13);
    darkGreenStyle2 = TextStyle(
        color: Color(int.parse(color.toString())),
        fontWeight: FontWeight.w500,
        fontSize: 11);

    // Screen's Main Heading Text Style
    screenTitleStyle = TextStyle(
        fontSize: 22,
        color: Color(int.parse(appBarColor.toString())),
        fontWeight: FontWeight.w600);

    //Button's Text Style
    buttonTextStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Color(int.parse(appBarColor.toString())));

    //Title Styles (BLACK COLOR)
    smalltTtleStyle = TextStyle(
        fontSize: 10,
        color: Color(int.parse(tcolor.toString())),
        fontWeight: FontWeight.w600);
    titleStyle = TextStyle(
        fontSize: 12,
        color: Color(int.parse(tcolor.toString())),
        fontWeight: FontWeight.w600);
    titleStyle2 = TextStyle(
        fontSize: 14,
        color: Color(int.parse(tcolor.toString())),
        fontWeight: FontWeight.w600);

    //Subtitle Styles (GREY COLOR)
    subTitleStyle = TextStyle(
        fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500);
    subTitleStyle2 = TextStyle(
        fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500);
    subTitleStyle3 = TextStyle(
        fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w700);

    //Title Styles (WHITE COLOR)
    titleStyleWhite = TextStyle(
        fontSize: 12,
        color: Color(int.parse(appBarColor.toString())),
        fontWeight: FontWeight.bold);
    titleStyleWhite2 = TextStyle(
        color: Color(int.parse(appBarColor.toString())),
        fontSize: 10,
        fontWeight: FontWeight.bold);

    subTitleStyleRed =
        TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.red);

    notifyListeners();
  }
}
/* static Color grey = Color(0xFFF2F2F2);
  static Color green = Color(0xFF71A751);
  static Color lightgreen = Color(0xFF76AE53);
  static Color backColor = Color(0xFF68A642); //  Background Color
  static Color tabBarEnabled = Color(0xFF73AC4F); // DashBoard Tabs Color
  static Color tabBarDisabled = Color(0xFFEEF1ED); // DashBoard Tabs Color
  static Color iconBack =
      Color(0xFFC2E7B1); // Bottom Navigation Bar Icon Background Color
  static Color iconColor =
      Color(0xFF66C23D); // Bottom Navigation Bar Icon Color
  static Color navBarColor = Color(0xFFF4F4F4); // Bottom Navigation Bar Color
  static Color titleColor = Color(0xFF76AF54); // Titles Color
  static Color totalItem = Color(0xFFE7F5E0);
  static Color white = Color(0xFFFFFFFF);
  static Color black = Color(0xFF000000);
  static Color darkGreen = Color(0xFF426C29);*/