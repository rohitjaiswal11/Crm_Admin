// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, must_be_immutable, avoid_print, prefer_typing_uninitialized_variables, unnecessary_null_comparison, import_of_legacy_library_into_null_safe, prefer_if_null_operators

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';

import '../LBM_Plugin/lbmplugin.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddNewAppointment extends StatefulWidget {
  static const id = '/AddNewAppointments';
  List EditList = [];
  AddNewAppointment({required this.EditList});

  @override
  State<AddNewAppointment> createState() => _AddNewAppointmentScrenState();
}

class _AddNewAppointmentScrenState extends State<AddNewAppointment> {
  final _formKeyDetail = GlobalKey<FormState>();

  String currentDate = '';
  final HtmlEditorController controller = HtmlEditorController();
  TextEditingController subjectcontroller = TextEditingController();
  TextEditingController discriptioncontroller = TextEditingController();
  TextEditingController appointmentlocationcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  final List<DropdownMenuItem> attendees = [];
  final List<DropdownMenuItem> _contact = [];
  List Contacts = [];
  List Attendees = [];
  TimeOfDay? selectedTime;
  String? selectattendees;
  String? selectcontacts;
  String? selectcontactid;
  int? selectrelid;
  bool sms = false;
  bool email = false;
  bool save = false;
  bool contact = false;
  bool contactdetail = false;
  bool isedited = false;
  bool done = false;
  String? time;

