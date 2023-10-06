// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, must_be_immutable, import_of_legacy_library_into_null_safe, unnecessary_null_comparison, prefer_if_null_operators, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../util/storage_manger.dart';

class AddNewProject extends StatefulWidget {
  static const id = '/newProject';

  @override
  State<AddNewProject> createState() => _AddNewProjectState();
}

class _AddNewProjectState extends State<AddNewProject> {
  bool submitting = false;
  bool progressThroughTasks = true;
  bool sendProjectCreatedMail = false;
  double sliderValue = 0.0;
  int calendarNum = 0;
  String _startDate = '';
  String _endDate = '';
  DateTime currentDate = DateTime.now();
  Customer? _customer;
  List<Customer> _customerlist = [];
  List customerist = [];
  String selectedTags = '';
  String selectedMembers = '';
  List<MultiSelectItem<TypeClass>> memberListItems = [];
  List<MultiSelectItem<TypeClass>> tagsListItems = [];
  TextEditingController ratecontroller = TextEditingController();
  TextEditingController hourcontroller = TextEditingController();
  TextEditingController subjectcontroller = TextEditingController();
  TextEditingController descontroller = TextEditingController();
  String loginid = CommanClass.StaffId;

  final _formKeyDetail = GlobalKey<FormState>();

  TypeClass _billingTypeValue = _billingType[0];

  TypeClass _statusTypeValue = _statusType[0];

  _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        _pickedDate(pickedDate);
      });
    }
  }

  _pickedDate(DateTime currentDate) {
    setState(() {
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

      if (calendarNum == 1) {
        _startDate = formattedDate;
      } else {
        _endDate = formattedDate;
      }
    });
  }

  getdata() async {
    loginid = await SharedPreferenceClass.GetSharedData("staff_id");
    setState(() {
      getCustomer();
      getMembers();
      getTags();
    });
  }

  Future<void> getCustomer() async {
    final paramDic = {
      "": '',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.getCustomer, paramDic, "Get", Api_Key_by_Admin);
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
      setState(() {
        customerist.addAll(data['data'][0]['customer']);

        for (int i = 0; i < customerist.length; i++) {
          _customerlist.add(Customer(
              id: customerist[i]['userid'],
              name: customerist[i]['company'],
              project: customerist[i]['project']));
        }
      });
    } else {}
  }

  Future<void> getMembers() async {
    final paramDic = {
      "type": "staff",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      var assignfield = data['data'];

      print(assignfield);
      List<TypeClass> membersList = [];
      for (int i = 0; i < assignfield.length; i++) {
        setState(() {
          membersList.add(TypeClass(
              id: assignfield[i]['staffid'].toString(),
              name: assignfield[i]['firstname'].toString() +
                  ' ' +
                  assignfield[i]['lastname'].toString()));
        });
        memberListItems = membersList
            .map((member) => MultiSelectItem<TypeClass>(member, member.name))
            .toList();
      }
    } else {}
  }

