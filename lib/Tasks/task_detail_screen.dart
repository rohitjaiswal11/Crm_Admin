// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, must_be_immutable, prefer_typing_uninitialized_variables, avoid_print, import_of_legacy_library_into_null_safe, prefer_if_null_operators, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
// import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Tasks/add_new_tasks.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/storage_manger.dart';



import '../Plugin/lbmplugin.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../Contract/add_new_contracts.dart';
import '../Customer/CustomerDetail/customer_detail_screen.dart';
import '../Estimates/estimates_view.dart';
import '../Expenses/add_new_expenses.dart';
import '../Invoice/invoice_detail_screen.dart';
import '../Leads/lead_detail_screen.dart';
import '../Leads/lead_screen.dart';
import '../Projects/add_new_project.dart';
import '../Projects/project_details_screen.dart';
import '../Proposals/add_new_proposals.dart';
import '../Support/support_detail_screen.dart';
import '../searchable drop/src/searchable_dropdown.dart';
import '../util/routesArguments.dart';

class TaskDetailScreen extends StatefulWidget {
  static const id = '/TaskDetails';
  List Task = [];
  TaskDetailScreen({required this.Task});
  @override
  State<TaskDetailScreen> createState() => TaskDetailsScrenState();
}

class TaskDetailsScrenState extends State<TaskDetailScreen> {
  List allTaskData = [];
  final scrollController = ScrollController();
  final HtmlEditorController controller = HtmlEditorController();
  File? UploadFile;
  late String UploadFileName;
  List<Attachment> NotUploadTicket = [];
  String relatedName = '';
  Function()? relatedOnTap;
  List tagsList = [];
  // ignore: unused_field
  int _state = 0;
  String isReplyHistory = "yes";
  bool comment = false;
  String? member;
  String? taskid;
  late Map<String, dynamic> formData;
  List checklists = [];
  List checklistsdata = [];
  List<MultiSelectItem<TypeClass>> memberListItems = [];
  String selectedMembers = '';
  List status = [];
  List priority = [];
  bool valuefirst = false;
  bool valuesecond = false;
  bool createlist = false;
  bool timelist = false;
  bool starttime = false;
  bool reminder = false;
  bool taskstatus = false;
  bool taskpriority = false;
  bool assigns = false;
  bool rem = false;
  bool follows = false;
  bool showhtml = true;
  bool showchecklist = false;
  bool checktimer = false;
  String id = '';
  String Name = '';
  String loginid = '';
  String lastName = '';
  String selectfollow = '';
  String selectassignee = '';
  String selectrem = '';
  bool sending = false;
  final List<DropdownMenuItem> follow = [];
  final List<DropdownMenuItem> assign = [];
  List Folowers = [];
  List Assignee = [];
  List assigneeListnew = [];
  List followerListnew = [];
  List reminderlist = [];
  List commentlist = [];
  List TimeData = [];

  late Map<String, dynamic> FollowerData;
  TextEditingController checkcontroller = TextEditingController();
  TextEditingController datetimepicker = TextEditingController();
  TextEditingController reminderdescription = TextEditingController();
  late DateTime currentTime, endTime;

  ExpandableController expandedController =
      ExpandableController(initialExpanded: true);

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();

  @override
  void initState() {
    CommanClass.multiFileList.clear();
    allTaskData = widget.Task;
    // log(widget.Task.toString());
    getRelatedTOData(widget.Task[0]['rel_type'], widget.Task[0]['rel_id'])
        .then((value) {
      setState(() {});
    });

    getDetail();

    super.initState();
  }

  getDetail() async {
    id = allTaskData[0]['id'].toString();
    loginid = await SharedPreferenceClass.GetSharedData("staff_id");
    Name = await SharedPreferenceClass.GetSharedData("firstname");
    lastName = await SharedPreferenceClass.GetSharedData("lastname");
    setState(() {
      id = id;
      loginid = loginid;
      Name = Name;
      lastName = lastName;
    });
    print(loginid.toString() + " LOGIN ID ");
    await getTaskAssignee();
    await getstatus();
    await getTask();
    await getPriority();
    checklists = allTaskData[0]['checklist_item'];
    commentlist = allTaskData[0]['comments'];
    // taskid = allTaskData[0]['timerdata'][0]["id"].toString();
    if (allTaskData[0]['checklist_item'] != null) {
      for (int i = 0; i < allTaskData[0]['checklist_item'].length; i++) {
        allTaskData[0]['checklist_item'][i][''] == '0'
            ? valuesecond = true
            : false;
      }
    }
    setState(() {});
  }

