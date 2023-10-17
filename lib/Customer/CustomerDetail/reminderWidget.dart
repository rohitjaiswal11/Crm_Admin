// ignore_for_file: prefer_const_constructors, file_names, import_of_legacy_library_into_null_safe, must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Leads/addReminder.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';

import 'package:shimmer/shimmer.dart';

import '../../Plugin/lbmplugin.dart';
import '../../util/ToastClass.dart';

class ReminderList extends StatefulWidget {
  String CustomerID = '';

  ReminderList({required this.CustomerID});

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  //initialization data
  List Passreminder = [];
  List reminder = [];
  List remindernew = [];
  List remindersearch = [];
  List datareminder = [];
  List dataHeader = [];
  int limit = 20;
  int start = 1;
  String CustomerNew = '';
  var isDataFetched = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      CustomerNew = widget.CustomerID.toString();
    });
    print(widget.CustomerID);
    getreminderDashboard();
  }

  @override
  void dispose() {
    super.dispose();
    datareminder = [];
    dataHeader = [];
    limit = 20;
    start = 1;
    isDataFetched = false;
    reminder.clear();
    remindernew.clear();
    remindersearch.clear();
  }

  //fetch the  reminder data by api
  Future<void> getreminderDashboard() async {
    print(widget.CustomerID.toString());
    final paramDic = {
      "type": "reminder",
      "lead_id": widget.CustomerID.toString(),
      // "lead_id": '2',
      "typeby": "customer",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetLeadReminderNotes, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    reminder.clear();
    remindernew.clear();
    remindersearch.clear();
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
      print(reminder);
      setState(() {
        reminder = data['data'];
        // dataHeader.add(data['data']);
        remindernew.addAll(reminder);
        remindersearch.addAll(reminder);
        isDataFetched = true;
      });
    } else {
      setState(() {
        isDataFetched = true;
        reminder.clear();
        remindernew.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print(remindersearch);
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
          backgroundColor: ColorCollection.backColor,
          child: Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: SizedBox(
                    child: SingleChildScrollView(
                      child: AddReminder(
                        LeadId: CustomerNew.toString(),
                        typeOf: "customer".toString(),
                      ),
                    ),
                  ),
                );
              },
            ).then((value) => getreminderDashboard());
          }),
      body: SelectionArea(
        child: Column(
          children: [
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
                          hintText: 'Search Reminders',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: width * 0.02, vertical: height * 0.01),
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
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
              height: height * 0.04,
            ),
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Container(
                height: height * 0.62,
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                ),
                width: width,
                decoration:
                    kContaierDeco.copyWith(color: ColorCollection.containerC),
                child: _getBodyWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //check the data fetch by server or not
  Widget _getBodyWidget() {
    return Container(
        child: isDataFetched == false
            ? ShimmerList()
            : remindernew.isNotEmpty
                ? ListView.builder(
                    itemCount: remindernew.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
//                            return buildList(context, index);
                      return _buildItems(context, index);
                    })
                : Center(child: Text('no data')));
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
                remindernew[index]['reminder_name'].toString() == " "
                    ? '...'
                    : remindernew[index]['reminder_name'].toString(),
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
            Text(remindernew[index]['description'],
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
                    remindernew[index]['isnotified'].toString() == '0'
                        ? "No"
                        : "Yes",
                    style: ColorCollection.darkGreenStyle2,
                  ),
                ))
          ],
        ),
        Text(
          remindernew[index]['date'],
          style: ColorCollection.subTitleStyle,
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }

  onSearchTextChanged(String text) async {
    remindernew.clear();
    if (text.isEmpty) {
      setState(() {
        remindernew = List.from(remindersearch);
      });
      return;
    }

    setState(() {
      remindernew = remindersearch
          .where((item) => item['reminder_name']
              .toString()
              .toLowerCase()
              .contains(text.toString().toLowerCase()))
          .toList();
    });
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