  Related? Selected_Related;
  List<Related> relatedlist = Related.getrelated();
  void _datTimePickerDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1947),
            lastDate: DateTime(5050))
        .then((date) {
      if (date == null) {
        return;
      } else {
        setState(() {
          currentDate = DateFormat("yyyy-MM-dd").format(date);
        });
      }
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedS = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (pickedS != null && pickedS != selectedTime) {
      setState(() {
        selectedTime = pickedS;
      });
    }
  }

  @override
  void initState() {
    getContact();
    if (widget.EditList != null) {
      subjectcontroller.text = widget.EditList[0]['subject'] == null
          ? ''
          : widget.EditList[0]['subject'].toString();
      discriptioncontroller.text = widget.EditList[0]['description'] == null
          ? ''
          : widget.EditList[0]['description'].toString();
      currentDate = widget.EditList[0]['date'] == null
          ? ''
          : widget.EditList[0]['date'].toString();
      namecontroller.text = widget.EditList[0]['name'] == null
          ? ''
          : widget.EditList[0]['name'].toString();
      emailcontroller.text = widget.EditList[0]['email'] == null
          ? ''
          : widget.EditList[0]['email'].toString();
      phonecontroller.text = widget.EditList[0]['phone'] == null
          ? ''
          : widget.EditList[0]['phone'].toString();
      appointmentlocationcontroller.text = widget.EditList[0]['address'] == null
          ? ''
          : widget.EditList[0]['address'].toString();
      email = widget.EditList[0]['by_email'] == '1' ? true : false;
      sms = widget.EditList[0]['by_sms'] == '1' ? true : false;
      time = widget.EditList[0]['start_hour'].toString();
      isedited = true;
      save = true;
      print('CHECK DATE    ' + widget.EditList[0]['attendees'].toString());
      if (widget.EditList[0]['source'] == 'Internal (Contact)') {
        setState(() {
          contact = true;
          contactdetail = false;
          contactdetail = false;
        });
      } else {
        setState(() {
          contact = false;
          contactdetail = true;
        });
      }
    }

    super.initState();
  }

  Future<void> getContact() async {
    final paramDic = {
      "": '',
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.getcontact, paramDic, "Post", Api_Key_by_Admin);
    Contacts.clear();
    Attendees.clear();

    var data = json.decode(response.body);
    if (response.statusCode != 0) {
      try {
        final data = json.decode(response.body);
        if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to get Contacts ', Colors.red);
        }
      } catch (e) {
        ToastShowClass.toastShow(null, 'Failed to get Contacts ', Colors.red);
      }
      if (mounted) {
        setState(() {
          Contacts = data['data']['contact'];
          Attendees = data['data']['staff'];
          print("[]][]]]][]");
          print(Attendees.toString());
          _contact.clear();
          for (int i = 0; i < Contacts.length; i++) {
            _contact.add(DropdownMenuItem(
                child: Text(
                    Contacts[i]['firstname'] + " " + Contacts[i]['lastname']),
                value: i.toString() +
                    "/" +
                    Contacts[i]['id'] +
                    "/name" +
                    Contacts[i]['firstname'] +
                    " " +
                    Contacts[i]['lastname'] +
                    "/email" +
                    Contacts[i]['email'] +
                    "/number" +
                    Contacts[i]['phonenumber']));
          }
          attendees.clear();
          for (int i = 0; i < Attendees.length; i++) {
            attendees.add(DropdownMenuItem(
                child: Text(
                    Attendees[i]['firstname'] + "" + Attendees[i]['lastname']),
                value: i.toString() + "/" + Attendees[i]['staffid']));
          }
        });
      }
    } else {}
  }

  var paramDic;
  var response;
  void AddAppointment(String? id, String message) async {
    if (id == null) {
      paramDic = {
        "subject": subjectcontroller.text.toString(),
        "description": discriptioncontroller.text.toString(),
        "source": '',
        "rel_type": selectrelid.toString(),
        "contact_id": selectcontactid.toString(),
        "name": namecontroller.text.toString(),
        "email": emailcontroller.text.toString(),
        "phone": phonecontroller.text.toString(),
        "date": currentDate.toString(),
        "start_hour": MaterialLocalizations.of(context)
                .formatTimeOfDay(selectedTime!, alwaysUse24HourFormat: true)
                .toString() +
            ':00',
        "address": appointmentlocationcontroller.text.toString(),
        "by_sms": sms == true ? "1" : "0",
        "by_email": email == true ? "1" : "0",
        "reminder_before": '',
        "reminder_before_type": '',
        "notes": message.toString(),
      };
      response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.grtAppointment, paramDic, "Post", Api_Key_by_Admin);
    } else {
      paramDic = {
        "subject": subjectcontroller.text.toString(),
        "description": discriptioncontroller.text.toString(),
        "source": '',
        "rel_type": selectrelid.toString(),
        "contact_id": selectcontactid.toString(),
        "name": namecontroller.text.toString(),
        "email": emailcontroller.text.toString(),
        "phone": phonecontroller.text.toString(),
        "date": currentDate.toString(),
        "start_hour": MaterialLocalizations.of(context)
            .formatTimeOfDay(selectedTime!, alwaysUse24HourFormat: true)
            .toString(),
        "address": appointmentlocationcontroller.text.toString(),
        "by_sms": sms == true ? "1" : "0",
        "by_email": email == true ? "1" : "0",
        "reminder_before": '',
        "reminder_before_type": '',
        "notes": message.toString(),
        "appointment_id": id.toString(),
      };
      response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.getUpdateAppointment, paramDic, "Post", Api_Key_by_Admin);
    }
    print('Parameters ===' + paramDic.toString());

    var data = json.decode(response.body);
    print('Appointment Data ===' + data.toString());
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.coolToastShow(context,
              data['message'] ?? 'Failed to Post Data', CoolAlertType.error);
        }
      } catch (e) {
        ToastShowClass.coolToastShow(
            context, 'Failed to Post Data', CoolAlertType.error);
      }
      setState(() {
        save = false;
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.success);
        Navigator.pop(context);
      });
    } else {
      setState(() {
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print('Edit list Data' + widget.EditList.toString());
    final contentPadding =
        EdgeInsets.only(left: width * 0.04, right: width * 0.02);
    return Scaffold(
      backgroundColor: ColorCollection.grey,
      body: SingleChildScrollView(
        child: Form(
          key: _formKeyDetail,
          child: Column(
            children: [
              Container(
                height: height * 0.2,
                decoration: BoxDecoration(
                  color: ColorCollection.backColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 0.05,
                      ),
                      SizedBox(
                        height: height * 0.09,
                        width: width * 0.17,
                        child: Image.asset(
                          'assets/appointment.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Text(KeyValues.appointment,
                          style: ColorCollection.screenTitleStyle),
                      Spacer(),
                      SizedBox(
                        width: width * 0.04,
                      ),
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
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                ),
                width: width,
                decoration:
                    kContaierDeco.copyWith(color: ColorCollection.containerC),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Text(KeyValues.subject, style: ColorCollection.titleStyle),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      height: height * 0.06,
                      width: width,
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the Subject';
                          }
                          return null;
                        },
                        controller: subjectcontroller,
                        style: kTextformStyle,
                        decoration: InputDecoration(
                          contentPadding: contentPadding,
                          hintText: KeyValues.enterSubject,
                          hintStyle: kTextformHintStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(KeyValues.description,
                        style: ColorCollection.titleStyle),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      height: height * 0.06,
                      width: width,
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the Description';
                          }
                          return null;
                        },
                        controller: discriptioncontroller,
                        style: kTextformStyle,
                        decoration: InputDecoration(
                          hintStyle: kTextformHintStyle,
                          contentPadding: contentPadding,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(KeyValues.related, style: ColorCollection.titleStyle),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<Related>(
                        hint: Text(KeyValues.nothingSelected),
                        style: ColorCollection.titleStyle,
                        elevation: 8,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: width * 0.04),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade100, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade100, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        dropdownColor: ColorCollection.lightgreen,
                        value: Selected_Related,
                        onChanged: widget.EditList == null
                            ? (Related? newValue) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  Selected_Related = newValue!;
                                  selectrelid = newValue.id;
                                  if (Selected_Related!.name ==
                                      'Internal (Contact)') {
                                    contact = true;
                                    isedited = false;
                                    contactdetail = false;
                                  } else {
                                    contact = false;
                                    isedited = true;
                                    contactdetail = true;
                                  }
                                });
                              }
                            : (Related? newVal) {},
                        items: relatedlist.map((Related item) {
                          return DropdownMenuItem<Related>(
                            child: Text(item.name),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    //Contact
                    Visibility(
                      visible: contact == true ? true : false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            KeyValues.contacts,
                            style: ColorCollection.titleStyle,
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            decoration: kDropdownContainerDeco,
                            child: SearchableDropdown.single(
                              underline: '',
                              items: _contact,
                              value: selectcontacts,
                              hint: "Select Follower",
                              searchHint: "Select one",
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  selectcontacts = value;
                                  selectcontactid = selectcontacts
                                      .toString()
                                      .split("/")[1]
                                      .toString();
                                  print(selectcontactid.toString());
                                  print("selectcontactid.toString()");
                                  namecontroller.text = selectcontacts
                                      .toString()
                                      .split("/")[2]
                                      .toString();
                                  emailcontroller.text = selectcontacts
                                      .toString()
                                      .split("/")[3]
                                      .toString();
                                  phonecontroller.text = selectcontacts
                                      .toString()
                                      .split("/number")[1]
                                      .toString();
                                  contactdetail = true;
                                });
                              },
                              isExpanded: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),

                    Visibility(
                      visible: contactdetail == true ? true : false,
                      child: Column(
                        children: [
                          Container(
                            height: height * 0.06,
                            decoration: kDropdownContainerDeco,
                            child: TextFormField(
                              validator: (value) {
                                if (isedited) if (value!.isEmpty) {
                                  return 'Please enter the Name';
                                }
                                return null;
                              },
                              controller: namecontroller,
                              enabled: isedited == false ? false : true,
                              style: kTextformStyle,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: contentPadding,
                                hintText: isedited ? 'Enter Name' : '',
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            height: height * 0.06,
                            decoration: kDropdownContainerDeco,
                            child: TextFormField(
                              validator: (value) {
                                if (isedited) if (value!.isEmpty) {
                                  return 'Please enter the Email';
                                }
                                return null;
                              },
                              enabled: isedited == false ? false : true,
                              controller: emailcontroller,
                              style: kTextformStyle,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: contentPadding,
                                hintText: isedited ? 'Enter Email' : '',
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            height: height * 0.06,
                            decoration: kDropdownContainerDeco,
                            child: TextFormField(
                              validator: (value) {
                                if (isedited) if (value!.isEmpty) {
                                  return 'Please enter the Number';
                                }
                                return null;
                              },
                              enabled: isedited == false ? false : true,
                              controller: phonecontroller,
                              style: kTextformStyle,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  contentPadding: contentPadding,
                                  hintText: isedited ? 'Enter Number' : '',
                                  hintStyle: kTextformHintStyle,
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(KeyValues.datetime, style: ColorCollection.titleStyle),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      height: height * 0.06,
                      decoration: kDropdownContainerDeco,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _datTimePickerDialog();
                            },
                            child: SizedBox(
                              height: height * 0.03,
                              width: width * 0.4,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 15,
                                  ),
                                  SizedBox(width: width * 0.02),
                                  Text(
                                    currentDate == null
                                        ? KeyValues.selectDate
                                        : currentDate,
                                    style: ColorCollection.titleStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height: height * 0.03,
                              child: VerticalDivider(
                                color: Colors.black,
                              )),
                          GestureDetector(
                            onTap: () {
                              _selectTime(context);
                            },
                            child: SizedBox(
                              height: height * 0.03,
                              width: width * 0.4,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 15,
                                  ),
                                  SizedBox(width: width * 0.02),
                                  Text(
                                    widget.EditList != null
                                        ? time!
                                        : selectedTime == null
                                            ? ''
                                            : '${selectedTime!.hour}:${selectedTime!.minute}',
                                    style: ColorCollection.titleStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Text('${KeyValues.appointment} ${KeyValues.locatoin}',
                        style: ColorCollection.titleStyle),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      height: height * 0.06,
                      width: width,
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        controller: appointmentlocationcontroller,
                        style: kTextformStyle,
                        decoration: InputDecoration(
                          contentPadding: contentPadding,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(KeyValues.attendees,
                        style: ColorCollection.titleStyle),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: SearchableDropdown.single(
                        underline: '',
                        items: attendees,
                        value: selectattendees,
                        hint: "Select Follower",
                        searchHint: "Select one",
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            selectattendees = value;
                          });
                        },
                        isExpanded: false,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    HtmlEditor(
                      controller: controller,
                      htmlEditorOptions: HtmlEditorOptions(
                        hint: KeyValues.yourtexthere,
                      ),
                      otherOptions: OtherOptions(
                        decoration: kDropdownContainerDeco,
                        height: height * 0.2,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //         side: BorderSide(color: Colors.grey.shade400),
                    //         activeColor: ColorCollection.green,
                    //         value: sms,
                    //         onChanged: (newVal) {
                    //           setState(() {
                    //             FocusScope.of(context)
                    //                 .requestFocus(FocusNode());
                    //             sms = newVal!;
                    //           });
                    //         }),
                    //     Text(
                    //       KeyValues.smsNotificatoin,
                    //       style: ColorCollection.titleStyle,
                    //     )
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //         side: BorderSide(color: Colors.grey.shade400),
                    //         activeColor: ColorCollection.green,
                    //         value: email,
                    //         onChanged: (newVal) {
                    //           setState(() {
                    //             FocusScope.of(context)
                    //                 .requestFocus(FocusNode());
                    //             email = newVal!;
                    //           });
                    //         }),
                    //     Text(
                    //       KeyValues.emailNotification,
                    //       style: ColorCollection.titleStyle,
                    //     )
                    //   ],
                    // ),
                    SizedBox(
                      height: height * 0.04,
                      width: width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ColorCollection.green)),
                        onPressed: save == false
                            ? () async {
                                if (_formKeyDetail.currentState!.validate()) {
                                  print('if +++++++++++');
                                  setState(() {
                                    done = true;
                                    save = true;
                                    // AddAppointment(widget.EditList[0]['id']);
                                  });
                                  String message = await controller.getText();
                                  print(message.toString());
                                  AddAppointment('', message);
                                  ToastShowClass.toastShow(
                                      context, 'Wait..', Colors.green);
                                } else {
                                  print('else  +++++++++++');
                                }
                              }
                            : () async {
                                setState(() {
                                  done = true;
                                });
                                String message = await controller.getText();
                                print(message.toString());
                                AddAppointment(
                                    widget.EditList[0]['id'], message);
                              },
                        child: Text(
                          KeyValues.submit,
                          style: ColorCollection.buttonTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Related {
  int id;
  String name;

  Related(this.id, this.name);

  static List<Related> getrelated() {
    return <Related>[
      Related(1, 'External'),
      Related(2, 'Internal (Contact)'),
    ];
  }
}