  void CheckDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2001),
            lastDate: DateTime(5050))
        .then((date) {
      if (date != null) {
        setState(() {
          String dateCurrent = DateFormat("yyyy-MM-dd 00:00:00").format(date);
          allTaskData[0]['startdate'] = dateCurrent.toString().split(' ')[0];
          allTaskData[0]['duedate'] = dateCurrent.toString().split(' ')[0];
        });
      }
    });
  }

  Future<void> getTaskAssignee() async {
    final paramDic = {
      "id": id.toString(),
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.getassignee, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    Assignee.clear();
    Folowers.clear();
    assign.clear();
    if (response.statusCode == 200) {
      Assignee = (data['data']);
      Folowers = data['data'];

      setState(() {
        for (int i = 0; i < Assignee.length; i++) {
          assign.add(DropdownMenuItem(
            child: Text(Assignee[i]['full_name']),
            value: i.toString() +
                "/" +
                Assignee[i]['full_name'] +
                "//" +
                Assignee[i]['staffid'],
          ));
        }
        List<TypeClass> membersList = [];
        for (int i = 0; i < Assignee.length; i++) {
          setState(() {
            membersList.add(TypeClass(
                id: Assignee[i]['staffid'].toString(),
                name: Assignee[i]['full_name']));
          });
          memberListItems = membersList
              .map((member) => MultiSelectItem<TypeClass>(member, member.name))
              .toList();
        }
        print(follow.toString() + "sales");
      });

      for (int i = 0; i < Folowers.length; i++) {
        setState(() {
          for (int i = 0; i < Folowers.length; i++) {
            follow.add(DropdownMenuItem(
              child: Text(Folowers[i]['full_name']),
              value: i.toString() +
                  "/" +
                  Folowers[i]['full_name'] +
                  "/" +
                  Folowers[i]['staffid'],
            ));
          }
          print(follow.toString() + "sales");
        });
      }
    } else {}
  }

  Future<void> getstatus() async {
    final paramDic = {
      "": '',
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(
        Base_Url_For_App, APIClasses.status, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    status.clear();
    if (response.statusCode == 200) {
      status = data['data'];
    } else {}
  }

  Future<void> getPriority() async {
    final paramDic = {
      "": '',
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.priority, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    priority.clear();
    if (response.statusCode == 200) {
      priority = data['data'];
      print(priority.toString() + 'pppppppppppppppppppppppppppppppppp');
    } else {}
  }

  var paramDic;

  Future<void> update(String type, String value) async {
    print(type.toString());
    if (type == "status") {
      paramDic = {
        "task_id": id.toString(),
        "status": value.toString(),
        "type": type.toString(),
      };
    } else if (type == 'priority') {
      paramDic = {
        "task_id": id.toString(),
        "priority": value.toString(),
        "type": type.toString(),
      };
    } else if (type == 'add_assignees') {
      paramDic = {
        "task_id": id.toString(),
        "assignee": value.toString(),
        "type": type.toString()
      };
    } else if (type == 'remove_assignees') {
      paramDic = {
        "task_id": id.toString(),
        "id": value.toString(),
        "type": type,
      };
    } else if (type == 'add_followers') {
      paramDic = {
        "task_id": id.toString(),
        "follower": value.toString(),
        "type": type,
      };
    } else if (type == 'remove_followers') {
      paramDic = {
        "task_id": id.toString(),
        "id": value.toString(),
        "type": type,
      };
    } else if (type == 'add_reminder') {
      paramDic = {
        "task_id": id.toString(),
        "staff": value.toString(),
        "type": type,
        "description": reminderdescription.text.toString(),
        "date": datetimepicker.text.toString(),
      };
    } else if (type == 'edit_reminder') {
      paramDic = {
        "task_id": id.toString(),
        "reminder_id": value.toString(),
        "staff": CommanClass.remid.toString(),
        "type": type,
        "description": reminderdescription.text.toString(),
        "date": datetimepicker.text.toString(),
      };
    } else if (type == 'remove_reminder') {
      paramDic = {
        "task_id": id.toString(),
        "reminder_id": value.toString(),
        "type": type,
      };
    } else if (type == 'add_checklist') {
      paramDic = {
        "task_id": id.toString(),
        "description": value.toString(),
        "login_id": loginid.toString(),
        "type": type,
      };
    } else if (type == 'remove_checklist') {
      paramDic = {
        "checklist_id": value.toString(),
        "task_id": id.toString(),
        "type": type,
      };
    } else if (type == 'add_comment') {
      paramDic = {
        "loginid": loginid.toString(),
        "content": value.toString(),
        "task_id": id.toString(),
        // "file[]": '',
        "type": type,
      };
    }

    if (type == 'add_comment') {
      setState(() {
        sending = true;
      });
      try {
        var headers = {'authtoken': Api_Key_by_Admin};
        var request = http.MultipartRequest('POST',
            Uri.parse('https://' + Base_Url_For_App + APIClasses.update));
        request.fields.addAll(paramDic);
        for (var i = 0; i < CommanClass.multiFileList.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'file[]', CommanClass.multiFileList[i].file.path));
        }
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        // final val = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          await getDetail();
          controller.clear();
          CommanClass.multiFileList.clear();
          FocusManager.instance.primaryFocus?.unfocus();
          ToastShowClass.coolToastShow(
              context, 'Comment Added', CoolAlertType.success);
          setState(() {
            sending = false;
          });
        } else {
          ToastShowClass.coolToastShow(context, 'Failed', CoolAlertType.error);

          setState(() {
            sending = false;
          });
        }
      } catch (e) {
        setState(() {
          sending = false;
        });
      }
    } else {
      print("Note Param" + paramDic.toString());
      try {
        var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
            APIClasses.update, paramDic, "Post", Api_Key_by_Admin);
        log(' Status --> ${response.statusCode} -- resp ${response.body} -- reasonPhrase ${response.reasonPhrase}');
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          if (type == 'add_assignees' || type == 'remove_assignees') {
            setState(() {
              assigneeListnew.clear();
              assigns = true;
              assigneeListnew = data['data'][0]['assignees'];
            });
            ToastShowClass.coolToastShow(
                context, data['message'], CoolAlertType.success);
          } else if (type == 'add_followers' || type == 'remove_followers') {
            setState(() {
              followerListnew.clear();
              follows = true;
              setState(() {
                selectfollow = '';
              });

              followerListnew = data['data'][0]['followers'];
            });
            ToastShowClass.coolToastShow(
                context, data['message'], CoolAlertType.success);
          } else if (type == 'add_reminder' ||
              type == 'edit_reminder' ||
              type == 'remove_reminder') {
            reminderlist.clear();
            reminderlist = data['data'][0]['reminder'];
            setState(() {
              rem = true;
            });
            ToastShowClass.coolToastShow(
                context, data['message'], CoolAlertType.success);
          } else if (type == 'add_checklist' || type == 'remove_checklist') {
            checklists.clear();
            setState(() {
              showchecklist = true;
              checklists = data['data'][0]['checklist_item'];
            });
            ToastShowClass.coolToastShow(
                context, data['message'], CoolAlertType.success);
          } else if (type == 'add_comment' || type == 'delete_comment') {
            commentlist.clear();
            setState(() {
              showhtml = false;
              comment = false;
              commentlist = data['data'][0]['comments'];
            });
            ToastShowClass.coolToastShow(
                context, data['message'], CoolAlertType.success);
          }
        } else {
          setState(() {
            _state = 0;
            ToastShowClass.coolToastShow(
                context, data['message'], CoolAlertType.error);
          });
        }
      } catch (e, stack) {
        ToastShowClass.coolToastShow(context, '$e', CoolAlertType.error);

        log('Error ---$e\n $stack');
      }
    }
  }

  Future<void> getTask() async {
    final paramDic = {
      "": '',
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.getask + "/" + id, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    TimeData.clear();

    if (response.statusCode == 200) {
      setState(() {
        allTaskData = data['data'];
        tagsList = allTaskData[0]['tags'] ?? [];
        // log(data.toString());
        TimeData = allTaskData[0]['timerdata'];
        checktimer = false;
      });
    } else {
      checktimer = false;
    }
  }

  void starttimer(String timer) async {
    paramDic = {
      "task_id": id.toString(),
      "adminstop": 'true',
      "timer_id": allTaskData[0]['timerdata'].length > 0
          ? allTaskData[0]['timerdata'][allTaskData[0]['timerdata'].length - 1]
                      ['end_time'] ==
                  null
              ? allTaskData[0]['timerdata']
                      [allTaskData[0]['timerdata'].length - 1]['id']
                  .toString()
              : ""
          : "",
      "staff_id": loginid.toString(),
    };
    print("Note Param" + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.starttimer, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      ToastShowClass.coolToastShow(
          context, data['message'], CoolAlertType.success);

      setState(() {
        taskid = data['data'].toString();
        getTask();
      });
    } else {
      setState(() {
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.error);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print(tagsList);
    // print(widget.Task);
    // getRelatedTOData('ticket', '41');
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: ColorCollection.grey,
      endDrawer: Drawer(
        child: Container(
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 10, right: 10),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                ListView(
                  children: [
                    Text(
                      "Task Info",
                      style: ColorCollection.titleStyleGreen,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Created at ${allTaskData[0]['dateadded']}",
                      style: ColorCollection.titleStyle,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      color: ColorCollection.backColor,
                    ),
                    Row(
                      children: [
                        Icon(Icons.star_half_outlined,
                            color: ColorCollection.backColor, size: 20),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Status : "),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (taskstatus == true) {
                                taskstatus = false;
                              } else {
                                taskstatus = true;
                              }
                            });
                          },
                          child: Text(allTaskData[0]['status'].toString(),
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color:
                                      allTaskData[0]['status'] == "In Progress"
                                          ? Colors.blue
                                          : allTaskData[0]['status'] ==
                                                  "Not Started"
                                              ? Colors.blueGrey
                                              : allTaskData[0]['status'] ==
                                                      "Testing"
                                                  ? Colors.black
                                                  : ColorCollection.titleColor,
                                  fontWeight: FontWeight.w900)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            color: ColorCollection.backColor, size: 20),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Started Date : "),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                            onTap: () {
                              CheckDate();
                            },
                            child: Text(
                              allTaskData[0]['startdate'] ?? '',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.date_range,
                            color: ColorCollection.backColor, size: 20),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Due Date : "),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                            onTap: () {
                              CheckDate();
                            },
                            child: Text(
                              allTaskData[0]['duedate'] == null
                                  ? ""
                                  : allTaskData[0]['duedate'],
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.zoom_out_map_sharp,
                            color: ColorCollection.backColor, size: 20),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Priority : "),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                if (taskpriority == true) {
                                  taskpriority = false;
                                } else {
                                  taskpriority = true;
                                }
                              });
                            },
                            child: Text(
                              allTaskData[0]['priority_name'] == null
                                  ? "null"
                                  : allTaskData[0]['priority_name'],
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            color: ColorCollection.backColor, size: 20),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Hourly Rate : "),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          allTaskData[0]['hourly_rate'],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.receipt,
                            color: ColorCollection.backColor, size: 20),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Billable : "),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          allTaskData[0]['hourly_rate'] == "1"
                              ? "billable(Not Billed)"
                              : "Not Billable",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.document_scanner_sharp,
                          color: ColorCollection.backColor,
                          size: 20,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Billable Amount : "),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          allTaskData[0]['hourly_rate'],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            color: ColorCollection.backColor, size: 20),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Your Logged Time : "),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          allTaskData[0]['hourly_rate'],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the Tags';
                              }
                              return null;
                            },
                            style: kTextformStyle,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.local_offer,
                                size: 18,
                                color: ColorCollection.backColor,
                              ),
                              labelText: 'Tags',
                              labelStyle: ColorCollection.titleStyleGreen,
                              hintText: 'Enter tags',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(children: [
                      for (var i = 0; i < tagsList.length; i++)
                        Chip(
                            label: Text(
                          '${tagsList[i]['name']}',
                          style: ColorCollection.titleStyle,
                        ))
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(color: ColorCollection.backColor),
                    Row(
                      children: [
                        Icon(Icons.doorbell_rounded,
                            color: ColorCollection.backColor),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Reminders",
                          style: ColorCollection.titleStyle,
                        ),
                      ],
                    ),
                    Divider(color: ColorCollection.backColor),
                    InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: SizedBox(
                                      height: 350,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Date to be notified",
                                            style: ColorCollection.titleStyle,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              DatePicker.showDateTimePicker(
                                                  context,
                                                  showTitleActions: true,
                                                  onChanged: (date) {
                                                print(
                                                    'change $date in time zone ' +
                                                        date.timeZoneOffset
                                                            .inHours
                                                            .toString());
                                              }, onConfirm: (date) {
                                                datetimepicker.text =
                                                    date.toString();
                                                print('confirm $date');
                                              }, currentTime: DateTime.now());
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    color: ColorCollection
                                                        .backColor),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  child: TextField(
                                                    controller: datetimepicker,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("* Set reminder to"),

// SearchableDropdown<int>(
//     hintText: const Text('List of items'),
//     margin: const EdgeInsets.all(15),
//     items: List.generate(10, (i) => SearchableDropdownMenuItem(value: i, label: 'item $i', child: Text('item $i'))),
//     onChanged: (int? value) {
//         debugPrint('$value');
//     },
// ),

                                          SearchableDropdown.single(
                                            items: assign,
                                            value: selectrem,
                                            hint: "Select Assignee",
                                            searchHint: "Select one",
                                            onChanged: (value) {
                                              setState(() {
                                                rem = true;
                                                selectrem = value;
                                                CommanClass.remid = Assignee[
                                                            int.parse(selectrem
                                                                .toString()
                                                                .split('/')[0])]
                                                        ['staffid']
                                                    .toString();
                                                CommanClass.remname = Assignee[
                                                            int.parse(selectrem
                                                                .toString()
                                                                .split('/')[0])]
                                                        ['full_name']
                                                    .toString();
                                                // assigneeList.addAll(Assignee[int.parse(selectassignee.toString().split('/')[0])]['staffid'].);

                                                // addAssignee(allTaskData[0]['id'].toString(),CommanClass.assigneeid.toString());
                                              });
                                            },
                                            isExpanded: true,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "Description",
                                            style:
                                                ColorCollection.titleStyleGreen,
                                          ),
                                          SizedBox(
                                            height: 13,
                                          ),
                                          Container(
                                            decoration: kDropdownContainerDeco,
                                            child: TextFormField(
                                              controller: reminderdescription,
                                              maxLines: 5,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'Create Reminder',
                                        style: ColorCollection.buttonTextStyle,
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            ColorCollection.backColor,
                                      ),
                                      onPressed: () {
                                        update(
                                            "add_reminder", CommanClass.remid);
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                        child: Text(
                          "Create Reminder",
                          style: ColorCollection.titleStyleGreen2,
                        )),

                    SizedBox(
                      height: 10,
                    ),

                    ///IF REMINDER HAS REMINDER

                    if (rem == false && allTaskData[0]['reminder'] != null)
                      allTaskData[0]['reminder'].length > 0
                          ? SizedBox(
                              height: double.parse('55') *
                                  allTaskData[0]['reminder'].length,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: allTaskData[0]['reminder'].length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          allTaskData[0]['reminder'][i]
                                                      ['date'] ==
                                                  null
                                              ? ""
                                              : "Reminder for ${CommanClass.remname} on " +
                                                  allTaskData[0]['reminder'][i]
                                                      ['date'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                allTaskData[0]['reminder'][i]
                                                            ['description'] ==
                                                        null
                                                    ? ""
                                                    : allTaskData[0]['reminder']
                                                        [i]['description'],
                                                overflow: TextOverflow.fade,
                                                maxLines: 3,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    reminderdescription.text =
                                                        allTaskData[0]
                                                                ['reminder'][i]
                                                            ['description'];
                                                    datetimepicker.text = widget
                                                            .Task[0]['reminder']
                                                        [i]['date'];
                                                  });
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: SizedBox(
                                                            height: 400,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    "Date to be notified"),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    DatePicker.showDateTimePicker(
                                                                        context,
                                                                        showTitleActions:
                                                                            true,
                                                                        onChanged:
                                                                            (date) {
                                                                      print('change $date in time zone ' +
                                                                          date.timeZoneOffset
                                                                              .inHours
                                                                              .toString());
                                                                    }, onConfirm:
                                                                            (date) {
                                                                      datetimepicker
                                                                              .text =
                                                                          date.toString();
                                                                      print(
                                                                          'confirm $date');
                                                                    },
                                                                        currentTime:
                                                                            DateTime.now());
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .calendar_today_outlined,
                                                                          color:
                                                                              ColorCollection.backColor),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            TextField(
                                                                          controller:
                                                                              datetimepicker,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                    "* Set reminder to"),



//                                                                     SearchableDropdown<int>(
//     hintText: const Text('List of items'),
//     margin: const EdgeInsets.all(15),
//     items: List.generate(10, (i) => SearchableDropdownMenuItem(value: i, label: 'item $i', child: Text('item $i'))),
//     onChanged: (int? value) {
//         debugPrint('$value');
//     },
// )
                                                                SearchableDropdown
                                                                    .single(
                                                                  items: assign,
                                                                  value:
                                                                      selectrem,
                                                                  hint:
                                                                      "Select Assignee",
                                                                  searchHint:
                                                                      "Select one",
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      rem =
                                                                          true;
                                                                      selectrem =
                                                                          value;
                                                                      CommanClass
                                                                          .remid = Assignee[int.parse(selectrem
                                                                              .toString()
                                                                              .split('/')[0])]['staffid']
                                                                          .toString();
                                                                      CommanClass
                                                                          .remname = Assignee[int.parse(selectrem
                                                                              .toString()
                                                                              .split('/')[0])]['full_name']
                                                                          .toString();
                                                                      // assigneeList.addAll(Assignee[int.parse(selectassignee.toString().split('/')[0])]['staffid'].);

                                                                      // addAssignee(allTaskData[0]['id'].toString(),CommanClass.assigneeid.toString());
                                                                    });
                                                                  },
                                                                  isExpanded:
                                                                      true,
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                    "Description"),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      border: Border
                                                                          .all()),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        reminderdescription,
                                                                    maxLines: 3,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                'Save',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              style: TextButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    Colors.blue,
                                                              ),
                                                              onPressed: () {
                                                                update(
                                                                    "edit_reminder",
                                                                    allTaskData[0]
                                                                            [
                                                                            'reminder']
                                                                        [
                                                                        i]['id']);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Icon(
                                                  Icons.mode_edit,
                                                  color: Colors.blue,
                                                  size: 15,
                                                )),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    print("daddb");
                                                    update(
                                                        "remove_reminder",
                                                        allTaskData[0]
                                                                ['reminder'][i]
                                                            ['id']);
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.cancel,
                                                  color: Colors.redAccent,
                                                  size: 18,
                                                )),
                                          ],
                                        ),
                                      ],
                                    );
                                  }),
                            )
                          : Container(
                              height: 10,
                            )
                    else
                      SizedBox(
                        height: double.parse('40') * reminderlist.length,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: reminderlist.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reminderlist[i]['date'] == null
                                        ? ""
                                        : "Reminder for ${CommanClass.remname} on " +
                                            reminderlist[i]['date'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          reminderlist[i]['description'] == null
                                              ? ""
                                              : reminderlist[i]['description'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                reminderdescription.text =
                                                    reminderlist[i]
                                                        ['description'];
                                                datetimepicker.text =
                                                    reminderlist[i]['date'];
                                              });
                                              print("showwww");
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: SizedBox(
                                                        height: 350,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                "Date to be notified"),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                DatePicker.showDateTimePicker(
                                                                    context,
                                                                    showTitleActions:
                                                                        true,
                                                                    onChanged:
                                                                        (date) {
                                                                  print('change $date in time zone ' +
                                                                      date.timeZoneOffset
                                                                          .inHours
                                                                          .toString());
                                                                }, onConfirm:
                                                                        (date) {
                                                                  datetimepicker
                                                                          .text =
                                                                      date.toString();
                                                                  print(
                                                                      'confirm $date');
                                                                },
                                                                    currentTime:
                                                                        DateTime
                                                                            .now());
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .calendar_today_outlined,
                                                                      color: ColorCollection
                                                                          .backColor),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 200,
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          datetimepicker,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                "* Set reminder to"),

                                                                
                                                            // SearchableDropdown
                                                            //     .single(
                                                            //   items: assign,
                                                            //   value: selectrem,
                                                            //   hint:
                                                            //       "Select Assignee",
                                                            //   searchHint:
                                                            //       "Select one",
                                                            //   onChanged:
                                                            //       (value) {
                                                            //     setState(() {
                                                            //       rem = true;
                                                            //       selectrem =
                                                            //           value;
                                                            //       CommanClass
                                                            //           .remid = Assignee[int.parse(selectrem
                                                            //               .toString()
                                                            //               .split(
                                                            //                   '/')[0])]['staffid']
                                                            //           .toString();
                                                            //       CommanClass
                                                            //           .remname = Assignee[int.parse(selectrem
                                                            //               .toString()
                                                            //               .split(
                                                            //                   '/')[0])]['full_name']
                                                            //           .toString();
                                                            //       // assigneeList.addAll(Assignee[int.parse(selectassignee.toString().split('/')[0])]['staffid'].);

                                                            //       // addAssignee(allTaskData[0]['id'].toString(),CommanClass.assigneeid.toString());
                                                            //     });
                                                            //   },
                                                            //   isExpanded: true,
                                                            // ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text("Description"),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border
                                                                      .all()),
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    reminderdescription,
                                                                maxLines: 3,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text(
                                                            'Save',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          style: TextButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.blue,
                                                          ),
                                                          onPressed: () {
                                                            update(
                                                                "edit_reminder",
                                                                reminderlist[i]
                                                                    ['id']);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Icon(
                                              Icons.mode_edit,
                                              color: Colors.blue,
                                              size: 18,
                                            )),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              Icons.cancel,
                                              color: Colors.redAccent,
                                              size: 18,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(Icons.person,
                            color: ColorCollection.backColor, size: 20),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Assignees  ",
                          style: ColorCollection.titleStyleGreen,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    MultiSelectDialogField<TypeClass>(
                      items: memberListItems,
                      chipDisplay: MultiSelectChipDisplay.none(),
                      searchable: true,
                      title: Text("Select Members"),
                      selectedColor: ColorCollection.backColor,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: ColorCollection.backColor,
                          width: 0.3,
                        ),
                      ),
                      buttonIcon: Icon(Icons.arrow_drop_down),
                      buttonText:
                          Text("Assign to", style: ColorCollection.titleStyle),
                      onConfirm: (results) {
                        assigns = true;
                        // selectassignee = value;
                        String members = '';
                        results.forEach((element) {
                          members = element.id + ',' + members;
                        });
                        // log(members[members.length - 1].toString());
                        if (members.endsWith(',')) {
                          final _members =
                              members.substring(0, members.length - 1);

                          selectedMembers = _members;
                          print(selectedMembers);
                        } else {
                          selectedMembers = members;
                        }
                        setState(() {});
                        update("add_assignees", selectedMembers).then((value) {
                          setState(() {
                            selectedMembers = '';
                          });
                        });

                        //_selectedAnimals = results;
                      },
                    ),
                    SizedBox(height: 10),

                    // SearchableDropdown.single(
                    //   items: assign,
                    //   value: selectassignee,
                    //   hint: "Assign to",
                    //   searchHint: "Select one",
                    //   onChanged: (value) {
                    //     setState(() {
                    //       assigns = true;
                    //       selectassignee = value;
                    //       CommanClass.assigneeid = Assignee[int.parse(
                    //                   selectassignee.toString().split('/')[0])]
                    //               ['staffid']
                    //           .toString();
                    //       // assigneeList.addAll(Assignee[int.parse(selectassignee.toString().split('/')[0])]['staffid'].);

                    //       update("add_assignees", CommanClass.assigneeid);
                    //       // addAssignee(allTaskData[0]['id'].toString(),CommanClass.assigneeid.toString());
                    //     });
                    //   },
                    //   isExpanded: true,
                    // ),

                    if (assigns == false && allTaskData[0]['assignees'] != null)
                      GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 3,
                          crossAxisCount: 5,
                          children: List.generate(
                              allTaskData[0]['assignees'].length, (index) {
                            return Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: Image.network(
                                        allTaskData[0]['assignees'][index]
                                                    ['assignees_image'] ==
                                                null
                                            ? "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg"
                                            : 'http://ppscs.io/crm/uploads/staff_profile_images/${allTaskData[0]['assignees'][index]['staffid']}/small_${allTaskData[0]['assignees'][index]['assignees_image']}',
                                        fit: BoxFit.fill,
                                        height: 50,
                                        width: 50,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.network(
                                          "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg",
                                          fit: BoxFit.fill,
                                          height: 50,
                                          width: 50,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  SizedBox(),
                                        ),
                                      )),
                                ),
                                // CircleAvatar(
                                //   radius: 20,
                                //   backgroundImage: NetworkImage(
                                //     allTaskData[0]['assignees'][index]
                                //                 ['assignees_image'] ==
                                //             null
                                //         ? "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg"
                                //         : 'http://ppscs.io/crm/uploads/staff_profile_images/${allTaskData[0]['assignees'][index]['staffid']}/small_${allTaskData[0]['assignees'][index]['assignees_image']}',
                                //   ),
                                //   backgroundColor: Colors.transparent,
                                //   onBackgroundImageError:
                                //       (exception, stackTrace) => NetworkImage(
                                //           "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg"),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    // print(1);
                                    // print(allTaskData[0]['assignees'][index]);

                                    update(
                                        "remove_assignees",
                                        allTaskData[0]['assignees'][index]
                                            ['id']);
                                    setState(() {
                                      assigns = true;
                                    });
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ],
                            );
                          }))
                    else
                      GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 3,
                          crossAxisCount: 5,
                          children:
                              List.generate(assigneeListnew.length, (index) {
                            return
                                //assigneeListnew.length<0?
                                Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: Image.network(
                                        assigneeListnew[index]
                                                    ['assignees_image'] ==
                                                null
                                            ? "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg"
                                            : 'http://ppscs.io/crm/uploads/staff_profile_images/${assigneeListnew[index]['staffid']}/small_${assigneeListnew[index]['assignees_image']}',
                                        fit: BoxFit.fill,
                                        height: 50,
                                        width: 50,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.network(
                                          "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg",
                                          fit: BoxFit.fill,
                                          height: 50,
                                          width: 50,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  SizedBox(),
                                        ),
                                      )),
                                ),
                                // CircleAvatar(
                                //   radius: 20,
                                //   backgroundImage: NetworkImage(assigneeListnew[
                                //               index]['assignees_image'] ==
                                //           null
                                //       ? "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg"
                                //       : 'http://ppscs.io/crm/uploads/staff_profile_images/${assigneeListnew[index]['staffid']}/small_${assigneeListnew[index]['assignees_image']}'),
                                //   backgroundColor: Colors.transparent,
                                //   onBackgroundImageError:
                                //       (exception, stackTrace) => NetworkImage(
                                //           "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg"),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    // print(assigneeListnew[index]);
                                    update("remove_assignees",
                                        assigneeListnew[index]['id']);
                                    setState(() {
                                      assigns = true;
                                    });
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ],
                            );
                          })),

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(Icons.person,
                            color: ColorCollection.backColor, size: 20),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Followers  ",
                          style: ColorCollection.titleStyleGreen,
                        ),
                      ],
                    ),

