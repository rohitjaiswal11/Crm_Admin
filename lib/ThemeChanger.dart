// ignore_for_file: prefer_const_constructors, file_names, avoid_print, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/widgets/bottom_navigationbar.dart';
import 'package:provider/provider.dart';

class ThemeChangerScreen extends StatefulWidget {
  static const id = 'themechanger';

  @override
  State<StatefulWidget> createState() => ThemeChangerScreenState();
}

class ThemeChangerScreenState extends State<ThemeChangerScreen> {
  Color currentColor = ColorCollection.backColor;
  Color currentTextColor = ColorCollection.black;
  Color currentAppBarColor = ColorCollection.white;
  Color CurrentContainerColor = ColorCollection.containerC;
  bool isLoading = false;

  changeColor(Color color) {
    setState(() {
      currentColor = color;
    });
  }

  changeTextColor(Color color) {
    setState(() {
      currentTextColor = color;
    });
  }

  changeAppBaColor(Color color) {
    setState(() {
      currentAppBarColor = color;
    });
  }

  changeContaienrColor(Color color) {
    setState(() {
      CurrentContainerColor = color;
    });
  }

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(KeyValues.themeChanger),
        backgroundColor: currentColor,
        centerTitle: true,
        actions: [
          IconButton(
              tooltip: 'Reset',
              onPressed: () async {
                setState(() {
                  isLoading = true;
                  ToastShowClass.toastShow(
                      context, 'Resetting to Default  ', Colors.green);
                });

                await Provider.of<ColorCollection>(context, listen: false)
                    .changeColor(
                        '0xFF68A642', '0xFF000000', '0xFFFFFFFF', '0xFFFFFFFF');
                setState(() {
                  isLoading = false;
                });
                if (isLoading == false) {
                  ToastShowClass.coolToastShow(
                      context, 'Reset Done', CoolAlertType.success);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    BottomBar.id,
                    (route) => false,
                  );
                }
              },
              icon: Icon(Icons.restart_alt_outlined)),
          IconButton(
              tooltip: 'Save',
              onPressed: () async {
                setState(() {
                  isLoading = true;
                  ToastShowClass.toastShow(context, 'Changing', Colors.green);
                });
                await Provider.of<ColorCollection>(context, listen: false)
                    .changeColor(
                        currentColor.value.toString(),
                        currentTextColor.value.toString(),
                        currentAppBarColor.value.toString(),
                        CurrentContainerColor.value.toString());

                setState(() {
                  isLoading = false;
                });
                if (isLoading == false) {
                  ToastShowClass.coolToastShow(
                      context, 'Saved Successfully', CoolAlertType.success);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    BottomBar.id,
                    (route) => false,
                  );
                }
              },
              icon: Icon(Icons.save)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MaterialPicker(
                pickerColor: currentColor, onColorChanged: changeColor),
            Divider(
              color: currentColor,
            ),
            SizedBox(height: 25),
            Text(
              " TEXT COLOR CHANGE",
              style: TextStyle(color: currentTextColor),
            ),
            MaterialPicker(
                pickerColor: currentTextColor, onColorChanged: changeTextColor),
            Divider(
              color: currentColor,
            ),
            SizedBox(height: 25),
            Text(
              " APP BAR TITLE COLOR ",
              style: TextStyle(
                  color: currentAppBarColor, fontWeight: FontWeight.bold),
            ),
            MaterialPicker(
                pickerColor: currentAppBarColor,
                onColorChanged: changeAppBaColor),
            Divider(
              color: currentColor,
            ),
            SizedBox(height: 25),
            Container(
              padding: EdgeInsets.all(8),
              color: CurrentContainerColor,
              child: Text(
                " CONTAINER COLOR ",
                style: TextStyle(color: currentTextColor),
              ),
            ),
            MaterialPicker(
                pickerColor: CurrentContainerColor,
                onColorChanged: changeContaienrColor),
            Divider(
              color: currentColor,
            ),
            SizedBox(height: 10),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(currentColor)),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                    ToastShowClass.toastShow(context, 'Changing', Colors.green);
                  });
                  await Provider.of<ColorCollection>(context, listen: false)
                      .changeColor(
                          currentColor.value.toString(),
                          currentTextColor.value.toString(),
                          currentAppBarColor.value.toString(),
                          CurrentContainerColor.value.toString());

                  setState(() {
                    isLoading = false;
                  });
                  if (isLoading == false) {
                    ToastShowClass.coolToastShow(
                        context, 'Saved Successfully', CoolAlertType.success);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      BottomBar.id,
                      (route) => false,
                    );
                  }
                },
                child: Text(
                  KeyValues.save,
                  style: TextStyle(color: currentAppBarColor),
                )),
            Divider(
              color: currentColor,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(currentColor)),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                    ToastShowClass.toastShow(
                        context, 'Resetting to Default  ', Colors.green);
                  });

                  await Provider.of<ColorCollection>(context, listen: false)
                      .changeColor('0xFF68A642', '0xFF000000', '0xFFFFFFFF',
                          '0xFFFFFFFF');
                  setState(() {
                    isLoading = false;
                  });
                  if (isLoading == false) {
                    ToastShowClass.coolToastShow(
                        context, 'Reset Done', CoolAlertType.success);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      BottomBar.id,
                      (route) => false,
                    );
                  }
                },
                child: Text(
                  KeyValues.resetColors,
                  style: TextStyle(color: currentAppBarColor),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            )
          ],
        ),
      ),
    );
  }
}
