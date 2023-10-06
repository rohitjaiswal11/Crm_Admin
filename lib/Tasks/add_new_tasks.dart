// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, avoid_print, import_of_legacy_library_into_null_safe, non_constant_identifier_names, must_be_immutable

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';

class AddNewTasks extends StatefulWidget {
  List? taskData;
  static const id = '/addnewtasks';

  AddNewTasks({this.taskData});
  @override
  State<AddNewTasks> createState() => _AddNewTasksState();
}

class _AddNewTasksState extends State<AddNewTasks> {
  String? startDateValue = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String? endDateValue;
  final _formKeyDetail = GlobalKey<FormState>();
  bool submitting = false;
  bool relatedToLoading = false;
  bool isCheckedPublic = false;
  bool isCheckedBillable = false;
  TextEditingController hourlyratecontroller = TextEditingController();
  TextEditingController discriptioncontroller = TextEditingController();
  TextEditingController tagscontroller = TextEditingController();
  TextEditingController subjectcontroller = TextEditingController();

  TextEditingController taskprioritycontroller = TextEditingController();
  Priority? _priority;
  List<Priority> _priorityList = Priority.getpriority();

  TextEditingController taskrepeatcontroller = TextEditingController();
  Repeat? _repeat;
  List<Repeat> _repeatList = Repeat.getrepeat();

  TextEditingController taskrelatedcontroller = TextEditingController();
  RelatedList? _related;
  List<RelatedList> _relatedList = RelatedList.getRelatedList();

  TextEditingController taskcustomercontroller = TextEditingController();

  TextEditingController taskinsertcheckcontroller = TextEditingController();
  bool relatedselected = false;
  String SelectedRelated = "";
  List relatedData = [];
  List<Relateddata> _relatedData = [];
  Relateddata? selectedrelateddata;
  TextEditingController relateddatacontroller = TextEditingController();