//                     SearchableDropdown<int>(
//     hintText: const Text('List of items'),
//     margin: const EdgeInsets.all(15),
//     items: List.generate(10, (i) => SearchableDropdownMenuItem(value: i, label: 'item $i', child: Text('item $i'))),
//     onChanged: (int? value) {
//         debugPrint('$value');
//     },
// )
                    SearchableDropdown.single(
                      items: follow,
                      value: selectfollow,
                      hint: "Select Follower",
                      searchHint: "Select one",
                      onChanged: (value) {
                        setState(() {
                          selectfollow = value;
                          CommanClass.followerid = Folowers[int.parse(
                                      selectfollow.toString().split('/')[0])]
                                  ['staffid']
                              .toString();
                          update("add_followers", CommanClass.followerid);
                          setState(() {
                            selectfollow = '';
                          });
                        });
                      },
                      isExpanded: false,
                    ),
                   if (follows == false && allTaskData[0]['followers'] != null)
                      GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 3,
                          crossAxisCount: 5,
                          children: List.generate(
                              allTaskData[0]['followers'].length, (index) {
                            return Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: Image.network(
                                        allTaskData[0]['followers'][index]
                                                    ['follower_image'] ==
                                                null
                                            ? "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg"
                                            : 'http://ppscs.io/crm/uploads/staff_profile_images/${allTaskData[0]['followers'][index]['staffid']}/small_${allTaskData[0]['followers'][index]['follower_image']}',
                                        fit: BoxFit.fill,
                                        height: 50,
                                        width: 50,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.network(
                                          "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg",
                                          fit: BoxFit.fill,
                                          height: 50,
                                          width: 50,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  SizedBox(),
                                        ),
                                      )),
                                ),
                                // CircleAvatar(
                                //   radius: 20,
                                //   backgroundImage: NetworkImage(allTaskData[0]
                                //                   ['followers'][index]
                                //               ['follower_image'] ==
                                //           null
                                //       ? "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg"
                                //       : 'http://ppscs.io/crm/uploads/staff_profile_images/${allTaskData[0]['followers'][index]['staffid']}/small_${allTaskData[0]['followers'][index]['follower_image']}'),
                                //   backgroundColor: Colors.transparent,
                                //   onBackgroundImageError:
                                //       (exception, stackTrace) => NetworkImage(
                                //           "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg"),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    update(
                                        "remove_followers",
                                        allTaskData[0]['followers'][index]['id']
                                            .toString());
                                    setState(() {
                                      follows = true;
                                    });
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ],
                            );
                          }))
                    else
                      GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 3,
                          crossAxisCount: 5,
                          children:
                              List.generate(followerListnew.length, (index) {
                            return Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: Image.network(
                                        followerListnew[index]
                                                    ['follower_image'] ==
                                                null
                                            ? "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg"
                                            : 'http://ppscs.io/crm/uploads/staff_profile_images/${followerListnew[index]['staffid']}/small_${followerListnew[index]['follower_image']}',
                                        fit: BoxFit.fill,
                                        height: 50,
                                        width: 50,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.network(
                                          "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg",
                                          fit: BoxFit.fill,
                                          height: 50,
                                          width: 50,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  SizedBox(),
                                        ),
                                      )),
                                ),
                                // CircleAvatar(
                                //   radius: 20,
                                //   backgroundImage: NetworkImage(followerListnew[
                                //               index]['follower_image'] ==
                                //           null
                                //       ? "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg"
                                //       : 'http://ppscs.io/crm/uploads/staff_profile_images/${followerListnew[index]['staffid']}/small_${followerListnew[index]['follower_image']}'),
                                //   backgroundColor: Colors.transparent,
                                //   onBackgroundImageError:
                                //       (exception, stackTrace) => NetworkImage(
                                //           "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg"),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    update("remove_followers",
                                        followerListnew[index]['id']);
                                    setState(() {
                                      follows = true;
                                    });
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ],
                            );
                          })),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Positioned(
                  top: 105,
                  child: Visibility(
                    visible: taskstatus == true ? true : false,
                    child: Container(
                      height: 250,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              'Change Status',
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: status.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Divider(),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                taskstatus = false;
                                                allTaskData[0]['status'] =
                                                    status[index]['name'];
                                              });
                                              CommanClass.statusid =
                                                  status[index]['id']
                                                      .toString();
                                              update("status",
                                                  CommanClass.statusid);
                                            },
                                            child: Text(status[index]['name'])),
                                        Divider(
                                            color: ColorCollection.backColor),
                                      ],
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 180,
                  child: Visibility(
                    visible: taskpriority == true ? true : false,
                    child: Container(
                      height: 180,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              'Priority',
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: priority.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Divider(),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                taskpriority = false;
                                                allTaskData[0]
                                                        ['priority_name'] =
                                                    priority[index]['name'];
                                              });
                                              CommanClass.priorityid =
                                                  priority[index]['priorityid']
                                                      .toString();
                                              update("priority",
                                                  CommanClass.priorityid);
                                            },
                                            child:
                                                Text(priority[index]['name'])),
                                        Divider(
                                            color: ColorCollection.backColor),
                                      ],
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        // controller: scrollController,
        child: Column(
          children: [
            Stack(
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
                          height: height * 0.08,
                          width: width * 0.12,
                          child: Image.asset(
                            'assets/newtask.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Text(
                          KeyValues.tasks.toUpperCase(),
                          style: ColorCollection.screenTitleStyle,
                        ),
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: height * 0.18),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.08, vertical: height * 0.009),
                        decoration: BoxDecoration(
                          color: ColorCollection.backColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Container(
                            alignment: Alignment.center,
                            height: height * 0.03,
                            width: width * 0.7,
                            child: Marquee(
                              child: Text(
                                allTaskData.isEmpty
                                    ? ''
                                    : allTaskData[0]['name'] == null
                                        ? ""
                                        : allTaskData[0]['name'],
                                textAlign: TextAlign.center,
                                style: ColorCollection.titleStyleWhite,
                              ),
                            ))),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldkey.currentState?.openEndDrawer();
                    },
                    child: Container(
                        margin: EdgeInsets.only(
                            top: height * 0.18, right: width * 0.04),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.01,
                                vertical: height * 0.005),
                            decoration: BoxDecoration(
                              color: ColorCollection.backColor,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Icon(Icons.dehaze_outlined,
                                color: Colors.white))),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Stack(
              children: [
                Container(
                  height: height * 0.715,
                  margin: EdgeInsets.only(
                    top: height * 0.03,
                  ),
                  padding: EdgeInsets.only(
                      left: width * 0.06,
                      right: width * 0.06,
                      top: height * 0.01,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  width: width,
                  decoration:
                      kContaierDeco.copyWith(color: ColorCollection.containerC),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        if (TimeData != null)
                          Visibility(
                              visible: timelist == true ? true : false,
                              child: TimeData.isNotEmpty
                                  ? Container(
                                      height: 180,
                                      color: Colors.white,
                                      child: ListView.builder(
                                          itemCount: TimeData.length,
                                          // scrollDirection: Axis.vertical,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            comment = false;

                                            DateTime starttime = TimeData[index]
                                                        ['start_time'] !=
                                                    null
                                                ? DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        int.parse(
                                                            TimeData[index]
                                                                ['start_time']))
                                                : DateTime.utc(0000, 00, 0);
                                            DateTime endtime = TimeData[index]
                                                        ['end_time'] !=
                                                    null
                                                ? DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        int.parse(
                                                            TimeData[index]
                                                                ['end_time']))
                                                : DateTime.utc(0000, 00, 0);

                                            return Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Member : ${TimeData[index]['staffname'].toString()}",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                        "Start Time :${DateFormat.Hms().format(starttime)}"),
                                                    Text(
                                                        "End Time :${DateFormat.Hms().format(endtime)}"),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    )
                                  : Container(
                                      height: 5,
                                    )),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        if (relatedName != '')
                          Row(
                            children: [
                              Text('Related : ',
                                  style: ColorCollection.titleStyle2),
                              InkWell(
                                  onTap: relatedOnTap,
                                  child: SizedBox(
                                    width: width * 0.6,
                                    child: Marquee(
                                      child: Text(
                                          ' $relatedName (${allTaskData[0]['rel_type']}) ',
                                          style: ColorCollection.titleStyle2
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: ColorCollection
                                                      .backColor)),
                                    ),
                                  )),
                            ],
                          ),
                        SizedBox(height: height * 0.02),
                        Text(
                          KeyValues.description,
                          style: ColorCollection.titleStyle2,
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          height: height * 0.17,
                          width: width,
                          decoration: kDropdownContainerDeco,
                          child: SingleChildScrollView(
                            child: Text(
                              allTaskData[0]['description'],
                              style: ColorCollection.titleStyle
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: kDropdownContainerDeco,
                          child: ExpandablePanel(
                            header: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (createlist == true) {
                                        createlist = false;
                                      } else {
                                        createlist = true;
                                      }
                                      checkcontroller.text = "";
                                      valuefirst = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    color: ColorCollection.backColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  KeyValues.checkListItems,
                                  style: ColorCollection.titleStyle2,
                                ),
                              ],
                            ),
                            collapsed: checklists == null
                                ? Text('')
                                : checklists.isEmpty
                                    ? Text('')
                                    : checkList(
                                        false, checklists[0]['description'], 0),
                            expanded: checklists == null
                                ? Text('')
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: checklists.length,
                                    itemBuilder: (c, i) => checkList(
                                        false, checklists[i]['description'], i),
                                  ),
                          ),
                        ),
                        createlist == true
                            ? Row(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    checkColor: Colors.white,
                                    activeColor: Colors.green,
                                    value: valuefirst,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        valuefirst = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: width / 1.7,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.done,
                                      controller: checkcontroller,
                                      keyboardType: TextInputType.text,
                                      onFieldSubmitted: (value) {
                                        update('add_checklist',
                                            checkcontroller.text);
                                        print(checklists.toString());
                                        createlist = false;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "type here",
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          checkcontroller.text = "";
                                        });
                                      },
                                      child: Icon(Icons.cancel,
                                          color: ColorCollection.backColor)),
                                ],
                              )
                            : Container(height: 10),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: kDropdownContainerDeco,
                          child: ExpandablePanel(
                            header: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (comment == false) {
                                      await changeCommentState()
                                          .then((value) async {
                                        Timer(Duration(seconds: 1), () async {
                                          await scrollController.animateTo(
                                            scrollController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            curve: Curves.fastOutSlowIn,
                                          );
                                        });
                                      });
                                    } else {
                                      setState(() {
                                        print('close');
                                        comment = false;
                                        // showhtml = false;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    color: ColorCollection.backColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  KeyValues.comments,
                                  style: ColorCollection.titleStyle2,
                                ),
                              ],
                            ),
                            collapsed: Text(''),
                            controller: expandedController,
                            expanded: commentlist == null
                                ? Text('')
                                : ListView.builder(
                                    shrinkWrap: true,
                                    reverse: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: commentlist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _buildMessage(context, index);
                                    }),
                          ),
                        ),
                        KeyboardVisibilityBuilder(
                            builder: (context, isKeyboardVisible) {
                          // print('Check -- > $isKeyboardVisible');

                          if (isKeyboardVisible) {
                            print('here going to end');

                            Timer(Duration(seconds: 1), () async {
                              await scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.fastOutSlowIn,
                              );
                            });
                          } else {}
                          return Visibility(
                            visible: comment == true ? true : false,
                            child: Column(
                              children: [
                                HtmlEditor(
                                  controller: controller,
                                  htmlEditorOptions: HtmlEditorOptions(
                                    hint: "Your text here...",
                                  ),
                                  otherOptions: OtherOptions(
                                    height: 120,
                                  ),
                                ),
                                Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: ColorCollection.backColor)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            Icons.photo,
                                            size: 30.0,
                                            color: ColorCollection.backColor,
                                          ),
                                          onPressed: () {
                                            CommanClass.multiFileList.clear();
                                            showGeneralDialog(
                                                barrierColor: Colors.black
                                                    .withOpacity(0.5),
                                                transitionBuilder:
                                                    (context, a1, a2, widget) {
                                                  return Transform.scale(
                                                    scale: a1.value,
                                                    child: Opacity(
                                                      opacity: a1.value,
                                                      child:
                                                          AttachmentAddDialogBox(
                                                              isMultiple: true),
                                                    ),
                                                  );
                                                },
                                                transitionDuration:
                                                    Duration(milliseconds: 400),
                                                barrierDismissible: false,
                                                barrierLabel: '',
                                                context: context,
                                                pageBuilder: (context,
                                                    animation1, animation2) {
                                                  return SizedBox();
                                                }).then((value) {
                                              setState(() {});
                                            });
                                          }),
                                      SizedBox(
                                          width: width * 0.4,
                                          child: TextFormField(
                                            enabled: false,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            decoration:
                                                InputDecoration.collapsed(
                                                    hintText: CommanClass
                                                            .multiFileList
                                                            .isNotEmpty
                                                        ? CommanClass
                                                                    .multiFileList
                                                                    .length >
                                                                1
                                                            ? 'Multiple Files Selected'
                                                            : CommanClass
                                                                .multiFileList
                                                                .first
                                                                .fileName
                                                        : "No File",
                                                    hintStyle: ColorCollection
                                                        .titleStyle
                                                        .copyWith(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis)),
                                          )),
                                      if (CommanClass.multiFileList.length > 1)
                                        TextButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return _multipleItemDialog(
                                                        height, width);
                                                  }).then((value) {
                                                setState(() {});
                                              });
                                            },
                                            child: Text('View All',
                                                style: ColorCollection
                                                    .titleStyleGreen3
                                                    .copyWith(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        fontWeight:
                                                            FontWeight.w700))),
                                      IconButton(
                                          icon: !sending
                                              ? Icon(
                                                  Icons.send,
                                                  size: 30.0,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )
                                              : CircularProgressIndicator(),
                                          onPressed: () async {
                                            if (sending) {
                                              return;
                                            }
                                            String comment =
                                                await controller.getText();
                                            print(comment);
                                            setState(() {
                                              _state = 1;

                                              update('add_comment', comment);
                                              _state = 0;
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                              ],
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                         Navigator.pushNamed(context, AddNewTasks.id,arguments: widget.Task);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              allTaskData[0]['timerdata'] == null
                                  ? ColorCollection.backColor
                                  : (allTaskData[0]['timerdata'].length > 0
                                      ? allTaskData[0]['timerdata'][widget
                                                      .Task[0]['timerdata']
                                                      .length -
                                                  1]['end_time'] ==
                                              null
                                          ? Colors.redAccent.shade700
                                          : ColorCollection.backColor
                                      : ColorCollection.backColor)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Text(
                               'Edit',
                                style: ColorCollection.titleStyleWhite),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.grey.shade300,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (timelist == true) {
                                    timelist = false;
                                  } else {
                                    timelist = true;
                                  }
                                });
                              },
                              child: Icon(
                                Icons.menu,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                checktimer = true;
                                allTaskData[0]['timerdata'].length > 0
                                    ? allTaskData[0]['timerdata'][allTaskData[0]
                                                        ['timerdata']
                                                    .length -
                                                1]['end_time'] ==
                                            null
                                        ? starttimer("false")
                                        : starttimer("true")
                                    : starttimer("true");
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  allTaskData[0]['timerdata'] == null
                                      ? ColorCollection.backColor
                                      : (allTaskData[0]['timerdata'].length > 0
                                          ? allTaskData[0]['timerdata'][widget
                                                          .Task[0]['timerdata']
                                                          .length -
                                                      1]['end_time'] ==
                                                  null
                                              ? Colors.redAccent.shade700
                                              : ColorCollection.backColor
                                          : ColorCollection.backColor)),
                            ),
                            child: Row(
                              children: [
                                checktimer
                                    ? SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator())
                                    : Icon(
                                        Icons.timer,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                Text(
                                    allTaskData[0]['timerdata'] == null
                                        ? ''
                                        : (allTaskData[0]['timerdata'].length >
                                                0
                                            ? allTaskData[0]['timerdata'][widget
                                                            .Task[0]
                                                                ['timerdata']
                                                            .length -
                                                        1]['end_time'] ==
                                                    null
                                                ? "Stop Timer"
                                                : "Start Time"
                                            : "Start Timer"),
                                    style: ColorCollection.titleStyleWhite),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  StatefulBuilder _multipleItemDialog(double height, double width) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          height: height * 0.5,
          width: width * 0.8,
          decoration: BoxDecoration(
              border: Border.all(color: ColorCollection.backColor, width: 2)),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Selected Items",
                    style: ColorCollection.titleStyleGreen2,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                height: height * 0.43,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < CommanClass.multiFileList.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          CommanClass.FileURL = CommanClass
                                              .multiFileList[i].file.path;
                                          showGeneralDialog(
                                              barrierColor:
                                                  Colors.black.withOpacity(0.5),
                                              transitionBuilder:
                                                  (context, a1, a2, widget) {
                                                return Transform.scale(
                                                  scale: a1.value,
                                                  child: Opacity(
                                                    opacity: a1.value,
                                                    child: PreviewDialogBox(
                                                        isFile: true),
                                                  ),
                                                );
                                              },
                                              transitionDuration:
                                                  Duration(milliseconds: 100),
                                              barrierDismissible: false,
                                              barrierLabel: '',
                                              context: context,
                                              pageBuilder: (context, animation1,
                                                  animation2) {
                                                return SizedBox();
                                              });
                                        },
                                        child: Image.file(
                                          CommanClass.multiFileList[i].file,
                                          fit: BoxFit.fill,
                                          height: 50,
                                          width: 50,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                            Icons.insert_drive_file_sharp,
                                            color: ColorCollection.backColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      SizedBox(
                                          width: width * 0.4,
                                          child: Marquee(
                                            child: Text(CommanClass
                                                .multiFileList[i].fileName),
                                          )),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          CommanClass.multiFileList.removeAt(i);
                                        });
                                        if (CommanClass.multiFileList.isEmpty) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                color: ColorCollection.backColor,
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  ///////////////// RELATED TO DATA  START////////////////

  Future<void> getRelatedTOData(String type, String id) async {
    try {
      if (type.toLowerCase() == 'project') {
        await getprojectDashboard(id);
      } else if (type.toLowerCase() == 'invoice') {
        await getproposalinvoicedata(id);
      } else if (type.toLowerCase() == 'customer') {
        await getCustomerDashboard(id);
      } else if (type.toLowerCase() == 'estimate') {
        await getestimatesdata(id);
      } else if (type.toLowerCase() == 'expense') {
        await getExpenses(id);
      } else if (type.toLowerCase() == 'contract') {
        await getContract(id);
      } else if (type.toLowerCase() == 'ticket') {
        await getTicketDashboard(id);
      } else if (type.toLowerCase() == 'lead') {
        await getLeadDetails(id);
      } else if (type.toLowerCase() == 'proposal') {
        await getproposal(id);
      }
    } catch (e) {}
  }

