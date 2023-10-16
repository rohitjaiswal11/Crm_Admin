// ignore_for_file: file_names, avoid_print, use_key_in_widget_constructors, non_constant_identifier_names, must_be_immutable, prefer_final_fields, prefer_const_constructors, import_of_legacy_library_into_null_safe
import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../LBM_Plugin/lbmplugin.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/storage_manger.dart';

class AddReminder extends StatefulWidget {
  String LeadId;
  String typeOf;
  AddReminder({required this.LeadId, required this.typeOf});
  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  String dateCurrent = "";
  final _formKey = GlobalKey<FormState>();
  final Description = TextEditingController();
  var CurrentDate = TextEditingController();
  int _state = 0;
  String oldStaff_ID = '', oldLead_ID = '';
  String Staff_ID = '', Lead_ID = '';
  String Type = 'reminder';
  int notifymail = 0;
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    //2020-01-01 00:00:00
    String formattedTime = DateFormat.Hms().format(DateTime.now());
    print(formattedTime);
    var formattedDate =
        "${dateParse.year}-${dateParse.month}-${dateParse.day} $formattedTime";
    oldStaff_ID = await SharedPreferenceClass.GetSharedData("staff_id");
    print(oldStaff_ID);

    oldLead_ID = widget.LeadId;
    setState(() {
      CurrentDate.text = formattedDate.toString();
      Type = 'reminder';
      Staff_ID = oldStaff_ID;
      Lead_ID = oldLead_ID;
    });
  }

  Object? _radioValueReminder = 2;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: ColorCollection.backColor,
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: ColorCollection.white,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.03, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  KeyValues.newReminder,
                  style: ColorCollection.titleStyle2,
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Text(
                  KeyValues.date,
                  style: ColorCollection.titleStyle,
                ),
                SizedBox(height: height * 0.02),
                Container(
                  height: height * 0.04,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  decoration: kDropdownContainerDeco,
                  child: DateTimeField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabled: true,
                        hintText: KeyValues.selectDate,
                        hintStyle: kTextformHintStyle),
                    format: format,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        CurrentDate.text =
                            DateTimeField.combine(date, time).toString();
                        print(CurrentDate.text);
                        return DateTimeField.combine(date, time);
                      } else {
                        print(
                            'Current value' + currentValue!.toIso8601String());
                        return currentValue;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  KeyValues.description,
                  style: ColorCollection.titleStyle,
                ),
                SizedBox(height: height * 0.02),
                Container(
                  height: height * 0.1,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                  ),
                  decoration: kDropdownContainerDeco,
                  child: TextFormField(
                    controller: Description,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the Description';
                      }
                      return null;
                    },
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    autofocus: false,
                    style: kTextformStyle,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintStyle: kTextformHintStyle,
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Row(
                  children: [
                    Radio(
                        toggleable: true,
                        activeColor: ColorCollection.backColor,
                        value: 1,
                        groupValue: _radioValueReminder,
                        onChanged: (newVal) {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _radioValueReminder = newVal;
                            if (_radioValueReminder == 1) {
                              notifymail = 1;
                            } else {
                              notifymail = 0;
                            }
                          });
                        }),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Text(
                      KeyValues.emailReminder,
                      style: ColorCollection.titleStyleGreen3
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  height: height * 0.045,
                  width: width,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorCollection.green),
                    ),
                    onPressed: () {
                      setState(() {
                        if (_formKey.currentState!.validate()) {
                          if (_state == 0) {
                            setState(() {
                              _state = 1;
                              SubmitReminderAPI(
                                  Type,
                                  Lead_ID,
                                  Staff_ID,
                                  Description.text,
                                  CurrentDate.text,
                                  notifymail);
                            });
                          }
                        }
                      });
                    },
                    child: setUpButtonChild(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  } //Submit the api to save reminder data on server

  void SubmitReminderAPI(String type, String lead_id, String staff_id,
      String description, String currentDate, int notifymail) async {
    final paramDic = {
      "type": type.toString(),
      "lead_id": lead_id.toString(),
      "description": description.toString(),
      "staff_id": staff_id.toString(),
      "date_contacted": currentDate.toString(),
      "notify_by_email": notifymail.toString(),
      "typeby": widget.typeOf,
    };

    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.AddLeadReminderNotes, paramDic, "Post", Api_Key_by_Admin);
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
        _state = 2;
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.success);
        Navigator.pop(context);
      });
    } else {
      setState(() {
        _state = 0;
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.error);
      });
    }
  }

  //effect when click on submit button then show circular progress bar
  Widget setUpButtonChild() {
    if (_state == 0) {
      return Text(
        "SUBMIT",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }
}
