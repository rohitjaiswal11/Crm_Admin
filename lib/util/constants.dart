// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lbm_crm/util/colors.dart';

// top rounded container
BoxDecoration kContaierDeco = BoxDecoration(
  boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
  color: ColorCollection.containerC,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
  ),
);

// form fields decoration
BoxDecoration kDropdownContainerDeco = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: Color(0xFFFBF8F8),
    border: Border.all(color: Colors.grey.shade200, width: 2),
    boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 3)]);

// form fields text styles
TextStyle kTextformHintStyle = TextStyle(color: Colors.grey, fontSize: 10);
TextStyle kTextformStyle = TextStyle(fontSize: 12);
TextStyle googleStyle = GoogleFonts.montserrat();

// Color Changer ---> ranges from 0.0 to 1.0 <--- //

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