//// Project API
  Future<void> getprojectDashboard(String id) async {
    final paramDic = {
      // "start": start.toString(),
      // "limit": limit.toString(),
      'rel_id': id,
      "detailtype": 'project',
      "typeof": 'project',
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDetail, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        final project = data['data'];
        relatedName = project[0]['id'].toString() + "  " + project[0]['name'];
        relatedOnTap = () {
          List Passproject = [];
          //  Passproject.clear();
          Passproject.add(project[0]);
          print(Passproject);
          Navigator.pushNamed(context, ProjectDetailScreen.id,
              arguments: Passproject);
        };
        setState(() {});
      } catch (e) {
        ToastShowClass.toastShow(null, 'Failed to Load Data', Colors.red);
      }
      print(' --- Data Found$data');
      if (mounted) {}
    } else {
      print('failed');
    }
  }

//// INVOICE API

  Future<void> getproposalinvoicedata(String id) async {
    final paramDic = {
      "staff_id": CommanClass.StaffId,
      'invoiceid': id,
      "type": 'invoices',
    };
    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.GetProposalInvoice, paramDic, "Get", Api_Key_by_Admin);
      // var data = json.decode(response.body);
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          print('data -- $data');

          // final customerData = data['data']['customer_data'];
          final listProposal = data['data'];

          relatedName = listProposal[0]['prefix'].toString() +
              listProposal[0]['number'].toString() +
              " " +
              (listProposal[0]['Invoice_name'] ?? '');
          relatedOnTap = () {
            Navigator.pushNamed(
              context,
              InvoiceDetailScreen.id,
              arguments: PageArgument(
                  Staff_id: listProposal[0]['addedfrom'].toString(),
                  Title: 'payment',
                  Invoiceid: listProposal[0]['id'].toString(),
                  InvoiceNumber: listProposal[0]['number'].toString()),
            );
          };
          setState(() {});
        } catch (e) {
          print('e-- > $e');
        }
        // log('Invoice Data' + data.toString());
      } else {
        print('else -- ${response.body} -- ${response.statusCode} ');
      }
    } catch (e) {
      log('Error -- -$e');
    }
  }

  //// Customer API

  Future<void> getCustomerDashboard(String id) async {
    final paramDic = {"staff_id": CommanClass.StaffId};

    var response = await LbmPlugin.APIMainClass(
        Base_Url_For_App,
        APIClasses.GetCustomerDashboard + '/$id',
        paramDic,
        "Get",
        Api_Key_by_Admin);
    var data = json.decode(response.body);

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
        final customerData = data['data']['customer_data'];

        relatedName = customerData[0]['company'];
        relatedOnTap = () {
          List passCustomer = [];
          passCustomer.add(customerData[0]);
          print(passCustomer);
          CommanClass.CustomerID = customerData[0]['userid'].toString();
          print(CommanClass.CustomerID);

          Navigator.pushNamed(context, CustomerDetailScreen.id,
              arguments: passCustomer);
        };
        setState(() {});
      }
    } else {}
  }

  //// ESTIMATE API
  Future<void> getestimatesdata(String id) async {
    final paramDic = {
      // "id": await SharedPreferenceClass.GetSharedData("staff_id"),
      "detailtype": 'estimate',
    };
    var response = await LbmPlugin.APIMainClass(
        Base_Url_For_App,
        APIClasses.GetCustomerDetail + '/$id',
        paramDic,
        "Get",
        Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      print('data -- $data');
      final estimate = data['data'];
      relatedName = 'EST-' +
          estimate[0]['id'].toString() +
          " " +
          (estimate[0]['Customer_name'] ?? '');

      relatedOnTap = () {
        Navigator.pushNamed(context, EstimatesView.id,
            arguments: Proposalinvoice(
              url: 'https://' +
                  APIClasses.BaseURL +
                  '/crm/estimate/' +
                  estimate[0]['id'].toString() +
                  '/' +
                  estimate[0]['hash'].toString(),
              Title: '',
            ));
      };
      setState(() {});
    } else {}
  }

  //// EXPENSE API

  Future<void> getExpenses(String id) async {
    final paramDic = {
      "": '',
    };
    print(paramDic);
    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.getExpense + '/$id', paramDic, "Get", Api_Key_by_Admin);
      log(response.body);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log('Expense Data data-- $data');
        final expense = data['data'];
        relatedName = 'Expense -' +
            (expense[0]['expense_name'] == null
                ? ""
                : expense[0]['expense_name']);
        relatedOnTap = () {
          List SendData = [];
          SendData.clear();
          SendData.add(expense[0]);
          Navigator.pushNamed(context, AddNewExpenses.id, arguments: SendData);
        };

        setState(() {});
      } else {
        print('failed -- > ${response.statusCode}');
      }
    } catch (e) {}
  }

  //// CONTRACT API

  Future<void> getContract(String id) async {
    final paramDic = {
      "id": id,
    };
    print(paramDic);
    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.getContract, paramDic, "Get", Api_Key_by_Admin);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log('===Contract Data $data');
        final contractList = data['data'];
        relatedName = 'Contract to ' +
            (contractList[0]['customer_name'] == null
                ? ""
                : contractList[0]['customer_name']);
        relatedOnTap = () {
          List SendData = [];
          SendData.clear();
          SendData.add(contractList[0]);
          Navigator.pushNamed(context, NewContractScreen.id,
              arguments: SendData);
        };

        setState(() {});
      } else {}
    } catch (e) {}
  }

  //// TICKET API

  Future<void> getTicketDashboard(String id) async {
    final paramDic = {'type': 'ticket', 'id': id};
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetTicketDetail, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      final ticketData = data['data'];
      relatedName = ticketData[0]['ticketid'].toString() == null
          ? ''
          : "#" +
              ticketData[0]['ticketid'].toString() +
              "-" +
              ticketData[0]['subject'].toString();
      relatedOnTap = () {
        List PassTicket = [];

        PassTicket.add(ticketData[0]);
        print('Pass Ticket ===' + PassTicket.toString());

        Navigator.pushNamed(context, SupportDetailScreen.id,
            arguments: PassTicket);
      };
      setState(() {});
    } else {}
  }

  //// LEAD API

  Future<void> getLeadDetails(String id) async {
    final paramDic = {
      // "view_all": '1',
      "staff_id": CommanClass.StaffId,
//      "end_date":"2020-01-30",
//      "status":"1",
      "lead_id": id,
    };
    print('params == >' + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.LeadShow, paramDic, "Get", Api_Key_by_Admin);
    log('response == > ' + response.body.toString());
    var data = json.decode(response.body);
    log(data.toString());
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        print(
            '${data['status'].toString() != '1'}  ${data['status'].toString().runtimeType}');
        if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Load Data', Colors.red);
        }
      } catch (e) {
        ToastShowClass.toastShow(null, '++++ Failed to Load Data', Colors.red);
      }
      List listCrm = [];
      List<LeadsDetails> crmleadlist = [];
      if (data['status'].toString() != false) {
        listCrm = data['data'];
        for (int i = 0; i < listCrm.length; i++) {
          crmleadlist.add(
            LeadsDetails(
              name: listCrm[i]['name'],
              id: listCrm[i]['id'],
              phoneNumber: listCrm[i]['phonenumber'],
              status: listCrm[i]['status_name'],
              isPublic: listCrm[i]['is_public'],
              junk: listCrm[i]['junk'],
              lost: listCrm[i]['lost'],
              companyName: listCrm[i]['company'],
              addedDate: listCrm[i]['dateadded'],
              lastDate: listCrm[i]['lastcontact'],
            ),
          );
        }
        final lead_id = crmleadlist.first.id;
        final leadsDetails = crmleadlist.first;
        ToastShowClass.toastShow(
            context, 'Wait Fetching Info...', Colors.green);
        final paramDic = {
          "staff_id": await SharedPreferenceClass.GetSharedData('staff_id'),
          "view_all": '1',
          "lead_id": lead_id,
        };
        try {
          var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
              APIClasses.LeadShow, paramDic, "Get", Api_Key_by_Admin);
          var resdata = json.decode(response.body);
          print("Lead Data - " + resdata['data'].toString());
          if (response.statusCode == 200) {
            relatedName =
                (leadsDetails.id == null ? '' : '#${leadsDetails.id} ') +
                    (leadsDetails.name == null ? '' : leadsDetails.name);
            relatedOnTap = () {
              Navigator.of(context)
                  .pushNamed(LeadDetailScreen.id,
                      arguments: resdata['data'] as List)
                  .whenComplete(() {});
            };

            setState(() {});
          } else {
            ToastShowClass.toastShow(
                context, 'Failed to load data...', Colors.red);
          }
        } catch (e) {
          ToastShowClass.toastShow(
              context, 'Failed to load data...', Colors.red);
        }
      } else {
        print(" 1 " + response.statusCode.toString());
      }
    } else {
      print('Not Found = ' + response.statusCode.toString());
    }
  }

  //// PROPOSAL API

  Future<void> getproposal(String id) async {
    final paramDic = {
      "staff_id": CommanClass.StaffId,
      "type": 'proposals',
      'invoiceid': id
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetProposalInvoice, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      final listProposal = data['data'];
      relatedName = 'PRO-' +
          listProposal[0]['id'].toString() +
          " " +
          listProposal[0]['subject'].toString();
      relatedOnTap = () {
        Navigator.pushNamed(
          context,
          AddNewProposalScreen.id,
          arguments: listProposal[0],
        );
      };
      setState(() {});
    } else {}
  }

  //// ///////////// RELATED TO DATA  END////////////////

  Future<void> changeCommentState() async {
    setState(() {
      print('open');
      timelist = false;
      comment = true;
      showhtml = true;
    });
  }

  Widget checkList(
    bool? ischecked,
    String title,
    int i,
  ) {
    return Row(
      children: [
        Checkbox(
            activeColor: ColorCollection.titleColor,
            value: ischecked,
            onChanged: (newVal) {
              setState(() {
                ischecked = !ischecked!;
              });
            }),
        Text(
          title,
          style: ColorCollection.titleStyle,
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            setState(() {
              update('remove_checklist', checklists[i]['id']);
            });
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  _buildMessage(BuildContext context, int index) {
    print(commentlist[index]);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // InkWell(child: Icon(Icons.edit,color : ColorCollection.backColor,color:Colors.blue,size: 15,)),
              // SizedBox(width:10,),
              // Icon(Icons.cancel,color : ColorCollection.backColor,color:Colors.red,size: 15,),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Name + ' ' + lastName,
                    style: ColorCollection.titleStyleGreen2,
                  ),
                  Text(
                      commentlist[index]['dateadded'] == null
                          ? ''
                          : commentlist[index]['dateadded']
                              .toString()
                              .split(' ')[0],
                      style: ColorCollection.titleStyleGreen3),
                ],
              ),
              SizedBox(
                height: 3.0,
              ),
              Text(
                  commentlist[index]['content'] == null
                      ? ''
                      : commentlist[index]['content']
                              .toString()
                              .contains('[task_attachment]')
                          ? commentlist[index]['content']
                              .toString()
                              .replaceAll('[task_attachment]', '')
                          : commentlist[index]['content'].toString(),
                  style: ColorCollection.subTitleStyle2.copyWith(
                    color: Colors.black,
                  )),
              SizedBox(
                height: 5,
              ),
              if (commentlist[index]['content']
                  .toString()
                  .contains('[task_attachment]'))
                Wrap(
                  children: [
                    for (var i = 0;
                        i < commentlist[index]['file_name'].length;
                        i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            CommanClass.FileURL =
                                'http://ppscs.io/crm/download/preview_image?path=uploads/tasks/${commentlist[index]['taskid']}/${commentlist[index]['file_name'][i]['file_name']}';
                            showGeneralDialog(
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionBuilder: (context, a1, a2, widget) {
                                  return Transform.scale(
                                    scale: a1.value,
                                    child: Opacity(
                                      opacity: a1.value,
                                      child: PreviewDialogBox(),
                                    ),
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 100),
                                barrierDismissible: false,
                                barrierLabel: '',
                                context: context,
                                pageBuilder: (context, animation1, animation2) {
                                  return SizedBox();
                                });
                          },
                          child: Image.network(
                            'http://ppscs.io/crm/download/preview_image?path=uploads/tasks/${commentlist[index]['taskid']}/${commentlist[index]['file_name'][i]['file_name']}',
                            fit: BoxFit.fill,
                            height: 50,
                            width: 50,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return CircularProgressIndicator();
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                  '${commentlist[index]['file_name'][0]['file_name']}');
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              Divider(
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );

    // return Row(
    //   children: <Widget>[
    //     msg,
    //   ],
    // );
  }

  // ShowUploadFile() {
  //   setState(() {
  //     UploadFile = CommanClass.UploadFile!;
  //     UploadFileName = CommanClass.UploadFilename;
  //   });
  // }
}

class CheckList {
  bool? ischecked;
  final String title;

  CheckList(
    this.ischecked,
    this.title,
  );
}

List<CheckList> checkListItems = [
  CheckList(
    false,
    'Testing',
  ),
  CheckList(
    false,
    '1234567',
  ),
  CheckList(
    false,
    'add',
  ),
];

class Attachment {
  String FileName;
  String FileType;
  Attachment(
    this.FileName,
    this.FileType,
  );
}

class AttachmentAddDialogBox extends StatefulWidget {
  bool? isMultiple;
  AttachmentAddDialogBox({this.isMultiple});
  @override
  State<AttachmentAddDialogBox> createState() => _AttachmentAddDialogBoxState();
}

class _AttachmentAddDialogBoxState extends State<AttachmentAddDialogBox> {
  final TextStyle subtitle =
      TextStyle(fontSize: CommanClass.body_textsize, color: Colors.grey);

  final TextStyle label =
      TextStyle(fontSize: CommanClass.header_textsize, color: Colors.grey);

  String imageFile = "";

  @override
  void initState() {
    CommanClass.multiFileList.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        height: 220,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Attachment",
                      style: ColorCollection.titleStyleGreen2,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child:
                          Icon(Icons.close, color: ColorCollection.backColor),
                    )
                  ],
                ),

                Divider(),
//                CheckboxListTile(title: Text('Public'),value: _isChecked,onChanged: (val){setState((){});},),
                //choose options for camera and gallery
                Column(
                  children: <Widget>[
                    Center(
                        child: Text(
                      "Choose Option",
                      style: ColorCollection.titleStyle2,
                    )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (widget.isMultiple != null) {
                              var picture = await ImagePicker.platform
                                  .getImage(source: ImageSource.camera);
                              File _imageFilePicked = File(picture!.path);

                              setState(() {
                                if (picture == null) {
                                } else {
                                  CommanClass.multiFileList.add(MultiFileClass(
                                      file: _imageFilePicked,
                                      fileName: picture.path.split('/').last));

                                  setState(() {});
                                  Navigator.pop(context);
                                }
                              });
                            } else {
                              var picture = await ImagePicker.platform
                                  .getImage(source: ImageSource.camera);
                              File _imageFilePicked = File(picture!.path);

                              setState(() {
                                if (picture == null) {
                                } else {
                                  CommanClass.UploadFile = _imageFilePicked;
                                  CommanClass.UploadFilename =
                                      picture.path.split('/').last;
                                  setState(() {});
                                  Navigator.pop(context);
                                }
                              });
                            }
                            //
                            //
                            // Navigator.pop(context,true);
                            // imageFile = picture;
                            // Customer_Files(picture);
                          },
                          child: Icon(
                            Icons.camera,
                            color: ColorCollection.black,
                            size: 50,
                          ),
                        ),
                        Text('Camera')
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (widget.isMultiple == true) {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(allowMultiple: true);

                              setState(() {
                                if (result == null) {
                                } else {
                                  List<File> files = result.paths
                                      .map((path) => File(path!))
                                      .toList();
                                  for (var i = 0; i < files.length; i++) {
                                    CommanClass.multiFileList.add(
                                        MultiFileClass(
                                            file: File(files[i].path),
                                            fileName:
                                                files[i].path.split('/').last));
                                  }
                                  Navigator.pop(context);
                                }
                              });
                            } else {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();

                              setState(() {
                                if (result == null) {
                                } else {
                                  File file = File(result.files.single.path!);
                                  CommanClass.UploadFile = file;
                                  CommanClass.UploadFilename =
                                      file.path.split('/').last;
                                  Navigator.pop(context);
                                }
                              });
                            }
                          },
                          child: Icon(
                            Icons.dashboard,
                            size: 50,
                            color: Colors.black,
                          ),
                        ),
                        Text('Gallery')
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class MultiFileClass {
  final File file;
  final String fileName;

  MultiFileClass({required this.file, required this.fileName});
}
