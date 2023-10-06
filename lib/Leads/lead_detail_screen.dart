// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, avoid_print, non_constant_identifier_names, must_be_immutable, import_of_legacy_library_into_null_safe, unnecessary_null_comparison, prefer_if_null_operators, unused_field

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Invoice/invoiceView.dart';
import 'package:lbm_crm/Leads/addReminder.dart';
import 'package:lbm_crm/Leads/noteView.dart';
import 'package:lbm_crm/Leads/reminderView.dart';
import 'package:lbm_crm/Leads/taskview.dart';
import 'package:lbm_crm/util/routesArguments.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';

import '../Proposals/add_new_proposals.dart';

List LeadSingleData = [];

class LeadDetailScreen extends StatefulWidget {
  static const id = '/LeadDetailScreen';
  List LeadData;
  LeadDetailScreen({required this.LeadData});

  @override
  LeadDetailScreenState createState() => LeadDetailScreenState();
}

class LeadDetailScreenState extends State<LeadDetailScreen>
    with SingleTickerProviderStateMixin {
  int? tabindex;
  List listProposal = [];
  String dateCurrent = "";
  bool showFloatingButton = false;
  List<String> _values = ['A', 'B', 'C', 'D'];
  Object? _radioValueNote = 1;
  String? _selectedValue;
  late TabController _tabController;
  final formKey = GlobalKey<FormState>();
  final Description = TextEditingController();
  var CurrentDate = TextEditingController();
  int _state = 0;
  String oldStaff_ID = '', oldLead_ID = '';
  String Staff_ID = '', Lead_ID = '';
  String Type = 'notes';

  List priorities = [];
  List<Priorities> _priorities = [];
  Priorities? _selectpriorities;

  final subjectcontroller = TextEditingController();
  final hourlyratecontroller = TextEditingController();
  final startdatecontroller = TextEditingController();
  final enddatecontroller = TextEditingController();
  final prioritycontroller = TextEditingController();
  final repeateverycontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();

  void getData() async {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    //2020-01-01 00:00:00
    var formattedDate =
        "${dateParse.year}-${dateParse.month}-${dateParse.day} 00:00:00";
    oldStaff_ID = CommanClass.StaffId;
    print(oldStaff_ID);
    oldLead_ID = LeadSingleData[0]['id'].toString();
    setState(() {
      CurrentDate.text = formattedDate.toString();
      Type = 'notes';
      Staff_ID = oldStaff_ID;
      Lead_ID = oldLead_ID;
    });
  }

  void getDataTasks() async {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    //2020-01-01 00:00:00
    var formattedDate =
        "${dateParse.year}-${dateParse.month}-${dateParse.day} 00:00:00";
    oldStaff_ID = CommanClass.StaffId;
    print(oldStaff_ID);
    oldLead_ID = LeadSingleData[0]['id'].toString();
    setState(() {
      CurrentDate.text = formattedDate.toString();
      Staff_ID = oldStaff_ID;
      Lead_ID = oldLead_ID;
    });
  }

  void getProposal() async {
    print(widget.LeadData[0]['id'].toString());
    final paramDic = {
      "rel_id": widget.LeadData[0]['id'].toString(),
      "rel_type": 'lead',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetLeadProposal, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      setState(() {
        listProposal = data['data'];
      });
      print(listProposal.toString());
    }
  }

  //get lead data that hit background page in lead screen
  void ShowleadData() async {
    setState(() {
      LeadSingleData.addAll(widget.LeadData);
      CommanClass.LeadData.addAll(widget.LeadData);
      print(LeadSingleData);
    });
  }

//fetch the prioroties data by api
  void getPriorities() async {
    final paramDic = {
      "type": "priorities",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetLeadStatus, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      priorities = data['data'];

      for (int i = 0; i < priorities.length; i++) {
        setState(() {
          _priorities.add(
              Priorities(priorities[i]['priorityid'], priorities[i]['name']));
        });
      }
      print(_priorities[0].id);
    } else {
      _priorities.clear();
    }
  }

  Future<void> CheckDate(int columnumber) async {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2001),
            lastDate: DateTime(5050))
        .then((date) {
      setState(() {
        if (columnumber == 1) {
          setState(() {
            startdatecontroller.text = DateFormat("yyyy-MM-dd").format(date!);
          });
        } else if (columnumber == 2) {
          setState(() {
            enddatecontroller.text = DateFormat("yyyy-MM-dd").format(date!);
          });
        }

        //2020-01-01 00:00:00
      });
    }).whenComplete(() {
      setState(() {});
    });
    setState(() {});
  }

  final deco = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: Colors.grey.shade300, width: 1),
    color: Color(0xFFF8F8F8),
  );
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        setState(() {
          showFloatingButton = true;
        });
      } else {
        setState(() {
          showFloatingButton = false;
        });
      }
      setState(() {
        tabindex = _tabController.index;
      });
      // Do whatever you want based on the tab index
    });
    super.initState();
    LeadSingleData.clear();
    CommanClass.LeadData.clear();
    ShowleadData();
    getProposal();
    getData();
    getDataTasks();
    getPriorities();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print(LeadSingleData.toString());
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: ColorCollection.grey,
        floatingActionButton: showFloatingButton
            ? FloatingActionButton(
                backgroundColor: ColorCollection.backColor,
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AddNewProposalScreen.id)
                      .then((value) => getProposal());
                },
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: height * 0.23,
                    decoration: BoxDecoration(
                      color: ColorCollection.backColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.05,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/first.png'),
                                fit: BoxFit.fill),
                          ),
                          height: height * 0.1,
                          width: width * 0.2,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FittedBox(
                              child: Text(KeyValues.leads,
                                  softWrap: true,
                                  style: ColorCollection.screenTitleStyle),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            SizedBox(
                              width: width * 0.2,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  LeadSingleData[0]['name'] == null
                                      ? ''
                                      : LeadSingleData[0]['name'].toString(),
                                  softWrap: true,
                                  style: ColorCollection.screenTitleStyle
                                      .copyWith(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
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
                        SizedBox(
                          width: width * 0.05,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.21,
                      left: width * 0.025,
                      right: width * 0.025,
                    ),
                    child: Container(
                      height: height * 0.04,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 5)
                          ]),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ColorCollection.darkGreen),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        labelStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        unselectedLabelColor: Colors.grey.shade600,
                        onTap: (_) {
                          setState(() {
                            _tabController.index;
                          });
                        },
                        tabs: [
                          Text(
                            KeyValues.related,
                            softWrap: true,
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            KeyValues.proposal,
                            softWrap: true,
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            KeyValues.detail,
                            softWrap: true,
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                decoration: tabindex == 2
                    ? BoxDecoration()
                    : BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 5)
                        ],
                        color: ColorCollection.containerC,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                height: height * 0.7,
                width: width,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // First Tab (Related)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Stack(
                              children: [
                                Card(
                                  margin: EdgeInsets.only(top: height * 0.027),
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      gradient: LinearGradient(
                                          colors: [
                                            darken(
                                                ColorCollection.backColor, 0.1),
                                            lighten(
                                                ColorCollection.backColor, 0.1),
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: width * 0.03,
                                          vertical: height * 0.025),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.05,
                                          vertical: height * 0.03),
                                      width: width,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white54, width: 0.7),
                                        borderRadius: BorderRadius.circular(15),
                                        color: lighten(
                                            ColorCollection.backColor, 0.3),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade500),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundColor: Colors.white70,
                                                child: Icon(Icons.person),
                                              ),
                                              SizedBox(
                                                width: width * 0.03,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: width * 0.55,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        LeadSingleData[0][
                                                                        'company']
                                                                    .toString() ==
                                                                null
                                                            ? ''
                                                            : LeadSingleData[0]
                                                                    ['company']
                                                                .toString(),
                                                        style: ColorCollection
                                                            .darkGreenStyle,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.005,
                                                  ),
                                                  Text(
                                                      LeadSingleData[0]['name']
                                                                  .toString() ==
                                                              null
                                                          ? ''
                                                          : LeadSingleData[0]
                                                                  ['name']
                                                              .toString(),
                                                      style: ColorCollection
                                                          .darkGreenStyle2),
                                                  SizedBox(
                                                    height: height * 0.005,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                width * 0.04),
                                                    child: Text(
                                                        LeadSingleData[0][
                                                                        'phonenumber']
                                                                    .toString() ==
                                                                null
                                                            ? ''
                                                            : LeadSingleData[0][
                                                                    'phonenumber']
                                                                .toString(),
                                                        style: ColorCollection
                                                            .darkGreenStyle2),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                KeyValues.status,
                                                style: ColorCollection
                                                    .darkGreenStyle2,
                                              ),
                                              Text(
                                                  LeadSingleData[0][
                                                                  'status_name']
                                                              .toString() ==
                                                          null
                                                      ? ''
                                                      : LeadSingleData[0]
                                                              ['status_name']
                                                          .toString(),
                                                  style: ColorCollection
                                                      .titleStyleWhite),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                KeyValues.source,
                                                style: ColorCollection
                                                    .darkGreenStyle2,
                                              ),
                                              Text(
                                                  LeadSingleData[0][
                                                                  'source_name']
                                                              .toString() ==
                                                          null
                                                      ? ''
                                                      : LeadSingleData[0]
                                                              ['source_name']
                                                          .toString(),
                                                  style: ColorCollection
                                                      .titleStyleWhite),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                KeyValues.lastcontact,
                                                style: ColorCollection
                                                    .darkGreenStyle2,
                                              ),
                                              Text(
                                                  LeadSingleData[0]
                                                              ['lastcontact'] ==
                                                          null
                                                      ? '-'
                                                      : LeadSingleData[0]
                                                              ['lastcontact']
                                                          .toString(),
                                                  style: ColorCollection
                                                      .titleStyleWhite),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                KeyValues.lastStatusChange,
                                                style: ColorCollection
                                                    .darkGreenStyle2,
                                              ),
                                              Text(
                                                  LeadSingleData[0][
                                                              'last_status_change'] ==
                                                          null
                                                      ? ''
                                                      : LeadSingleData[0][
                                                              'last_status_change']
                                                          .toString(),
                                                  style: ColorCollection
                                                      .titleStyleWhite),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                KeyValues.lastLeadStatus,
                                                style: ColorCollection
                                                    .darkGreenStyle2,
                                              ),
                                              Text(
                                                  LeadSingleData[0][
                                                              'last_lead_status'] ==
                                                          null
                                                      ? ''
                                                      : LeadSingleData[0][
                                                              'last_lead_status']
                                                          .toString(),
                                                  style: ColorCollection
                                                      .titleStyleWhite),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                KeyValues.staffName,
                                                style: ColorCollection
                                                    .darkGreenStyle2,
                                              ),
                                              Text(
                                                  LeadSingleData[0]
                                                                  ['staff_name']
                                                              .toString() ==
                                                          null
                                                      ? ''
                                                      : LeadSingleData[0]
                                                              ['staff_name']
                                                          .toString(),
                                                  style: ColorCollection
                                                      .titleStyleWhite),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.07,
                                          vertical: height * 0.009),
                                      decoration: BoxDecoration(
                                        color: ColorCollection.darkGreen,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Text(KeyValues.billingAddress,
                                          style:
                                              ColorCollection.titleStyleWhite),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  NoteViewDialogBox.id,
                                  arguments: LeadSingleData[0]['id'].toString(),
                                );
                              },
                              child: leadItems(
                                width,
                                height,
                                'assets/notepad.png',
                                KeyValues.notes,
                                () {
                                  notesDialogBox(context, height, width);
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  TaskViewDialogBox.id,
                                  arguments: LeadSingleData[0]['id'].toString(),
                                );
                              },
                              child: leadItems(
                                width,
                                height,
                                'assets/newtask.png',
                                KeyValues.tasks,
                                () {
                                  tasksDialogBox(context, width, height);
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ReminderViewDialogBox.id,
                                  arguments: LeadSingleData[0]['id'].toString(),
                                );
                              },
                              child: leadItems(
                                width,
                                height,
                                'assets/clock.png',
                                KeyValues.reminders,
                                () {
                                  reminderDialogBox(context);
                                },
                              ),
                            ),
                            SizedBox(height: height * 0.05)
                          ],
                        ),
                      ),
                    ),
                    // Second Tab (Proposal)
                    listProposal.isNotEmpty
                        ? ListView.builder(
                            itemCount: listProposal.length,
                            itemBuilder: (c, index) {
                              return buildList(context, index, width);
                            })
                        : Center(
                            child: Text('No Data'),
                          ),
                    // Third Tab (Detail)
                    Stack(
                      children: [
                        Container(
                          height: height * 0.7,
                          margin: EdgeInsets.only(top: height * 0.025),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.06, vertical: 20),
                          width: width,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(blurRadius: 5, color: Colors.grey)
                            ],
                            color: ColorCollection.containerC,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                leadDetailContainer(
                                    width,
                                    height,
                                    'Title',
                                    LeadSingleData[0]['title'].toString(),
                                    'Source',
                                    LeadSingleData[0]['source'].toString(),
                                    Icons.message,
                                    Icons.my_location),
                                leadDetailContainer(
                                    width,
                                    height,
                                    'Staff Name',
                                    LeadSingleData[0]['staff_name'].toString(),
                                    'Product Name',
                                    LeadSingleData[0]['product_name']
                                        .toString(),
                                    Icons.my_location,
                                    Icons.my_location),
                                leadDetailContainer(
                                    width,
                                    height,
                                    'Language',
                                    LeadSingleData[0]['default_language']
                                        .toString(),
                                    'Country',
                                    LeadSingleData[0]['country'].toString(),
                                    Icons.language,
                                    Icons.location_city),
                                leadDetailContainer(
                                    width,
                                    height,
                                    'Address',
                                    LeadSingleData[0]['address'].toString(),
                                    'City',
                                    LeadSingleData[0]['city'].toString(),
                                    Icons.pin_drop,
                                    Icons.saved_search_outlined),
                                leadDetailContainer(
                                    width,
                                    height,
                                    'State',
                                    LeadSingleData[0]['state'].toString(),
                                    'Zip Code',
                                    LeadSingleData[0]['zip'].toString(),
                                    Icons.gps_fixed,
                                    Icons.podcasts_outlined),
                                leadDetailContainer(
                                    width,
                                    height,
                                    'Email',
                                    LeadSingleData[0]['email'].toString(),
                                    'Website',
                                    LeadSingleData[0]['website'].toString(),
                                    Icons.mail,
                                    Icons.http),
                                leadDetailContainer(
                                    width,
                                    height,
                                    'Phone',
                                    LeadSingleData[0]['phonenumber'].toString(),
                                    'Date Added',
                                    LeadSingleData[0]['dateadded'].toString(),
                                    Icons.gps_fixed,
                                    Icons.podcasts_outlined),
                                leadDetailContainer(
                                    width,
                                    height,
                                    'Last Status Change',
                                    LeadSingleData[0]['last_status_change']
                                        .toString(),
                                    'Last Lead Status',
                                    LeadSingleData[0]['last_lead_status']
                                        .toString(),
                                    Icons.gps_fixed,
                                    Icons.podcasts_outlined),
                                leadDetailContainer(
                                    width,
                                    height,
                                    'Last Contact',
                                    LeadSingleData[0]['lastcontact'].toString(),
                                    'Date Assigned',
                                    LeadSingleData[0]['dateassigned']
                                        .toString(),
                                    Icons.gps_fixed,
                                    Icons.podcasts_outlined),
                                leadDetailContainer(
                                    width,
                                    height,
                                    'Date Converted',
                                    LeadSingleData[0]['date_converted']
                                        .toString(),
                                    'Status',
                                    LeadSingleData[0]['status'].toString(),
                                    Icons.gps_fixed,
                                    Icons.podcasts_outlined),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.04),
                                  decoration: deco,
                                  height: height * 0.08,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.description,
                                        color: ColorCollection.backColor,
                                      ),
                                      SizedBox(
                                        width: width * 0.04,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Description',
                                              style:
                                                  ColorCollection.titleStyle),
                                          SizedBox(
                                            height: height * 0.005,
                                          ),
                                          Text(
                                              LeadSingleData[0]['description']
                                                  .toString(),
                                              style: ColorCollection
                                                  .subTitleStyle),
                                        ],
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.done_all_rounded,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.07),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.04,
                                    vertical: height * 0.005),
                                height: height * 0.035,
                                decoration: BoxDecoration(
                                    color: ColorCollection.backColor,
                                    borderRadius: BorderRadius.circular(3)),
                                child: Center(
                                  child: Text('User Information',
                                      style: ColorCollection.titleStyleWhite),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: width * 0.3,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.02,
                                    vertical: height * 0.005),
                                height: height * 0.035,
                                decoration: BoxDecoration(
                                  color: ColorCollection.backColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: width * 0.07,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                            '#' +
                                                LeadSingleData[0]['id']
                                                    .toString(),
                                            style: ColorCollection
                                                .titleStyleWhite),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                    SizedBox(
                                      width: width * 0.15,
                                      child: SingleChildScrollView(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          LeadSingleData[0]['company']
                                              .toString(),
                                          style: ColorCollection.titleStyleWhite
                                              .copyWith(
                                                  fontWeight:
                                                      FontWeight.normal),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: ColorCollection.backColor,
                                          blurRadius: 4)
                                    ]),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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

  // Reminders Dialog Box
  Future<dynamic> reminderDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            child: SingleChildScrollView(
              child: AddReminder(
                LeadId: LeadSingleData[0]['id'].toString(),
                typeOf: 'lead'.toString(),
              ),
            ),
          ),
        );
      },
    );
  }

  // Notes Dialog Box
  Future<dynamic> notesDialogBox(
      BuildContext context, double height, double width) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Description.clear();
                                dateCurrent = '';
                                _state = 0;
                                Navigator.pop(context);
                              });
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: ColorCollection.backColor,
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: ColorCollection.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03, vertical: height * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              KeyValues.newNotes,
                              style: ColorCollection.titleStyle2,
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            Text(
                              KeyValues.description,
                              style: ColorCollection.titleStyle,
                            ),
                            SizedBox(height: height * 0.02),
                            Container(
                              height: height * 0.1,
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                              ),
                              decoration: kDropdownContainerDeco,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the Description';
                                  }
                                  return null;
                                },
                                controller: Description,
                                maxLines: 4,
                                keyboardType: TextInputType.multiline,
                                autofocus: false,
                                style: kTextformStyle,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: kTextformHintStyle,
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Row(
                              children: [
                                Radio(
                                    activeColor: ColorCollection.backColor,
                                    value: 1,
                                    groupValue: _radioValueNote,
                                    onChanged: (newVal) {
                                      setState(() {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        var date = DateTime.now().toString();

                                        var dateParse = DateTime.parse(date);
                                        //2020-01-01 00:00:00
                                        var formattedDate =
                                            "${dateParse.year}-${dateParse.month}-${dateParse.day} 00:00:00";
                                        CurrentDate.text =
                                            formattedDate.toString();
                                        _radioValueNote = newVal;
                                      });
                                    }),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                Text(
                                  KeyValues.gotInTouch,
                                  style: ColorCollection.titleStyleGreen3
                                      .copyWith(fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    activeColor: ColorCollection.backColor,
                                    value: 2,
                                    groupValue: _radioValueNote,
                                    onChanged: (newVal) {
                                      setState(() {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        _radioValueNote = newVal;
                                      });
                                    }),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                Text(
                                  KeyValues.notConnected,
                                  style: ColorCollection.titleStyleGreen3
                                      .copyWith(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            SizedBox(
                              height: height * 0.045,
                              width: width,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorCollection.green),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    if (_radioValueNote == 2) {
                                      CurrentDate.text = "";
                                    }
                                    if (formKey.currentState!.validate()) {
                                      if (_state == 0) {
                                        setState(() {
                                          _state = 1;
                                          SubmitNoteAPI(
                                              Type,
                                              Lead_ID,
                                              Staff_ID,
                                              Description.text,
                                              CurrentDate.text);
                                        });
                                      }
                                    }
                                    Description.clear();
                                    _state = 0;
                                  });
                                },
                                child: setUpButtonChild(),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Tasks Dialog Box

  Future<dynamic> tasksDialogBox(
    BuildContext context,
    double width,
    double height,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          subjectcontroller.text = '';
                          hourlyratecontroller.text = '';
                          prioritycontroller.text = '';
                          startdatecontroller.text = '';
                          enddatecontroller.text = '';
                          repeateverycontroller.text = '';
                          descriptioncontroller.text = '';
                          _state = 0;
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: ColorCollection.backColor,
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: ColorCollection.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          KeyValues.newTask,
                          style: ColorCollection.titleStyle2,
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Text(
                          KeyValues.subject,
                          style: ColorCollection.titleStyle,
                        ),
                        SizedBox(height: height * 0.02),
                        Container(
                          height: height * 0.05,
                          padding: EdgeInsets.only(
                            left: width * 0.02,
                          ),
                          decoration: kDropdownContainerDeco,
                          child: TextFormField(
                            controller: subjectcontroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the Subject';
                              }

                              return null;
                            },
                            autofocus: false,
                            style: kTextformStyle,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Text(
                          KeyValues.hourlyRate,
                          style: ColorCollection.titleStyle,
                        ),
                        SizedBox(height: height * 0.02),
                        Container(
                          height: height * 0.05,
                          padding: EdgeInsets.only(
                            left: width * 0.02,
                          ),
                          decoration: kDropdownContainerDeco,
                          child: TextFormField(
                            controller: hourlyratecontroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the Hourly Rate';
                              }

                              return null;
                            },
                            autofocus: false,
                            style: kTextformStyle,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Container(
                          height: height * 0.05,
                          decoration: kDropdownContainerDeco,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  CheckDate(1).whenComplete(() {
                                    Timer.periodic(Duration(milliseconds: 500),
                                        (_) {
                                      setState(() {});
                                      print(startdatecontroller.text +
                                          '<==>' +
                                          enddatecontroller.text);
                                      if (startdatecontroller.text
                                          .contains('-')) {
                                        print('Contains');
                                        _.cancel();
                                      } else {
                                        print('not exist');
                                      }
                                    });
                                  });
                                },
                                child: SizedBox(
                                    height: height * 0.02,
                                    width: width * 0.33,
                                    child: Center(
                                      child: Text(
                                        startdatecontroller.text.isEmpty
                                            ? KeyValues.startDate
                                            : startdatecontroller.text,
                                        style:
                                            ColorCollection.titleStyle.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    )),
                              ),
                              SizedBox(
                                  height: height * 0.01,
                                  width: width * 0.04,
                                  child: VerticalDivider(
                                    color: ColorCollection.backColor,
                                  )),
                              GestureDetector(
                                onTap: () {
                                  CheckDate(2).whenComplete(() {
                                    Timer.periodic(Duration(milliseconds: 500),
                                        (_) {
                                      setState(() {});
                                      print(startdatecontroller.text +
                                          '<==>' +
                                          enddatecontroller.text);
                                      if (enddatecontroller.text
                                          .contains('-')) {
                                        print('Contains');
                                        _.cancel();
                                      } else {
                                        print('not exist');
                                      }
                                    });
                                  });
                                },
                                child: SizedBox(
                                  width: width * 0.33,
                                  child: Center(
                                    child: Text(
                                      enddatecontroller.text.isEmpty
                                          ? KeyValues.endDate
                                          : enddatecontroller.text,
                                      style:
                                          ColorCollection.titleStyle.copyWith(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Text(
                          KeyValues.priority,
                          style: ColorCollection.titleStyle2,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Container(
                          decoration: kDropdownContainerDeco,
                          child: DropdownButtonFormField<Priorities>(
                            hint: Text(
                              KeyValues.select,
                              softWrap: true,
                              style: ColorCollection.subTitleStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: ColorCollection.titleStyle,
                            elevation: 8,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 2),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 2),
                              ),
                            ),
                            dropdownColor: Colors.grey.shade100,
                            value: _selectpriorities,
                            onChanged: (Priorities? newValue) {
                              setState(() {
                                _selectpriorities = newValue!;
                                prioritycontroller.text = _selectpriorities!.id;
                                print(_selectpriorities!.id);
                              });
                            },
                            items: _priorities.map((Priorities user) {
                              return DropdownMenuItem<Priorities>(
                                value: user,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      user.name,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Text(
                          KeyValues.repeatEvery,
                          style: ColorCollection.titleStyle,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          height: height * 0.05,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                          ),
                          decoration: kDropdownContainerDeco,
                          child: TextFormField(
                            controller: repeateverycontroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the Repeat Every';
                              }

                              return null;
                            },
                            autofocus: false,
                            style: kTextformStyle,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Text(
                          KeyValues.description,
                          style: ColorCollection.titleStyle,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          height: height * 0.1,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                          ),
                          decoration: kDropdownContainerDeco,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the Description';
                              }

                              return null;
                            },
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            autofocus: false,
                            style: kTextformStyle,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        SizedBox(
                          height: height * 0.045,
                          width: width,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ColorCollection.green),
                            ),
                            onPressed: () {
                              setState(() {
                                if (formKey.currentState!.validate()) {
                                  if (_state == 0) {
                                    setState(() {
                                      _state = 1;
                                      SubmitTaskAPI(Lead_ID);
                                      subjectcontroller.text = '';
                                      hourlyratecontroller.text = '';
                                      prioritycontroller.text = '';
                                      startdatecontroller.text = '';
                                      enddatecontroller.text = '';
                                      repeateverycontroller.text = '';
                                      descriptioncontroller.text = '';
                                    });
                                    _state = 0;
                                  }
                                }
                              });
                            },
                            child: Text(
                              KeyValues.submit,
                              style: ColorCollection.titleStyleWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
          },
        );
      },
    );
  }

  Container leadItems(double width, double height, String imagePath,
      String title, Function()? onPressed) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.015),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.005),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorCollection.containerC,
        border: Border.all(color: Colors.black54, width: 0.05),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFF2FBED),
            radius: 20,
            child: Image.asset(
              imagePath,
              height: height * 0.03,
            ),
          ),
          SizedBox(
            width: width * 0.02,
          ),
          Text(
            title,
            style: ColorCollection.titleStyle2,
          ),
          Spacer(),
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