//tags api hit
  Future<void> getTags() async {
    final paramDic = {
      "type": "tags",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      var tagsfield = data['data'];
      List<TypeClass> _tagsList = [];
      for (int i = 0; i < tagsfield.length; i++) {
        setState(() {
          _tagsList.add(TypeClass(
              id: tagsfield[i]['id'].toString(),
              name: tagsfield[i]['name'].toString()));
        });
        tagsListItems = _tagsList
            .map((tag) => MultiSelectItem<TypeClass>(tag, tag.name))
            .toList();
      }
    } else {}
  }

  Future<void> saveProject() async {
    setState(() {
      submitting = true;
    });
    try {
      final paramDic = {
        "name": subjectcontroller.text,
        "clientid": _customer!.id,
        "billing_type": _billingTypeValue.id,
        "start_date": _startDate == ''
            ? DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
            : _startDate,
        "deadline": _endDate,
        "status": _statusTypeValue.id,
        if (_statusTypeValue.id == '1') "project_cost": ratecontroller.text,
        "estimated_hours": hourcontroller.text,
        "progress_from_tasks": progressThroughTasks ? 'on' : 'off',
        if (!progressThroughTasks) "progress": "${sliderValue.toInt()}",
        if (_statusTypeValue.id == '2')
          "project_rate_per_hour": ratecontroller.text,
        "description": descontroller.text.toString(),
        "tags": selectedTags,
        "project_members": selectedMembers,
        "send_created_email": sendProjectCreatedMail ? "on" : "off",
        "LoginID": loginid.toString(),
      };
      log(paramDic.toString());
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          '/crm/api/projects', paramDic, "Post", Api_Key_by_Admin);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        try {
          final data = json.decode(response.body);
          if (data['status'] != true) if (data['status'].toString() != '1') {
            ToastShowClass.toastShow(
                null, data['message'] ?? 'Failed to Post Data', Colors.red);
          }
        } catch (e) {
          setState(() {
            submitting = false;
          });
          ToastShowClass.toastShow(null, 'Failed to Post Data', Colors.red);
        }
        setState(() {
          ToastShowClass.coolToastShow(
              context, data['message'], CoolAlertType.success);
          Navigator.pop(context);
        });
      } else {
        setState(() {
          submitting = false;
          ToastShowClass.coolToastShow(context, 'Failed', CoolAlertType.error);
        });
      }
    } catch (e) {
      print('Error $e');
      ToastShowClass.coolToastShow(
          context, 'Something Went Wrong', CoolAlertType.error);
      setState(() {
        submitting = false;
      });
    }
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorCollection.grey,
      body: SingleChildScrollView(
        child: Form(
          key: _formKeyDetail,
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
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
                          height: height * 0.09,
                          width: width * 0.14,
                          child: Image.asset(
                            'assets/projects.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Text(KeyValues.newProject.toUpperCase(),
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
                                    errorBuilder: (
                                      _,
                                      __,
                                      ___,
                                    ) =>
                                        Icon(
                                      Icons.person,
                                      size: 35,
                                      color: Colors.white,
                                    ),
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
                      Text(
                        '* ${KeyValues.project} ${KeyValues.name}',
                        style: ColorCollection.titleStyle2,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.06,
                        width: width,
                        decoration: kDropdownContainerDeco,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the Project Name ';
                            }
                            return null;
                          },
                          controller: subjectcontroller,
                          style: kTextformStyle,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: width * 0.01, right: width * 0.01),
                            hintStyle: kTextformHintStyle,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Text(
                        '* ${KeyValues.Customer}',
                        style: ColorCollection.titleStyle2,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        decoration: kDropdownContainerDeco,
                        child: DropdownButtonFormField<Customer>(
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
                          value: _customer,
                          onChanged: (Customer? newValue) {
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _customer = newValue;
                            });
                          },
                          items: _customerlist.map((item) {
                            return DropdownMenuItem(
                              child: Text(item.name),
                              value: item,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: progressThroughTasks,
                            onChanged: (val) {
                              setState(() {
                                progressThroughTasks = val!;
                              });
                            },
                          ),
                          Text(
                            'Calculate Progress through tasks',
                            style: ColorCollection.titleStyle,
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        'Progress ${sliderValue.toInt()}%',
                        style: ColorCollection.titleStyle,
                      ),
                      Slider(
                          min: 0,
                          max: 100,
                          value: sliderValue,
                          onChanged: (newVal) {
                            if (!progressThroughTasks) {
                              setState(() {
                                sliderValue = newVal;
                              });
                            }
                          }),
                      Text(
                        '* ${KeyValues.billingType}',
                        style: ColorCollection.titleStyle2,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        decoration: kDropdownContainerDeco,
                        child: DropdownButtonFormField<TypeClass>(
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
                          value: _billingTypeValue,
                          onChanged: (newValue) {
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _billingTypeValue = newValue!;
                              print(_billingTypeValue);
                            });
                          },
                          items: _billingType.map((item) {
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
                        KeyValues.status,
                        style: ColorCollection.titleStyle2,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        decoration: kDropdownContainerDeco,
                        child: DropdownButtonFormField<TypeClass>(
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
                          value: _statusTypeValue,
                          onChanged: (TypeClass? newValue) {
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _statusTypeValue = newValue!;
                            });
                          },
                          items: _statusType.map((item) {
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
                      if (_billingTypeValue.id != '3')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _billingTypeValue.id == '2'
                                  ? 'Rate Per Hour'
                                  : '${KeyValues.totalRate}',
                              style: ColorCollection.titleStyle2,
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Container(
                              height: height * 0.06,
                              width: width,
                              decoration: kDropdownContainerDeco,
                              child: TextFormField(
                                controller: ratecontroller,
                                keyboardType: TextInputType.number,
                                style: kTextformStyle,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: width * 0.01, right: width * 0.01),
                                  hintStyle: kTextformHintStyle,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                          ],
                        ),
                      Text(
                        'Estimated Hours',
                        style: ColorCollection.titleStyle2,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.06,
                        width: width,
                        decoration: kDropdownContainerDeco,
                        child: TextFormField(
                          controller: hourcontroller,
                          keyboardType: TextInputType.number,
                          style: kTextformStyle,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: width * 0.01, right: width * 0.01),
                            hintStyle: kTextformHintStyle,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      MultiSelectDialogField<TypeClass>(
                        items: memberListItems,
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
                            Text("Members", style: ColorCollection.titleStyle),
                        onConfirm: (results) {
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
                          //_selectedAnimals = results;
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              calendarNum = 1;
                              _selectDate(context);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: ColorCollection.green,
                                  size: 25,
                                ),
                                SizedBox(width: width * 0.01),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(KeyValues.startDate,
                                        style: ColorCollection.titleStyle),
                                    SizedBox(
                                      height: height * 0.004,
                                    ),
                                    Text(
                                        _startDate == '' ||
                                                _startDate.isEmpty ||
                                                _startDate == null
                                            ? DateFormat('yyyy-MM-dd')
                                                .format(DateTime.now())
                                            : _startDate,
                                        style: ColorCollection.subTitleStyle),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              calendarNum = 2;
                              _selectDate(context);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: ColorCollection.green,
                                  size: 25,
                                ),
                                SizedBox(width: width * 0.01),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(KeyValues.deadline,
                                        style: ColorCollection.titleStyle),
                                    SizedBox(
                                      height: height * 0.004,
                                    ),
                                    Text(
                                        _endDate == '' ||
                                                _endDate.isEmpty ||
                                                _endDate == null
                                            ? '--'
                                            : _endDate,
                                        style: ColorCollection.subTitleStyle),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      MultiSelectDialogField<TypeClass>(
                        items: tagsListItems,
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
                            Text("Tags", style: ColorCollection.titleStyle),
                        onConfirm: (results) {
                          String tagIds = '';
                          results.forEach((element) {
                            tagIds = element.id + ',' + tagIds;
                          });
                          // log(tagIds[tagIds.length - 1].toString());
                          setState(() {
                            if (tagIds.endsWith(',')) {
                              final tags =
                                  tagIds.substring(0, tagIds.length - 1);

                              selectedTags = tags;
                              print(selectedTags);
                            } else {
                              selectedTags = tagIds;
                            }
                          });
                          //_selectedAnimals = results;
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: ColorCollection.green,
                            child: Icon(
                              Icons.contact_page_outlined,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.03,
                          ),
                          Text(
                            KeyValues.description,
                            style: ColorCollection.titleStyleGreen2,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.08,
                        width: width,
                        decoration: kDropdownContainerDeco,
                        child: TextFormField(
                          controller: descontroller,
                          maxLines: 4,
                          style: kTextformStyle.copyWith(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: KeyValues.deschint,
                            contentPadding: EdgeInsets.only(
                                left: width * 0.01, bottom: height * 0.023),
                            hintStyle:
                                kTextformHintStyle.copyWith(fontSize: 12),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: sendProjectCreatedMail,
                            onChanged: (val) {
                              setState(() {
                                sendProjectCreatedMail = val!;
                              });
                            },
                          ),
                          Text(
                            'Send project created email',
                            style: ColorCollection.titleStyle,
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      SizedBox(
                        height: height * 0.045,
                        width: width,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ColorCollection.green)),
                          onPressed: () {
                            if (!submitting) {
                              if (_customer == null) {
                                ToastShowClass.coolToastShow(
                                    context,
                                    'Please Fill all Required Fields',
                                    CoolAlertType.error);
                                return;
                              }
                              if (_formKeyDetail.currentState!.validate()) {
                                saveProject();
                              } else {
                                ToastShowClass.coolToastShow(
                                    context,
                                    'Please Fill all Required Fields',
                                    CoolAlertType.error);
                              }
                            }
                          },
                          child: Text(
                              submitting ? 'Saving ....' : KeyValues.save,
                              style: ColorCollection.buttonTextStyle),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static List<TypeClass> _billingType = [
    TypeClass(id: '1', name: "Fixed Rate"),
    TypeClass(id: '2', name: "Project Hours"),
    TypeClass(id: '3', name: "Task Hours"),
  ];

  static List<TypeClass> _statusType = [
    TypeClass(id: '1', name: "Not Started"),
    TypeClass(id: '2', name: "In Progress"),
    TypeClass(id: '3', name: "On Hold"),
    TypeClass(id: '4', name: "Cancelled"),
    TypeClass(id: '5', name: "Finished"),
  ];
}

class TypeClass {
  String id;
  String name;

  TypeClass({required this.id, required this.name});

  @override
  String toString() => 'TypeClass(id: $id, name: $name)';
}

class Customer {
  String id;
  String name;
  List project;

  Customer({required this.id, required this.name, required this.project});
}
