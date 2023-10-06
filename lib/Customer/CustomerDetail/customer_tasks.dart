// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Tasks/add_new_tasks.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

import '../../Tasks/task_detail_screen.dart';
import '../../Tasks/tasks_screen.dart';
import '../../util/APIClasses.dart';
import '../../util/LicenceKey.dart';
import '../../util/ToastClass.dart';
import '../../util/app_key.dart';
import '../../util/colors.dart';

class CustomerTasks extends StatefulWidget {
  final String rel_id;
  const CustomerTasks({Key? key, required this.rel_id}) : super(key: key);

  @override
  State<CustomerTasks> createState() => _CustomerTasksState();
}

class _CustomerTasksState extends State<CustomerTasks> {
  final searchController = TextEditingController();
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

  List countdata = [];

  List TaskList = [];
  List Tasknew = [];
  List TaskSearch = [];
  // List countdata = [];
  List sendData = [];
  String inprogress = '0';
  String notstarted = "0";
  String completed = '0';
  String testing = '0';
  String awaiting = '0';
  bool loading = false;
  List taskValues = [
    '',
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

  Future<void> getTask({String? status}) async {
    setState(() {
      loading = true;
    });
    final paramDic = {
      'rel_id': '${widget.rel_id}',
      if (status != null) 'status': '$status',
      // "limit": '10000',
    };
    print('=========' + paramDic.toString());
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

            Tasknew.addAll(TaskList);
            TaskSearch.addAll(Tasknew);
            countdata = data['count_data'];
            for (int i = 0; i < countdata.length; i++) {
              if (countdata[i]['status_name'] == 'In Progress') {
                inprogress = countdata[i]['total'];
                taskItems[2].statusNumber = countdata[i]['status'];
              } else if (countdata[i]['status_name'] == 'Not Started') {
                notstarted = countdata[i]['total'];
                taskItems[1].statusNumber = countdata[i]['status'];
              } else if (countdata[i]['status_name'] == 'Complete') {
                completed = countdata[i]['total'];
                taskItems[5].statusNumber = countdata[i]['status'];
              } else if (countdata[i]['status_name'] == 'Testing') {
                testing = countdata[i]['total'];
                taskItems[3].statusNumber = countdata[i]['status'];
              } else if (countdata[i]['status_name'] == 'Awaiting Feedback') {
                awaiting = countdata[i]['total'];
                taskItems[4].statusNumber = countdata[i]['status'];
              }
              taskValues = [
                '',
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          Navigator.pushNamed(context, AddNewTasks.id);
        },
      ),
      body: SelectionArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    height: height * 0.06,
                    width: width * 0.65,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: height * 0.06,
                          width: width * 0.5,
                          child: TextFormField(
                            onChanged: onSearchTextChanged,
                            decoration: InputDecoration(
                              hintText: 'Search Tasks',
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
                ],
              ),
            ),
            SizedBox(height: height * 0.01),
            Stack(
              children: [
                Container(
                  width: width,
                  margin: EdgeInsets.only(top: height * .08),
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                  ),
                  decoration:
                      kContaierDeco.copyWith(color: ColorCollection.containerC),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.01,
                      ),
                      SizedBox(
                        height: height * 0.55,
                        child: loading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Tasknew.isNotEmpty
                                ? ListView.builder(
                                    itemCount: Tasknew.length,
                                    itemBuilder: (ctx, i) =>
                                        taskDetailsContainer(
                                            height,
                                            width,
                                            Tasknew[i]['name'] == null
                                                ? ""
                                                : Tasknew[i]['name'],
                                            Tasknew[i]['status'] == null
                                                ? ""
                                                : Tasknew[i]['status'],
                                            Tasknew[i]['startdate'] == null
                                                ? ""
                                                : Tasknew[i]['startdate'],
                                            Tasknew[i]['duedate'] == null
                                                ? ""
                                                : Tasknew[i]['duedate'],
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
                ),
                Container(
                  height: height * 0.12,
                  child: ListView.builder(
                    itemCount: taskItems.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => tasksContainer(
                        width: width,
                        height: height,
                        title: taskItems[i].title,
                        statusNumber: taskItems[i].statusNumber,
                        value: taskValues[i].toString(),
                        color: taskItems[i].color),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget tasksContainer(
      {required double width,
      required double height,
      required String title,
      required String statusNumber,
      Color? color,
      required value}) {
    return InkWell(
      onTap: () async {
        if (title.toLowerCase() == 'all') {
          await getTask();
          return;
        }

        await getTask(status: statusNumber);
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
            horizontal: width * 0.02,
            vertical: height * 0.005,
          ),
          width: width * 0.28,
          height: height * 0.1,
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 7, color: Colors.grey)],
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: ColorCollection.titleStyle2
                      .copyWith(color: color, fontWeight: FontWeight.normal)),
              SizedBox(
                height: height * 0.01,
              ),
              Text('$value', style: ColorCollection.titleStyle2)
            ],
          )),
    );
  }

  Widget taskDetailsContainer(double height, double width, String title,
      String status, String startDate, String dueDate, int i) {
    return GestureDetector(
      onTap: () {
        sendData.clear();
        sendData.add(Tasknew[i]);
        Navigator.pushNamed(context, TaskDetailScreen.id, arguments: sendData)
            .then((value) {
          FocusManager.instance.primaryFocus?.unfocus();
          searchController.clear();
          getTask();
        });
      },
      child: Container(
          margin: EdgeInsets.only(bottom: height * 0.01),
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.02),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag,
                    size: 18,
                  ),
                  SizedBox(
                    width: width * 0.006,
                  ),
                  SizedBox(
                      width: width * 0.7,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            title,
                            style: ColorCollection.titleStyle2,
                          )))
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
                          Text(
                            '${KeyValues.dueDate} :',
                            style: ColorCollection.subTitleStyle
                                .copyWith(fontWeight: FontWeight.bold),
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
                    height: height * 0.04,
                    width: width * 0.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: statusColor(status)),
                    child: Center(
                      child:
                          Text(status, style: ColorCollection.titleStyleWhite2),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