//note add api hit to store data on server
  void SubmitNoteAPI(String type, String lead_id, String staff_id,
      String description, String currentDate) async {
    final paramDic = {
      "type": type.toString(),
      "lead_id": lead_id.toString(),
      "description": description.toString(),
      "staff_id": staff_id.toString(),
      "date_contacted": currentDate.toString(),
      "typeby": "lead",
    };
    print("Note Param" + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.AddLeadReminderNotes, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _state = 0;
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.success);
        Navigator.pop(context);
      });
    } else {
      setState(() {
        _state = 0;
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.error);
      });
    }
  }

//add task the api data on server by api
  void SubmitTaskAPI(String Lead_ID) async {
    final paramDic = {
      "name": subjectcontroller.text,
      "startdate": startdatecontroller.text,
      "hourly_rate": hourlyratecontroller.text,
      "priority": prioritycontroller.text,
      "repeat_every": repeateverycontroller.text,
      "rel_id": Lead_ID.toString(),
      "rel_type": "Lead",
      "description": descriptioncontroller.text,
      "is_public": "0",
      "billable": "",
      "milestone": "",
      "duedate": enddatecontroller.text,
      "repeat_every_custom": "",
      "repeat_type_custom": "",
      "cycles": "",
      "tags": "",
    };
    print("Note Param" + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetLeadTask, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Post Data', Colors.red);
        }
      } catch (e) {
        ToastShowClass.toastShow(null, 'Failed to Post Data', Colors.red);
      }
      setState(() {
        _state = 0;
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.success);
        Navigator.pop(context);
      });
    } else {
      setState(() {
        _state = 0;
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.error);
      });
    }
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return Text(
        "SUBMIT",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      Description.clear();
      _state = 0;
      return Icon(Icons.check, color: Colors.white);
    }
  }

  Widget buildList(BuildContext context, int index, double width) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      margin: EdgeInsets.symmetric(horizontal: width * 0.03),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(InvoiceView.id,
                  arguments: Proposalinvoice(
                      url: 'https://' +
                          APIClasses.BaseURL +
                          '/crm/proposal/' +
                          listProposal[index]['id'].toString() +
                          '/' +
                          listProposal[index]['hash'].toString(),
                      Title: 'Proposal View'));
            },
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(2.3),
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: CircleAvatar(
                      backgroundColor: ColorCollection.backColor,
                      maxRadius: 20.0,
                      child: Image.asset(
                        'assets/third.png',
                        fit: BoxFit.contain,
                      ),
                    )),
                SizedBox(
                  width: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 250,
                        child: Text(
                            listProposal[index]['subject'] == null
                                ? ''
                                : listProposal[index]['subject'],
                            softWrap: true,
                            style: ColorCollection.titleStyleGreen2),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                          listProposal[index]['datecreated'] == null
                              ? ''
                              : listProposal[index]['datecreated'],
                          style: ColorCollection.titleStyle
                              .copyWith(fontWeight: FontWeight.normal)),
                      Text(
                          listProposal[index]['total'] == null
                              ? ''
                              : listProposal[index]['total'],
                          style: ColorCollection.titleStyle
                              .copyWith(fontWeight: FontWeight.normal))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: ColorCollection.backColor,
          ),
        ],
      ),
    );
  }

  Widget leadDetailContainer(
      double width,
      double height,
      String title,
      String value,
      String title2,
      String value2,
      IconData? icon1,
      IconData? icon2) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Tooltip(
            message: value == 'null' ? '' : value,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.015),
                decoration: deco,
                height: height * 0.08,
                width: width * 0.42,
                child: Row(
                  children: [
                    Icon(
                      icon1,
                      color: ColorCollection.backColor,
                      size: 30,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.21,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(title,
                                  style: ColorCollection.titleStyle)),
                        ),
                        SizedBox(height: height * 0.005),
                        SizedBox(
                            width: width * 0.2,
                            child: Text(
                              value == 'null' ? '' : value,
                              style: ColorCollection.subTitleStyle,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.done_all,
                      color: Colors.grey,
                    )
                  ],
                )),
          ),
          Tooltip(
            message: value2 == 'null' ? '' : value2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.015),
              decoration: deco,
              height: height * 0.08,
              width: width * 0.42,
              child: Row(
                children: [
                  Icon(
                    icon2,
                    color: ColorCollection.backColor,
                    size: 30,
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: width * 0.21,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child:
                                Text(title2, style: ColorCollection.titleStyle),
                          )),
                      SizedBox(height: height * 0.005),
                      SizedBox(
                        width: width * 0.2,
                        child: Text(
                          value2 == 'null' ? '' : value2,
                          overflow: TextOverflow.ellipsis,
                          style: ColorCollection.subTitleStyle,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.done_all,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Model Class for Priorities
class Priorities {
  String id;
  String name;

  Priorities(this.id, this.name);
}
