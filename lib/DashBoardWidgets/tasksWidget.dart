// ignore_for_file: file_names, import_of_legacy_library_into_null_safe, non_constant_identifier_names, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

import '../Tasks/add_new_tasks.dart';
import '../Tasks/task_detail_screen.dart';
import '../Tasks/tasks_screen.dart';
import '../util/APIClasses.dart';
import '../util/ToastClass.dart';
import '../util/app_key.dart';
import '../util/colors.dart';

class DashBoardTasks extends StatefulWidget {
  const DashBoardTasks({Key? key}) : super(key: key);

  @override
  State<DashBoardTasks> createState() => DashBoardTasksState();
}

class DashBoardTasksState extends State<DashBoardTasks> {
  Color? statusColor(String status) {
    if (status == 'In Progress') {
      return Colors.blue;
    } else if (status == 'Not Started') {
      return Colors.grey.shade500;
    } else if (status == 'Testing') {
      return Colors.grey.shade700;
    }
    return ColorCollection.green;
  }

  List TaskList = [];
  List Tasknew = [];
  List TaskSearch = [];
  List countdata = [];
  List sendData = [];
  String inprogress = '0';
  String notstarted = "0";
  String completed = '0';
  String testing = '0';
  String awaiting = '0';
  bool loading = true;
  List taskValues = [
    0,
    0,
    0,
    0,
    0,
  ];
  @override
  void initState() {
    super.initState();
    getTask();
  }

  Future<void> getTask() async {
    final paramDic = {
      'limit': '50',
      "order_by": 'desc',
    };
    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.getask, paramDic, "Get", Api_Key_by_Admin);
      var data = json.decode(response.body);
      log(response.body.toString());
      TaskList.clear();
      TaskSearch.clear();
      Tasknew.clear();
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
        if (mounted) {
          setState(() {
            TaskList = data['data'];
            TaskList.removeWhere((element) =>
                element['status'].toString().toLowerCase() == 'complete');
            Tasknew.addAll(TaskList);
            TaskSearch.addAll(Tasknew);
            countdata = data['count_data'];
            for (int i = 0; i < countdata.length; i++) {
              if (countdata[i]['status_name'] == 'In Progress') {
                inprogress = countdata[i]['total'];
              } else if (countdata[i]['status_name'] == 'Not Started') {
                notstarted = countdata[i]['total'];
              } else if (countdata[i]['status_name'] == 'Complete') {
                completed = countdata[i]['total'];
              } else if (countdata[i]['status_name'] == 'Testing') {
                testing = countdata[i]['total'];
              } else {
                awaiting = countdata[i]['total'];
              }
              taskValues = [
                notstarted,
                inprogress,
                testing,
                awaiting,
                completed
              ];
            }
            loading = false;
          });
        }
      } else {
        setState(() {
          loading = false;
        });
        TaskSearch.clear();
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  onSearchTextChanged(String text) async {
    Tasknew.clear();
    if (text.isEmpty) {
      setState(() {
        Tasknew = List.from(TaskSearch);
      });
      return;
    }
    setState(() {
      Tasknew = TaskSearch.where((item) => item['name']
          .toString()
          .toLowerCase()
          .contains(text.toString().toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
// print('----------------------------------${Tasknew.length}');
    return Container(
      height: height * 0.37,
      margin: EdgeInsets.only(bottom: height * 0.02),
      decoration: BoxDecoration(
          color: loading
              ? ColorCollection.containerC
              : ColorCollection.navBarColor,
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: height * 0.005),
            decoration: BoxDecoration(
                color: ColorCollection.backColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Image.asset(
                  'assets/newtask.png',
                  height: 30,
                  width: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, TasksScreen.id);
                  },
                  child: Text(
                    ' TASKS',
                    style: ColorCollection.titleStyleWhite.copyWith(
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AddNewTasks.id)
                              .then((value) => getTask());
                        },
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: width * 0.04,
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.005, horizontal: width * 0.02),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.03,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: taskItems.length - 1,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => tasksContainer(
                        width: width,
                        height: height,
                        title: taskItems[i].title,
                        value: int.parse(taskValues[i].toString()),
                        color: taskItems[i].color),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.005),
                        height: height * 0.25,
                        child: Tasknew.isNotEmpty
                            ? ListView.builder(
                                itemCount: Tasknew.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (ctx, i) => taskDetailsContainer(
                                    height,
                                    width,
                                    Tasknew[i]['name'] ?? "",
                                    Tasknew[i]['status'] ?? "",
                                    Tasknew[i]['startdate'] ?? "",
                                    Tasknew[i]['duedate'] ?? "",
                                    i))
                            : Center(
                                child: Text(
                                  'No Data',
                                  style: ColorCollection.titleStyle,
                                ),
                              ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget taskDetailsContainer(double height, double width, String title,
      String status, String startDate, String dueDate, int i) {
    return GestureDetector(
      onTap: () {
        sendData.clear();
        sendData.add(Tasknew[i]);
        Navigator.pushNamed(context, TaskDetailScreen.id, arguments: sendData)
            .then((value) => getTask());
      },
      child: Container(
          margin: EdgeInsets.only(bottom: height * 0.007),
          padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: 1),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag,
                    size: 15,
                  ),
                  SizedBox(
                    width: width * 0.006,
                  ),
                  Text(
                    '#${Tasknew[i]['id']}  ',
                    style: ColorCollection.subTitleStyle,
                  ),
                  Text(
                    title,
                    style: ColorCollection.titleStyle,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${KeyValues.startDate} :',
                            style: ColorCollection.subTitleStyle
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                              width: width * 0.1,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  startDate,
                                  style: ColorCollection.subTitleStyle,
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.2,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                '${KeyValues.dueDate} :',
                                style: ColorCollection.subTitleStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.1,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                dueDate,
                                style: ColorCollection.subTitleStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: height * 0.025,
                    width: width * 0.25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: statusColor(status)),
                    child: Center(
                      child: Text(status,
                          style: ColorCollection.titleStyleWhite2
                              .copyWith(fontSize: 10)),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  Widget tasksContainer(
      {required double width,
      required double height,
      required String title,
      Color? color,
      required int value}) {
    return InkWell(
      onTap: () {
        setState(() {
          Tasknew.clear();
          Tasknew.addAll(TaskList.where((element) {
            return element['status'].toString().toLowerCase() ==
                title.toLowerCase();
          }));
        });
      },
      child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.01,
          ),
          // width: width * 0.32,
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          decoration: BoxDecoration(
              // boxShadow: [BoxShadow(blurRadius: 7, color: Colors.grey)],
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: ColorCollection.titleStyle2.copyWith(
                      color: color,
                      fontWeight: FontWeight.normal,
                      fontSize: 11)),
              Text(' ($value)',
                  style: ColorCollection.titleStyle2.copyWith(fontSize: 11))
            ],
          )),
    );
  }
}
