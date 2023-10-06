// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, import_of_legacy_library_into_null_safe, avoid_print, must_be_immutable, prefer_if_null_operators, prefer_const_literals_to_create_immutables, non_constant_identifier_names
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';

class AnnouncementDetail extends StatefulWidget {
  static const id = 'AnnouncementDetail';
  var data;

  AnnouncementDetail({required this.data});

  @override
  _AnnouncementDetailState createState() => _AnnouncementDetailState();
}

class _AnnouncementDetailState extends State<AnnouncementDetail> {
  List appointment = [];
  bool isfetched = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print(appointment.toString());
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: ColorCollection.backColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/announcements.png',
                height: 50,
                width: 50,
              ),
              Text(
                KeyValues.announcement.tr().toUpperCase(),
                style: ColorCollection.buttonTextStyle,
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width * 0.7,
                          child: Text(
                            "${widget.data['name']}",
                            textAlign: TextAlign.center,
                            style: ColorCollection.titleStyleGreen,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Date Posted : ${widget.data['dateadded']}",
                          style: ColorCollection.titleStyleGreen3,
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Html(data: widget.data['message']),
                    SizedBox(
                      width: width * 0.8,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Html(
                          data: widget.data['message'],
                        shrinkWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
