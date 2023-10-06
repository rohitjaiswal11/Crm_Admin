// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, avoid_print, prefer_if_null_operators, unnecessary_null_comparison, import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:lbm_crm/Appointment/add_new_appointment.dart';
import 'package:lbm_crm/Appointment/appointmetView.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/constants.dart';

class AppointmentScreen extends StatefulWidget {
  static const id = '/Appointment';

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List Appointments = [];
  List Appointmentsnew = [];
  List AppointmentsSearch = [];
  bool isfetched = false;
  var currentdate = DateTime.now();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  List SendData = [];
  String CurrentDate = "";
  String fetcheddate = "";
  DateTime? date;

  @override
  void initState() {
    getAppointment();
    CurrentDate = dateFormat
        .format(DateTime.now()); //Converting DateTime object to String
    //Converting DateTime object to String
    super.initState();
  }

  Future<void> getAppointment() async {
    final paramDic = {
      "": '',
    };
    print(paramDic);
    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.grtAppointment, paramDic, "Get", Api_Key_by_Admin);

      Appointments.clear();
      Appointmentsnew.clear();
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        try {
          final data = json.decode(response.body);
          if (data['status'] != true) if (data['status'].toString() != '1') {
            ToastShowClass.toastShow(
                null, data['message'] ?? 'Failed to Load Data', Colors.red);
          }
        } catch (e) {
          setState(() {
            isfetched = true;
          });
          ToastShowClass.toastShow(null, 'Failed to Load Data', Colors.red);
        }

