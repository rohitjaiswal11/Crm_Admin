// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, import_of_legacy_library_into_null_safe, avoid_print, must_be_immutable, prefer_if_null_operators, prefer_const_literals_to_create_immutables, non_constant_identifier_names
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

import '../util/ToastClass.dart';

class ViewAppointment extends StatefulWidget {
  static const idA = 'viewAppointment';
  String id;

  ViewAppointment({required this.id});

  @override
  _ViewAppointmentState createState() => _ViewAppointmentState();
}

class _ViewAppointmentState extends State<ViewAppointment> {
  List appointment = [];
  bool isfetched = false;
  @override
  void initState() {
    getAppointmentView(widget.id.toString());
    super.initState();
  }

  Future<void> getAppointmentView(String id) async {
    final paramDic = {
      "appointment_id": id.toString(),
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.getviewAppointment, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    appointment.clear();
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
         if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Load Data', Colors.red);
        }
      } catch (e) {
        ToastShowClass.toastShow(null, 'Failed to Load Data', Colors.red);
      }
      setState(() {
        isfetched = true;
      });
      appointment = data['data'];
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print(appointment.toString());
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: ColorCollection.backColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/appointment.png',
              height: 50,
              width: 50,
            ),
            Text(
              KeyValues.appointment.tr().toUpperCase(),
              style: ColorCollection.buttonTextStyle,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: isfetched == true
          ? SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text(
                    "General Information",
                    style: ColorCollection.titleStyleGreen,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Card(
                    elevation: 20,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Initiated by ',
                                style: ColorCollection.titleStyle,
                              ),
                              Text(
                                  (appointment[0]['name'] == null
                                      ? ""
                                      : appointment[0]['name']),
                                  style: ColorCollection.titleStyle2),
                            ],
                          ),
                          Divider(
                            color: ColorCollection.backColor,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Subject ',
                                  style: ColorCollection.titleStyle),
                              Text(
                                  (appointment[0]['subject'] == null
                                      ? ""
                                      : appointment[0]['subject']),
                                  style: ColorCollection.titleStyle2),
                            ],
                          ),
                          Divider(
                            color: ColorCollection.backColor,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Appointment Date ',
                                  style: ColorCollection.titleStyle),
                              Text(
                                  (appointment[0]['date'] == null
                                      ? ""
                                      : appointment[0]['date']),
                                  style: ColorCollection.titleStyle2),
                            ],
                          ),
                          Divider(
                            color: ColorCollection.backColor,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Appointment Scheduled Start at ',
                                  style: ColorCollection.titleStyle),
                              Text(
                                  (appointment[0]['start_hour'] == null
                                      ? ""
                                      : appointment[0]['start_hour']),
                                  style: ColorCollection.titleStyle2),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.07,
                  ),
                  Text(
                    "Additional Information",
                    style: ColorCollection.titleStyleGreen,
                  ),
                  SizedBox(height: height * 0.015),
                  Card(
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Source ',
                                  style: ColorCollection.titleStyle),
                              Text(
                                  appointment[0]['source'] == null
                                      ? ""
                                      : appointment[0]['source'],
                                  style: ColorCollection.titleStyle2),
                            ],
                          ),
                          Divider(
                            color: ColorCollection.backColor,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Name ', style: ColorCollection.titleStyle),
                              Text(
                                  appointment[0]['name'] == null
                                      ? ""
                                      : appointment[0]['name'],
                                  style: ColorCollection.titleStyle2),
                            ],
                          ),
                          Divider(
                            color: ColorCollection.backColor,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Email ', style: ColorCollection.titleStyle),
                              Text(
                                  appointment[0]['email'] == null
                                      ? ""
                                      : appointment[0]['email'],
                                  style: ColorCollection.titleStyle2),
                            ],
                          ),
                          Divider(
                            color: ColorCollection.backColor,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Phone ', style: ColorCollection.titleStyle),
                              Text(
                                  appointment[0]['phone'] == null
                                      ? ""
                                      : appointment[0]['phone'],
                                  style: ColorCollection.titleStyle2),
                            ],
                          ),
                          Divider(
                            color: ColorCollection.backColor,
                          ),
                          //  SingleChildScrollView(
                          //  scrollDirection: Axis.horizontal,
                          //    child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Location/Address ',
                                  style: ColorCollection.titleStyle),
                              Spacer(),
                              SizedBox(
                                width: width * 0.3,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      appointment[0]['address'] == null
                                          ? ""
                                          : appointment[0]['address'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                      style: ColorCollection.titleStyle2),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: ColorCollection.backColor,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Appointment Status ',
                                  style: ColorCollection.titleStyle),
                              SizedBox(
                                width: 80,
                              ),
                              Text(
                                  appointment[0]['approved'] == null
                                      ? ""
                                      : appointment[0]['approved'] == '1'
                                          ? "Approved"
                                          : "",
                                  style: ColorCollection.titleStyle2),
                            ],
                          ),
                          Divider(
                            color: ColorCollection.backColor,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Attendees ',
                                  style: ColorCollection.titleStyle),
                              Text(
                                appointment[0]['attendees'] == null
                                    ? ""
                                    : appointment[0]['attendees'].isEmpty
                                        ? ' '
                                        : (appointment[0]['attendees'][0]
                                                ['firstname'] +
                                            " " +
                                            appointment[0]['attendees'][0]
                                                ['lastname']),
                                style: ColorCollection.titleStyle2,
                              ),
                            ],
                          ),
                          Divider(
                            color: ColorCollection.backColor,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Appointment Public URL (Client URL) ',
                                  style: ColorCollection.titleStyle),
                              Text(
                                  appointment[0]['public_url'] == null
                                      ? ""
                                      : appointment[0]['public_url'],
                                  style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                          Divider(
                            color: ColorCollection.backColor,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Appointment Notes ',
                                  style: ColorCollection.titleStyle),
                              Text(
                                  appointment[0]['notes'] == null
                                      ? ""
                                      : appointment[0]['notes'],
                                  style: ColorCollection.titleStyle2),
                            ],
                          ),
                          Divider(
                            color: ColorCollection.backColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
