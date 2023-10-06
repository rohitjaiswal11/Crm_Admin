// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/widgets/bottom_navigationbar.dart';
import 'package:provider/provider.dart';

import '../util/colors.dart';

class LanguageView extends StatelessWidget {
  static const id = 'langView';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(KeyValues.language),
        backgroundColor: ColorCollection.backColor,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 26),
              margin: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                'Choose language',
                style: TextStyle(
                  color: ColorCollection.backColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            _Divider(),
            _SwitchListTileMenuItem(
                title: 'English',
                subtitle: 'English',
                locale: context.supportedLocales[0]),
            _Divider(),
            _SwitchListTileMenuItem(
                title: 'Deutsch',
                subtitle: 'German',
                locale: context.supportedLocales[1]),
            _Divider(),
            _SwitchListTileMenuItem(
                title: 'Español',
                subtitle: 'Spanish',
                locale: context.supportedLocales[2]),
            _Divider(),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Divider(color: ColorCollection.navBarColor),
    );
  }
}

class _SwitchListTileMenuItem extends StatelessWidget {
  const _SwitchListTileMenuItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.locale,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Locale locale;

  bool isSelected(BuildContext context) => locale == context.locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: isSelected(context)
            ? Border.all(
                color: ColorCollection.backColor,
              )
            : null,
      ),
      child: ListTile(
          dense: true,
          // isThreeLine: true,
          title: Text(
            title,
          ),
          subtitle: Text(
            subtitle,
          ),
          onTap: () async {
            log(locale.toString(), name: toString());
            await context.setLocale(locale); //BuildContext extension method
            await Provider.of<KeyValues>(context, listen: false)
                .changeTodefault();
            await Provider.of<KeyValues>(context, listen: false).changeLang();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => (BottomBar()),
                ),
                (route) => false);
          }),
    );
  }
}