  Future<void> newTask() async {
    setState(() {
      submitting = true;
    });
    final paramDic = {
      "name": subjectcontroller.text.toString(),
      "startdate": startDateValue.toString(),
      "is_public": isCheckedPublic ? '1' : '0',
      "billable": isCheckedBillable ? '1' : '0',
      if (hourlyratecontroller.text.isNotEmpty)
        "hourly_rate": hourlyratecontroller.text.toString(),
      // "milestone": "",
      if (endDateValue != null) "duedate": endDateValue.toString(),
      if (taskprioritycontroller.text.isNotEmpty)
        "priority": taskprioritycontroller.text.toString(),
      if (taskrepeatcontroller.text.isNotEmpty)
        "repeat_every": taskrepeatcontroller.text.toString(),
      // "repeat_every_custom": "",
      // "repeat_type_custom": "",
      // "cycles": "",
      if (widget.taskData != null && widget.taskData!.isNotEmpty)
        "id": widget.taskData![0]['id'].toString(),
      "rel_type": SelectedRelated.toString(),
      "rel_id": relateddatacontroller.text.toString(),
      if (tagscontroller.text.isNotEmpty)
        "tags": tagscontroller.text.toString(),
      if (discriptioncontroller.text.isNotEmpty)
        "description": discriptioncontroller.text.toString(),
    };
    print('New Task parameters' + paramDic.toString());

    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.getask, paramDic, "Post", Api_Key_by_Admin);
    print('data =>${response.body} -- ${response.statusCode}');

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Post Data', Colors.red);
          setState(() {
            submitting = false;
          });
        }
      } catch (e) {
        ToastShowClass.toastShow(null, 'Failed to Post Data', Colors.red);
        setState(() {
          submitting = false;
        });
      }
      Navigator.pop(context);

      ToastShowClass.coolToastShow(context, 'Success', CoolAlertType.success);
    } else {
      ToastShowClass.coolToastShow(
          context, 'Something Went Wrong', CoolAlertType.error);
      setState(() {
        submitting = false;
      });
    }
  }

  Future<void> getRelated(String type) async {
    setState(() {
      relatedToLoading = true;
    });
    final paramDic = {
      "type": type.toString(),
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.relateddata, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    log(data.toString());
    relatedData.clear();
    _relatedData.clear();
    selectedrelateddata = null;
    if (response.statusCode == 200) {
      setState(() {
        relatedData.addAll(data['data']);
        for (int i = 0; i < relatedData.length; i++) {
          if (type == 'project') {
            _relatedData.add(Relateddata(
              id: relatedData[i]['id'],
              name: relatedData[i]['name'],
            ));
          } else if (type == 'invoice') {
            _relatedData.add(Relateddata(
              id: relatedData[i]['id'],
              name: '${relatedData[i]['prefix']} ${relatedData[i]['number']}',
            ));
          } else if (type == 'customer') {
            _relatedData.add(Relateddata(
              id: relatedData[i]['userid'],
              name: relatedData[i]['company'],
            ));
          } else if (type == 'estimate') {
            _relatedData.add(Relateddata(
              id: relatedData[i]['id'],
              name: '${relatedData[i]['prefix']} ${relatedData[i]['number']}',
            ));
          } else if (type == 'expense') {
            _relatedData.add(Relateddata(
              id: relatedData[i]['id'],
              name: relatedData[i]['expense_name'],
            ));
          } else if (type == 'contract') {
            _relatedData.add(Relateddata(
              id: relatedData[i]['id'],
              name: relatedData[i]['subject'],
            ));
          } else if (type == 'ticket') {
            _relatedData.add(Relateddata(
              id: relatedData[i]['ticketid'],
              name: relatedData[i]['subject'],
            ));
          } else if (type == 'lead') {
            _relatedData.add(Relateddata(
              id: relatedData[i]['id'],
              name: '${relatedData[i]['prefix']} ${relatedData[i]['company']}',
            ));
          } else if (type == 'proposal') {
            _relatedData.add(Relateddata(
              id: relatedData[i]['id'],
              name: relatedData[i]['subject'],
            ));
          }
        }
      });
      setState(() {
        relatedToLoading = false;
      });
    } else {
      setState(() {
        relatedToLoading = false;
      });
    }
  }

  void startDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2001),
            lastDate: DateTime(5050))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        startDateValue = DateFormat('yyyy-MM-dd').format(value);
      });
    });
  }

  void endDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2001),
            lastDate: DateTime(5050))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        endDateValue = DateFormat('yyyy-MM-dd').format(value);
      });
    });
  }

  getDetails() async {
    if (widget.taskData == null || widget.taskData!.isEmpty) {
      return;
    }
    final taskData = widget.taskData![0];
    subjectcontroller.text = taskData['name'];
    startDateValue = taskData['startdate'];
    isCheckedPublic = taskData['is_public'] == '0' ? false : true;
    isCheckedBillable = taskData['billable'] == '0' ? false : true;
    if (taskData['hourly_rate'] != null)
      hourlyratecontroller.text = taskData['hourly_rate'].toString();
    // "milestone": "",
    endDateValue = taskData['duedate'];
    if (taskData['priority'] != null && taskData['priority_name'] != null)
      taskprioritycontroller.text = taskData["priority"].toString();
    final prio = _priorityList.firstWhere(
        (element) => element.id.toString() == taskData["priority"].toString(),
        orElse: () {
      return Priority(700, 'name');
    });
    if (prio.id != 700) {
      _priority = prio;
    }
    // if (taskrepeatcontroller.text.isNotEmpty)
    //   "repeat_every": taskrepeatcontroller.text.toString(),
    // "repeat_every_custom": "",
    // "repeat_type_custom": "",
    // "cycles": "",
    if (taskData["rel_id"] != null && taskData["rel_type"] != null) {
      SelectedRelated = taskData["rel_type"];
      relateddatacontroller.text = taskData["rel_id"].toString();
    }

    if (taskData['description'] != null)
      discriptioncontroller.text = taskData["description"];
    setState(() {});
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // log('==> ${_relatedData}');
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
                        height: height * 0.07,
                        width: width * 0.11,
                        child: Image.asset(
                          'assets/newtask.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Text(
                        (widget.taskData != null && widget.taskData!.isNotEmpty)
                            ? 'Edit Task'
                            : KeyValues.addnewTAsk,
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
                      height: height * 0.03,
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              activeColor: ColorCollection.backColor,
                              value: isCheckedPublic,
                              onChanged: (value) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  isCheckedPublic = value!;
                                });
                              },
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Text(
                              KeyValues.public,
                              style: ColorCollection.titleStyle
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.1,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: ColorCollection.backColor,
                              value: isCheckedBillable,
                              onChanged: (value) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  isCheckedBillable = value!;
                                });
                              },
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Text(
                              KeyValues.billable,
                              style: ColorCollection.titleStyle
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      KeyValues.subject,
                      style: ColorCollection.titleStyleGreen,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      height: height * 0.06,
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        controller: subjectcontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the Subject';
                          }
                          return null;
                        },
                        // controller: leadnamecontroller,
                        style: kTextformStyle,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 5, right: 5),
                            hintText: 'Enter Subject',
                            hintStyle: kTextformHintStyle),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      KeyValues.hourlyRate,
                      style: ColorCollection.titleStyleGreen,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      height: height * 0.06,
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        controller: hourlyratecontroller,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter Hourly Rate';
                        //   }
                        //   return null;
                        // },
                        // controller: leadnamecontroller,
                        style: kTextformStyle,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 5, right: 5),
                            hintText: KeyValues.enterHourlyRate,
                            hintStyle: kTextformHintStyle),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: ColorCollection.lightgreen,
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Text(
                                  KeyValues.startDate,
                                  style: ColorCollection.titleStyle2,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            GestureDetector(
                              onTap: startDate,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.01),
                                height: height * 0.04,
                                width: width * 0.4,
                                decoration: kDropdownContainerDeco,
                                child: Center(
                                  child: Text(
                                    startDateValue == null
                                        ? '--'
                                        : '$startDateValue',
                                    style: ColorCollection.subTitleStyle2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: ColorCollection.lightgreen,
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Text(
                                  KeyValues.endDate,
                                  style: ColorCollection.titleStyle2,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            GestureDetector(
                              onTap: endDate,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.01),
                                height: height * 0.04,
                                width: width * 0.4,
                                decoration: kDropdownContainerDeco,
                                child: Center(
                                  child: Text(
                                    endDateValue == null
                                        ? '--'
                                        : '$endDateValue',
                                    style: ColorCollection.subTitleStyle2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      KeyValues.selectPriority,
                      style: ColorCollection.titleStyleGreen,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<Priority>(
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
                        value: _priority,
                        onChanged: (newValue) {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _priority = newValue!;
                            taskprioritycontroller.text =
                                _priority!.id.toString();
                          });
                        },
                        items: _priorityList.map((item) {
                          return DropdownMenuItem(
                            child: Text(item.name),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      KeyValues.repeatEvery,
                      style: ColorCollection.titleStyleGreen,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<Repeat>(
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
                        value: _repeat,
                        onChanged: (newValue) {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _repeat = newValue!;

                            taskrepeatcontroller.text = _repeat!.id.toString();
                          });
                        },
                        items: _repeatList.map((item) {
                          return DropdownMenuItem(
                            child: Text(item.name),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      KeyValues.relatedTo,
                      style: ColorCollection.titleStyleGreen,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<RelatedList>(
                        hint: Text(KeyValues.nothingSelected),
                        style: ColorCollection.titleStyle,
                        elevation: 8,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select Related To';
                          }
                          return null;
                        },
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
                        value: _related,
                        onChanged: (newValue) {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());

                            _related = newValue!;
                            taskrelatedcontroller.text =
                                _related!.id.toString();
                            relatedselected = true;
                            SelectedRelated = _related!.name;
                            getRelated(SelectedRelated.toLowerCase())
                                .then((value) {
                              setState(() {});
                            });
                          });
                        },
                        items: _relatedList.map((item) {
                          return DropdownMenuItem(
                            child: Text(item.name),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    if (relatedToLoading)
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: CircularProgressIndicator()),
                    if (_relatedData.isNotEmpty)
                      Visibility(
                        visible: relatedselected == true ? true : false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              SelectedRelated,
                              style: ColorCollection.titleStyleGreen,
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Container(
                              decoration: kDropdownContainerDeco,
                              child: DropdownButtonFormField<Relateddata>(
                                hint: Text(KeyValues.nothingSelected),
                                style: ColorCollection.titleStyle,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a value';
                                  }
                                  return null;
                                },
                                elevation: 8,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: width * 0.04),
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
                                value: selectedrelateddata,
                                onChanged: (value) {
                                  setState(() {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    selectedrelateddata = value;
                                    log('--Selected VAl --- > $value');
                                    relateddatacontroller.text =
                                        selectedrelateddata!.id!;
                                  });
                                },
                                items: _relatedData.map((user) {
                                  return DropdownMenuItem<Relateddata>(
                                    value: user,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          user.name ?? '',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        Container(
                            height: height * 0.03,
                            width: width * 0.07,
                            color: ColorCollection.green,
                            child: Center(
                              child: Icon(
                                Icons.bookmark,
                                size: 18,
                                color: Colors.white,
                              ),
                            )),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Text(
                          KeyValues.tags,
                          style: ColorCollection.titleStyleGreen,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      height: height * 0.06,
                      child: TextFormField(
                        controller: tagscontroller,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter the Tags';
                        //   }
                        //   return null;
                        // },
                        style: kTextformStyle,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 5, right: 5),
                            hintText: 'Enter tags',
                            hintStyle: kTextformHintStyle,
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      KeyValues.description,
                      style: ColorCollection.titleStyleGreen,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      height: height * 0.07,
                      width: width,
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        controller: discriptioncontroller,
                        style: kTextformStyle,
                        decoration: InputDecoration(
                          hintText: KeyValues.deschint,
                          contentPadding: EdgeInsets.only(
                              bottom: height * 0.023, left: width * 0.01),
                          hintStyle: kTextformHintStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: height * 0.045,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              KeyValues.cancel,
                              style: ColorCollection.buttonTextStyle,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        SizedBox(
                          height: height * 0.045,
                          width: width * 0.21,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ColorCollection.green)),
                            onPressed: () {
                              if (submitting) {
                                return;
                              }
                              if (_formKeyDetail.currentState!.validate()) {
                                newTask();
                                print('Start Date' + startDateValue.toString());
                                print('End Date' + endDateValue.toString());
                              } else {
                                print('here ===');
                              }
                            },
                            child: submitting
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    (widget.taskData != null &&
                                            widget.taskData!.isNotEmpty)
                                        ? 'Update'
                                        : KeyValues.save,
                                    style: ColorCollection.buttonTextStyle,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
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

class Priority {
  int id;
  String name;

  Priority(this.id, this.name);

  static List<Priority> getpriority() {
    return <Priority>[
      Priority(1, 'High'),
      Priority(2, 'Medium'),
      Priority(3, 'Low'),
    ];
  }
}

class Repeat {
  int id;
  String name;

  Repeat(this.id, this.name);

  static List<Repeat> getrepeat() {
    return <Repeat>[
      Repeat(1, ''),
      Repeat(2, '1 Month'),
      Repeat(3, '2 Month'),
      Repeat(4, '3 Month'),
      Repeat(5, '4 Month'),
      Repeat(6, '5 Month'),
      Repeat(7, '6 Month'),
      Repeat(8, '7 Month'),
      Repeat(9, '8 Month'),
      Repeat(10, '9 Month'),
      Repeat(11, '10 Month'),
      Repeat(12, '11 Month'),
      Repeat(13, '12 Month'),
      Repeat(14, 'Infinite'),
    ];
  }
}

class Customer {
  int id;
  String name;

  Customer(this.id, this.name);

  static List<Customer> getcustomer() {
    return <Customer>[
      Customer(1, 'High'),
      Customer(2, 'Medium'),
      Customer(3, 'Low'),
    ];
  }
}

class InsertCheckList {
  int id;
  String name;

  InsertCheckList(this.id, this.name);

  static List<InsertCheckList> getinsertchecklist() {
    return <InsertCheckList>[
      InsertCheckList(1, 'High'),
      InsertCheckList(2, 'Medium'),
      InsertCheckList(3, 'Low'),
    ];
  }
}

class RelatedList {
  int id;
  String name;

  RelatedList(this.id, this.name);

  static List<RelatedList> getRelatedList() {
    return <RelatedList>[
      RelatedList(1, 'Project'),
      RelatedList(2, 'Invoice'),
      RelatedList(3, 'Customer'),
      RelatedList(4, 'Estimate'),
      RelatedList(5, 'Expense'),
      RelatedList(6, 'Contract'),
      RelatedList(7, 'Ticket'),
      RelatedList(8, 'Lead'),
      RelatedList(9, 'Proposal'),
    ];
  }

  @override
  String toString() => 'RelatedList(id: $id, name: $name)';
}

class Relateddata {
  String? id;
  String? name;
  String? company;
  Relateddata({this.id, this.name, this.company});

  @override
  String toString() => 'Relateddata(id: $id, name: $name, company: $company)';
}
