// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, must_be_immutable, import_of_legacy_library_into_null_safe, avoid_print, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';


import '../LBM_Plugin/lbmplugin.dart';

class AddNewAnnouncementScreen extends StatefulWidget {
  static const id = '/AddNewAnnouncement';
  List EditData = [];
  AddNewAnnouncementScreen({required this.EditData});

  @override
  State<AddNewAnnouncementScreen> createState() =>
      _AddNewAnnouncementScreenState();
}

class _AddNewAnnouncementScreenState extends State<AddNewAnnouncementScreen> {
  HtmlEditorController controller = HtmlEditorController();
  TextEditingController subjectcontroller = TextEditingController();
  final _formKeyDetail = GlobalKey<FormState>();

  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool save = false;
  @override
  void dispose() {
    if (widget.EditData != null) {
      widget.EditData.clear();
    }
    super.dispose();
  }

  @override
  void initState() {
    if (widget.EditData != null) {
      subjectcontroller.text = widget.EditData[0]['name'] == null
          ? ""
          : widget.EditData[0]['name'].toString();
      controller.setText(widget.EditData[0]['message'] == null
          ? ""
          : widget.EditData[0]['message'].toString());
      widget.EditData[0]['showtostaff'] == '1' ? isChecked1 = true : false;
      widget.EditData[0]['showtousers'] == '1' ? isChecked2 = true : false;
      widget.EditData[0]['showname'] == '1' ? isChecked3 = true : false;
    } else {}

    super.initState();
  }

  void AddAnnouncements(String? message, String? id) async {
    Map<String, String> paramDic;
    if (id == null) {
      paramDic = {
        "name": subjectcontroller.text.toString(),
        "message": message.toString(),
        "showtostaff": isChecked1 == true ? "1" : "0",
        "showtousers": isChecked2 == true ? "1" : "0",
        "showname": isChecked3 == true ? "1" : "0",
      };
    } else {
      paramDic = {
        "name": subjectcontroller.text.toString(),
        "message": message.toString(),
        "showtostaff": isChecked1 == true ? "1" : "0",
        "showtousers": isChecked2 == true ? "1" : "0",
        "showname": isChecked3 == true ? "1" : "0",
        "id": id.toString(),
      };
    }
    print(paramDic);
    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.getAnnouncements, paramDic, "Post", Api_Key_by_Admin);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          if (data['status'] != true) if (data['status'].toString() != '1') {
            ToastShowClass.toastShow(
                null, data['message'] ?? 'Failed to Post Data', Colors.red);
          }
        } catch (e) {
          ToastShowClass.toastShow(null, 'Failed to Post Data', Colors.red);
        }
        setState(() {
          save = false;
          Navigator.pop(context);
          // ToastShowClass.toastShow(context, data['message'], Colors.green);

          ToastShowClass.coolToastShow(
              context, '${data['message']}', CoolAlertType.success);
        });
      } else {
        setState(() {
          ToastShowClass.coolToastShow(
              context, '${data['message']}', CoolAlertType.error);

          // ToastShowClass.toastShow(context, data['message'], Colors.red);
        });
      }
    } catch (e) {
      ToastShowClass.coolToastShow(context, '$e', CoolAlertType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorCollection.grey,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKeyDetail,
            child: Column(
              children: [
                Container(
                  height: height * 0.2,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  decoration: BoxDecoration(
                    color: ColorCollection.backColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: height * 0.08,
                        width: width * 0.17,
                        child: Image.asset(
                          'assets/announcements.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      FittedBox(
                        child: Text(
                          KeyValues.addannouncement,
                          style: ColorCollection.screenTitleStyle,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(2),
                        width: width * 0.11,
                        height: width * 0.11,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: new_profile_Image == ''
                              ? Text(new_staff_firstname[0])
                              : Image.network(
                                  'http://' +
                                      Base_Url_For_App +
                                      '/crm/uploads/staff_profile_images/' +
                                      new_staff_ID +
                                      '/thumb_' +
                                      new_profile_Image,
                                  fit: BoxFit.fill,
                                  errorBuilder: (_, __, ___) {
                                    return Center(
                                        child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 35,
                                    ));
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.07,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.04,
                    horizontal: width * 0.06,
                  ),
                  width: width,
                  decoration: kContaierDeco
                      .copyWith(color: ColorCollection.containerC)
                      .copyWith(color: ColorCollection.containerC),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            KeyValues.subject,
                            style: ColorCollection.titleStyle,
                          ),
                          Text('*', style: ColorCollection.titleStyleGreen),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.06,
                        width: width,
                        decoration: kDropdownContainerDeco,
                        child: TextFormField(
                          controller: subjectcontroller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the Subject';
                            }
                            return null;
                          },
                          style: kTextformStyle,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: width * 0.01, right: width * 0.01),
                            hintText: KeyValues.enterSubject,
                            hintStyle: kTextformHintStyle,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                      HtmlEditor(
                        controller: controller,
                        htmlEditorOptions: HtmlEditorOptions(
                          hint: KeyValues.yourtexthere,
                        ),
                        otherOptions: OtherOptions(
                          decoration: kDropdownContainerDeco,
                          height: height * 0.25,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              side: BorderSide(color: Colors.grey.shade400),
                              activeColor: ColorCollection.green,
                              value: isChecked1,
                              onChanged: (newVal) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  isChecked1 = !isChecked1;
                                });
                              }),
                          Text(KeyValues.showToStaff,
                              style: ColorCollection.titleStyle)
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              side: BorderSide(color: Colors.grey.shade400),
                              activeColor: ColorCollection.green,
                              value: isChecked2,
                              onChanged: (newVal) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  isChecked2 = !isChecked2;
                                });
                              }),
                          Text(KeyValues.showToClient,
                              style: ColorCollection.titleStyle)
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              side: BorderSide(color: Colors.grey.shade400),
                              activeColor: ColorCollection.green,
                              value: isChecked3,
                              onChanged: (newVal) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  isChecked3 = !isChecked3;
                                });
                              }),
                          Text(KeyValues.showMyName,
                              style: ColorCollection.titleStyle)
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      SizedBox(
                        height: height * 0.04,
                        width: width,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ColorCollection.green)),
                          onPressed: () async {
                            if (_formKeyDetail.currentState!.validate()) {
                              setState(() {
                                save = true;
                              });
                              // if (_formKeyDetail.currentState.validate()){
                              if (save == true) {
                                String message = await controller.getText();
                                print(message.toString());
                                AddAnnouncements(
                                    message,
                                    widget.EditData == null
                                        ? null
                                        : widget.EditData[0]['announcementid']);
                              } else {
                                ToastShowClass.toastShow(
                                    context, 'Wait..', Colors.green);
                              }
                            }
                          },
                          child: Text(KeyValues.submit,
                              style: ColorCollection.buttonTextStyle),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
