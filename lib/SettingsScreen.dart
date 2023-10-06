// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lbm_crm/Language/language.dart';
import 'package:lbm_crm/ThemeChanger.dart';
import 'package:lbm_crm/splashScreen.dart';
import 'package:lbm_crm/util/Authenticatin/createPasswordScreen.dart';
import 'package:lbm_crm/util/Authenticatin/localAuthVerifyScreen.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/storage_manger.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static const id = 'settingsSCreen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isPassCode = true;

  checkPasscode() async {
    isPassCode =
        await SharedPreferenceClass.GetSharedData('isPasscode') ?? true;
    setState(() {});
  }

  @override
  void initState() {
    checkPasscode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(KeyValues.settings),
          automaticallyImplyLeading: false,
          backgroundColor: ColorCollection.backColor,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: height * 0.05,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, ThemeChangerScreen.id);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: ColorCollection.backColor)),
                    title: Text(KeyValues.themeChanger,
                        style: ColorCollection.titleStyle2),
                    minLeadingWidth: 1,
                    leading: Icon(Icons.color_lens),
                    trailing: Icon(Icons.arrow_forward_ios),
                    tileColor: ColorCollection.navBarColor,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  ListTile(
                    // onTap: () {
                    //   Navigator.pushNamed(context, LocalAuthVerifyScreen.id,
                    //       arguments: VerifyModel(
                    //           isForward: true,
                    //           routeName: CreatePasswordScreen.id));
                    // },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: ColorCollection.backColor)),
                    title: Text(KeyValues.passCode,
                        style: ColorCollection.titleStyle2),
                    minLeadingWidth: 1,
                    leading: Icon(Icons.password),
                    trailing: Switch(
                        value: isPassCode,
                        onChanged: (val) {
                          SharedPreferenceClass.SetSharedData(
                              'isPasscode', val);
                          setState(() {
                            isPassCode = val;
                          });
                        }),
                    tileColor: ColorCollection.navBarColor,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  ListTile(
                    onTap: () {
                      if (isPassCode) {
                        Navigator.pushNamed(context, LocalAuthVerifyScreen.id,
                            arguments: VerifyModel(
                                isForward: true,
                                routeName: CreatePasswordScreen.id,
                                canGoBack: true));
                      } else {
                        ToastShowClass.coolToastShow(context,
                            'Enable Passcode First', CoolAlertType.info);
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: ColorCollection.backColor)),
                    title: Text(KeyValues.changePasscode,
                        style: ColorCollection.titleStyle2),
                    minLeadingWidth: 1,
                    leading: Icon(Icons.password),
                    trailing: Icon(Icons.arrow_forward_ios),
                    tileColor: ColorCollection.navBarColor,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, LanguageView.id);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: ColorCollection.backColor)),
                    title: Text(KeyValues.selectLanguage,
                        style: ColorCollection.titleStyle2),
                    minLeadingWidth: 1,
                    leading: Icon(Icons.language),
                    trailing: Icon(Icons.arrow_forward_ios),
                    tileColor: ColorCollection.navBarColor,
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red)),
                      onPressed: () async {
                        await SharedPreferenceClass.clearAllData()
                            .whenComplete(() async {
                          await Provider.of<ColorCollection>(context,
                                  listen: false)
                              .changeColor('0xFF68A642', '0xFF000000',
                                  '0xFFFFFFFF', '0xFFFFFFFF');
                          await context.setLocale(context.supportedLocales[0]);
                          await Provider.of<KeyValues>(context, listen: false)
                              .changeTodefault();
                          await Provider.of<KeyValues>(context, listen: false)
                              .changeLang();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => SplashScreen())),
                              (route) => false);
                        });
                      },
                      child: Text(
                        KeyValues.resetApp,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w700),
                      ))
                ],
              ),
              SizedBox(
                height: height * 0.15,
              )
            ],
          ),
        ));
  }
}
