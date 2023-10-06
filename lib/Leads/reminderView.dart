// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, import_of_legacy_library_into_null_safe, must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, avoid_print, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/colors.dart';

class ReminderViewDialogBox extends StatefulWidget {
  static const id = 'ReminderView';
  String LeadID;

  ReminderViewDialogBox({required this.LeadID});

  @override
  State<StatefulWidget> createState() {
    return _ReminderViewDialogBox();
  }
}

class _ReminderViewDialogBox extends State<ReminderViewDialogBox> {
  List ListReminderView = [];
  var isDataFetched = false;

  @override
  void initState() {
    super.initState();
    print(widget.LeadID);
    showNoteData();
  }

  //Fetch the data on server by using api
  void showNoteData() async {
    final paramDic = {
      "type": "reminder",
      "lead_id": widget.LeadID,
      "typeby": "lead",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetLeadReminderNotes, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        ListReminderView = data['data'] as List;
        print("reminder" + ListReminderView.toString());
        isDataFetched = true;
      });
    } else {
      setState(() {
        print("no data");
        isDataFetched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
        backgroundColor: ColorCollection.backColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, top: 8.0, bottom: 8.0),
        child: _getBodyWidget(),
      ),
    );
  }

  //check the data fetch by server or not
  Widget _getBodyWidget() {
    return Container(
        child: isDataFetched == false
            ? ShimmerList()
            : ListReminderView.isNotEmpty
                ? ListView.builder(
                    itemCount: ListReminderView.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
//                            return buildList(context, index);
                      return _buildItems(context, index);
                    })
                : Center(child: Container(child: Text('no data'))));
  }

//display the record on widget
  Widget _buildItems(BuildContext context, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                ListReminderView[index]['reminder_name'].toString() == " "
                    ? '...'
                    : ListReminderView[index]['reminder_name'].toString(),
                style: ColorCollection.darkGreenStyle),
            Text(
              'Is Notified?',
              style: ColorCollection.darkGreenStyle2,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(ListReminderView[index]['description'],
                style: ColorCollection.smalltTtleStyle),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  border:
                      Border.all(width: 1, color: ColorCollection.titleColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 3.0, left: 5.0, right: 5.0, bottom: 3.0),
                  child: Text(
                    ListReminderView[index]['isnotified'].toString() == '0'
                        ? "No"
                        : "Yes",
                    style: ColorCollection.darkGreenStyle2,
                  ),
                ))
          ],
        ),
        Text(
          ListReminderView[index]['date'],
          style: ColorCollection.subTitleStyle,
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}

//Shimmer effect
class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 1000;

    return SafeArea(
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;

          print(time);

          return Shimmer.fromColors(
            highlightColor: Colors.white,
            baseColor: Colors.grey.shade300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 10,
                      width: 50,
                      color: Colors.grey,
                    ),
                    Container(
                      height: 10,
                      width: 50,
                      color: Colors.grey,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 10,
                      width: 50,
                      color: Colors.grey,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(width: 1, color: Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 3.0, left: 5.0, right: 5.0, bottom: 3.0),
                          child: Container(
                            height: 10,
                            width: 50,
                            color: Colors.grey,
                          ),
                        ))
                  ],
                ),
                Container(
                  height: 10,
                  width: 50,
                  color: Colors.grey,
                ),
                Divider(
                  color: Colors.grey,
                ),
              ],
            ),
            period: Duration(milliseconds: time),
          );
        },
      ),
    );
  }
}
