// ignore_for_file: use_key_in_widget_constructors, prefer_is_empty, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_null_comparison, prefer_if_null_operators, non_constant_identifier_names, must_be_immutable, import_of_legacy_library_into_null_safe, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';

import '../LBM_Plugin/lbmplugin.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/colors.dart';

class TaskViewDialogBox extends StatefulWidget {
  static const id = 'taskView';
  String LeadID;

  TaskViewDialogBox({required this.LeadID});

  @override
  State<StatefulWidget> createState() {
    return _TaskViewDialogBox();
  }
}

class _TaskViewDialogBox extends State<TaskViewDialogBox> {
  List ListTaskView = [];
  var isDataFetched = false;

  @override
  void initState() {
    super.initState();
    print(widget.LeadID);
    showTaskData();
  }

  //fetch the task data by api
  void showTaskData() async {
    final paramDic = {
      "rel_id": widget.LeadID,
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetLeadTask, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        ListTaskView = data['data'] as List;
        print("reminder" + ListTaskView.toString());
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
        title: Text('Tasks'),
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
            : ListTaskView.length > 0
                ? ListView.builder(
                    itemCount: ListTaskView.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
//                            return buildList(context, index);
                      return _buildItems(context, index);
                    })
                : Center(child: Container(child: Text('no data'))));
  }

  //Fill the data on widget that fetch by server
  Widget _buildItems(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: 250,
                    child: Text(
                      ListTaskView[index]['name'].toString() == null
                          ? ''
                          : ListTaskView[index]['name'].toString(),
                      style: ColorCollection.titleStyle2,
                    ),
                  ),
                  Text(
                    ListTaskView[index]['addedfrom_name'].toString() == " "
                        ? '...'
                        : ListTaskView[index]['addedfrom_name'].toString(),
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ListTaskView[index]['dateadded'].toString() == null
                        ? ''
                        : ListTaskView[index]['dateadded'].toString(),
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      //color: Colors.black,
                      fontSize: 10.0,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.all(
                          Radius.circular(2.0),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 1.0),
                      child: Column(
                        children: [
                          Text(
                            ListTaskView[index]['status'].toString() == null
                                ? ''
                                : ListTaskView[index]['status'].toString(),
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Start date : ',
                            style: TextStyle(fontSize: 8),
                          ),
                          Text(
                            ListTaskView[index]['startdate'].toString() == null
                                ? ''
                                : ListTaskView[index]['startdate'].toString(),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              //color: Colors.black,
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Due date : ',
                            style: TextStyle(fontSize: 8),
                          ),
                          Text(
                            ListTaskView[index]['duedate'].toString() == null
                                ? ''
                                : ListTaskView[index]['duedate'].toString(),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              //color: Colors.black,
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Priority : ',
                        style: TextStyle(fontSize: 7),
                      ),
                      Text(
                        ListTaskView[index]['priority_name'].toString() == " "
                            ? ''
                            : ListTaskView[index]['priority_name'].toString(),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          //color: Colors.black,
                          fontSize: 9.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
//                  SizedBox(height: 2.0),
//                  Text(
//                    "Expiry Date",
//                    textAlign: TextAlign.justify,
//                    style: TextStyle(
//                      //color: Colors.black,
//                      fontSize: 10.0,
//                    ),
//                  ),
              Divider(
                color: Colors.grey,
              )
            ],
          ),
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