        Appointments = data['data']['today'];
        setState(() {
          isfetched = true;
        });
        setState(() {
          Appointmentsnew.addAll(Appointments);
          AppointmentsSearch.addAll(Appointmentsnew);
          print(Appointmentsnew.toString());
        });
      } else {
        log(response.statusCode.toString());
        setState(() {
          isfetched = true;
        });
      }
    } catch (e) {
      log('Error Occured $e');
      setState(() {
        isfetched = true;
      });
    }
  }

  onSearchTextChanged(String text) async {
    Appointmentsnew.clear();
    if (text.isEmpty) {
      setState(() {
        Appointmentsnew = List.from(AppointmentsSearch);
      });
      return;
    }
    setState(() {
      Appointmentsnew = AppointmentsSearch.where((item) => item['subject']
          .toString()
          .toLowerCase()
          .contains(text.toString().toLowerCase())).toList();
      print("working" + Appointmentsnew.toString());
    });
  }

  Future<void> deleteAppointment(String id) async {
    final paramDic = {
      "id": id,
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.deleteAppointment, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);
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
      getAppointment();
      ToastShowClass.coolToastShow(
          context, data['message'], CoolAlertType.success);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          Navigator.pushNamed(context, AddNewAppointment.id)
              .then((value) => getAppointment());
        },
      ),
      backgroundColor: ColorCollection.grey,
      body: SingleChildScrollView(
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
                      height: height * 0.07,
                      width: width * 0.15,
                      child: Image.asset(
                        'assets/appointment.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Text(KeyValues.appointment.toUpperCase(),
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
              height: height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                height: height * 0.06,
                width: width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: height * 0.06,
                      width: width * 0.75,
                      child: TextFormField(
                        onChanged: onSearchTextChanged,
                        decoration: InputDecoration(
                          hintText: 'Search Appointment',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.01),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.06,
                      width: width * 0.11,
                      decoration: BoxDecoration(
                          color: ColorCollection.darkGreen,
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
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
              height: height * 0.66,
              padding: EdgeInsets.symmetric(
                vertical: height * 0.02,
                horizontal: width * 0.06,
              ),
              width: width,
              decoration:
                  kContaierDeco.copyWith(color: ColorCollection.containerC),
              child: isfetched
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.02,
                      ),
                      child: Appointmentsnew.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.only(
                                bottom: height * 0.05,
                              ),
                              itemCount: Appointmentsnew.length,
                              itemBuilder: (c, i) =>
                                  appointmentContainer(width, height, i))
                          : Center(
                              child: Text('No Data'),
                            ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appointmentContainer(double width, double height, int i) {
    var date_data = Appointmentsnew[i]['date'];
    print(date_data);
    fetcheddate = dateFormat.format(DateTime.parse(date_data));
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: height * 0.011, bottom: height * 0.015),
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.01),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(6)),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'ID : ' +
                              (Appointmentsnew[i]['id'] == null
                                  ? ""
                                  : Appointmentsnew[i]['id']),
                          style: ColorCollection.titleStyle),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 11,
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          Text(
                              Appointmentsnew[i]['date'] == null
                                  ? ""
                                  : Appointmentsnew[i]['date'],
                              style: ColorCollection.titleStyle
                                  .copyWith(fontWeight: FontWeight.normal)),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Icon(
                            Icons.access_time_rounded,
                            size: 11,
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          Text(
                              Appointmentsnew[i]['date'] == null
                                  ? ""
                                  : Appointmentsnew[i]['start_hour'],
                              style: ColorCollection.titleStyle
                                  .copyWith(fontWeight: FontWeight.normal)),
                          SizedBox(
                            width: width * 0.07,
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.005,
                  ),
                  Row(
                    children: [
                      Text(
                        '${KeyValues.status} - ',
                        style: ColorCollection.titleStyle
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                      Text(
                        currentdate.isAfter(DateTime.parse(date_data))
                            ? "Missed"
                            : Appointmentsnew[i]['approved'] == "1"
                                ? "Upcomming"
                                : currentdate
                                        .isBefore(DateTime.parse(date_data))
                                    ? "Pending Approval"
                                    : "",
                        style: ColorCollection.subTitleStyleRed,
                      ),
                      Spacer(),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  ViewAppointment.idA,
                                  arguments: Appointmentsnew[i]['id']);
                            },
                            child: Icon(
                              Icons.remove_red_eye,
                              size: 20,
                              color: ColorCollection.green,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.04,
                          ),
                          InkWell(
                            onTap: () {
                              SendData.clear();
                              SendData.add(Appointmentsnew[i]);
                              print("Appointmentsnew  " + SendData.toString());
                              Navigator.of(context)
                                  .pushNamed(AddNewAppointment.id,
                                      arguments: SendData)
                                  .then((value) => getAppointment());
                            },
                            child: Icon(
                              Icons.note_alt_outlined,
                              size: 20,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.04,
                          ),
                          InkWell(
                              onTap: () {
                                deleteAppointment(Appointmentsnew[i]['id']);
                              },
                              child: Icon(Icons.delete,
                                  size: 20, color: Colors.red)),
                          SizedBox(
                            width: width * 0.02,
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          width: width * 0.2,
                          child: Text(
                            '${KeyValues.subject} : ' +
                                (Appointmentsnew[i]['subject'] == null
                                    ? ""
                                    : Appointmentsnew[i]['subject']),
                            overflow: TextOverflow.ellipsis,
                            style: ColorCollection.subTitleStyle,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      SizedBox(
                        width: width * 0.25,
                        child: Text(
                          '${KeyValues.description} : ' +
                              (Appointmentsnew[i]['description'] == null
                                  ? ""
                                  : Appointmentsnew[i]['description']),
                          overflow: TextOverflow.ellipsis,
                          style: ColorCollection.subTitleStyle,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      SizedBox(
                        width: width * 0.15,
                        child: Text(
                          '${KeyValues.source} : ' +
                              (Appointmentsnew[i]['source'] == null
                                  ? ""
                                  : Appointmentsnew[i]['source']),
                          overflow: TextOverflow.ellipsis,
                          style: ColorCollection.subTitleStyle,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: width * 0.81,
          child: CircleAvatar(
            radius: 13,
            backgroundColor: Appointmentsnew[i]['approved'] == "1"
                ? ColorCollection.backColor
                : Colors.cyan,
            child: Icon(
              Icons.check,
              size: 15,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
