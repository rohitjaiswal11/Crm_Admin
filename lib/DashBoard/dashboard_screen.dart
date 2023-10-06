// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, must_be_immutable, prefer_final_fields, unused_field, avoid_print, non_constant_identifier_names, import_of_legacy_library_into_null_safe, prefer_adjacent_string_concatenation, unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lbm_crm/Customer/customers_screen.dart';
import 'package:lbm_crm/DashBoard/dashboardChart.dart';
import 'package:lbm_crm/DashBoardWidgets/projectsWidget.dart';
import 'package:lbm_crm/DashBoardWidgets/supportWidget.dart';
import 'package:lbm_crm/DashBoardWidgets/tasksWidget.dart';
import 'package:lbm_crm/Invoice/invoices_screen.dart';
import 'package:lbm_crm/Master_Search/searchScreen.dart';
import 'package:lbm_crm/Support/support_screen.dart';
import 'package:lbm_crm/Tasks/tasks_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/storage_manger.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../util/ToastClass.dart';

String TotalLeads = "0", TotalCustomer = "0", TotalProject = "0";

String new_staff_firstname = '.',
    new_staff_lastname = '',
    new_staff_email = '',
    new_staff_ID = '',
    new_profile_Image = '';

class DashBoardScreen extends StatefulWidget {
  static const id = '/DashBoard';
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with SingleTickerProviderStateMixin {
  String staff_firstname = '',
      staff_lastname = '',
      staff_email = '',
      staff_ID = '',
      profile_image = '';

  List listdashboard = [];
  String ProjectChart = '';
  String LeadChart = '';
  String TicketStatus = '';
  String TicketDepartment = '';

  Map<String, double> dataMap = {};
  Map<String, double> lead_chart = {};
  Map<String, double> project_chart = {};
  Map<String, double> ticketstatus_chart = {};
  Map<String, double> ticketdepartment_chart = {};
  List<Color> colorList = [];
  List<Color> lead_chartcolorList = [];
  List<Color> project_chartcolorList = [];
  List<Color> ticketstatus_chartcolorList = [];
  List<Color> ticketdepartment_chartcolorList = [];
  bool isSelected = false;
  late TabController _tabController;
  final ScrollController controller = ScrollController();

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  bool demoshowing = false;
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();
  List<DashBoardWidgets> widgetsList = [
    DashBoardWidgets(
      isVisible: false,
      widget: DashBoardTasks(),
    ),
    DashBoardWidgets(
      isVisible: false,
      widget: DashBoardSupport(),
    ),
    DashBoardWidgets(
      isVisible: false,
      widget: DashBoardProjects(),
    ),
  ];
  var HeaderLogo;

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

//Get the Dashboard Data by API by Login ID or StaffID
  Future<void> getDashboard() async {
    final paramDic = {
      "staff_id": await SharedPreferenceClass.GetSharedData("staff_id"),
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetDashboard, paramDic, "Get", Api_Key_by_Admin);

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
      var data = json.decode(response.body);

      if (mounted) {
        setState(() {
          TotalLeads = data['total_leads'].toString();
          TotalCustomer = data['total_customer'].toString();
          TotalProject = data['total_project'].toString();

          //Lead Chart Data
          if (data['lead_chart'] == null) {
            LeadChart = "False";
          } else {
            if (data['lead_chart'].length > 0) {
              for (int i = 0; i < data['lead_chart'].length; i++) {
                lead_chart.putIfAbsent(
                    data['lead_chart'][i]['name'] +
                        "( " +
                        data['lead_chart'][i]['total'] +
                        " )",
                    () => double.parse(data['lead_chart'][i]['total']));

                lead_chartcolorList
                    .add(_colorFromHex(data['lead_chart'][i]['color']));
              }
            } else {
              lead_chart.putIfAbsent(
                  "no data" + "( " + "0" + " )", () => double.parse("0"));

              lead_chartcolorList.add(Colors.grey);
            }
          }
          //Project Chart Data
          if (data['project_chart'] == null) {
            ProjectChart = "False";
          } else {
            if (data['project_chart'].length > 0) {
              for (int i = 0; i < data['project_chart'].length; i++) {
                project_chart.putIfAbsent(
                    data['project_chart'][i]['name'] +
                        "( " +
                        data['project_chart'][i]['total'] +
                        " )",
                    () => double.parse(data['project_chart'][i]['total']));

                project_chartcolorList
                    .add(_colorFromHex(data['project_chart'][i]['color']));
              }
            } else {
              project_chart.putIfAbsent(
                  "no data" + "( " + "0" + " )", () => double.parse("0"));

              project_chartcolorList.add(Colors.grey);
            }
          }
          //Ticket Status Chart Data
          if (data['ticketstatus_chart'] == null) {
            TicketStatus = "False";
          } else {
            if (data['ticketstatus_chart'].length > 0) {
              for (int i = 0; i < data['ticketstatus_chart'].length; i++) {
                ticketstatus_chart.putIfAbsent(
                    data['ticketstatus_chart'][i]['name'] +
                        "( " +
                        data['ticketstatus_chart'][i]['total'] +
                        " )",
                    () => double.parse(data['ticketstatus_chart'][i]['total']));

                ticketstatus_chartcolorList
                    .add(_colorFromHex(data['ticketstatus_chart'][i]['color']));
              }
            } else {
              ticketstatus_chart.putIfAbsent(
                  "no data" + "( " + "0" + " )", () => double.parse("0"));

              ticketstatus_chartcolorList.add(Colors.grey);
            }
          }

          //Ticket Department Chart Data
          if (data['ticketdepartment_chart'] == null) {
            TicketDepartment = "False";
          } else {
            if (data['ticketdepartment_chart'].length > 0) {
              for (int i = 0; i < data['ticketdepartment_chart'].length; i++) {
                ticketdepartment_chart.putIfAbsent(
                    data['ticketdepartment_chart'][i]['name'] +
                        "( " +
                        data['ticketdepartment_chart'][i]['total'] +
                        " )",
                    () => double.parse(
                        data['ticketdepartment_chart'][i]['total']));

                ticketdepartment_chartcolorList.add(
                    _colorFromHex(data['ticketdepartment_chart'][i]['color']));
              }
            } else {
              ticketdepartment_chart.putIfAbsent(
                  "no data" + "( " + "0" + " )", () => double.parse("0"));

              ticketdepartment_chartcolorList.add(Colors.grey);
            }
          }
        });
      }

      if (data['status'].toString() != false) {}
    } else {
      print(response.statusCode);
    }
  }

  void _findStaffDetail() async {
    //Get Staff Detail by login data
    staff_ID = await SharedPreferenceClass.GetSharedData("staff_id");
    staff_email = await SharedPreferenceClass.GetSharedData("email");
    staff_firstname = await SharedPreferenceClass.GetSharedData("firstname");
    staff_lastname = await SharedPreferenceClass.GetSharedData("lastname");
    profile_image = await SharedPreferenceClass.GetSharedData("profile_image");
    HeaderLogo = await SharedPreferenceClass.GetSharedData("company_logo");

    setState(() {
      new_staff_ID = staff_ID;
      CommanClass.StaffId = staff_ID;
      print('$new_staff_ID,${CommanClass.StaffId}');
      new_staff_firstname = staff_firstname;
      new_staff_lastname = staff_lastname;
      new_staff_email = staff_email;
      new_profile_Image = profile_image;
      CommanClass.HeaderLogo = HeaderLogo;

      // port.listen(
      //       (dynamic data) async {
      //     await updateUI(data);
      //   },
      // );
      // initPlatformState();
    });
  }

  BorderRadiusGeometry border() {
    if (_tabController.index == 0) {
      return BorderRadius.only(topLeft: Radius.circular(30));
    } else if (_tabController.index == 3) {
      return BorderRadius.only(topRight: Radius.circular(30));
    }
    return BorderRadius.only(topLeft: Radius.circular(0));
  }

  int selectedIndex = 0;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);

    setState(() {
      widgetsList[0].isVisible = CommanClass.showTask;
      widgetsList[1].isVisible = CommanClass.showSupport;
      widgetsList[2].isVisible = CommanClass.showProjects;
    });

    CommanClass.dashBoardfirtsTime
        ? Future.delayed(Duration(seconds: 1), showTutorial).then((value) {
            Timer.periodic(
              Duration(seconds: 3),
              (timer) {
                tutorialCoachMark.isShowing ? tutorialCoachMark.next() : null;
              },
            );
          })
        : null;
    super.initState();
    getDashboard();
    _findStaffDetail();
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
    // log(CommanClass.StaffId.toString());
    return Consumer<ColorCollection>(
      builder: (context, theme, child) => Scaffold(
        key: _scaffoldkey,
        backgroundColor: ColorCollection.grey,
        drawer: SizedBox(
          width: width * 0.6,
          height: height * 0.6,
          child: Drawer(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: ColorCollection.containerC),
                  borderRadius: BorderRadius.circular(30)
                  //  BorderRadius.only(
                  //     topLeft: Radius.circular(50),
                  //     topRight: Radius.circular(50))
                  ),
              elevation: 10,
              backgroundColor: ColorCollection.backColor.withOpacity(0.9),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        'SECOM USA',
                        style: ColorCollection.screenTitleStyle,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Divider(
                      color: ColorCollection.containerC,
                    ),
                    InkWell(
                        onTap: () async {
                          setState(() {
                            !widgetsList[0].isVisible
                                ? widgetsList[0].isVisible = true
                                : widgetsList[0].isVisible = false;
                            CommanClass.showTask = widgetsList[0].isVisible;
                          });
                          await SharedPreferenceClass.SetSharedData(
                              'showTasks', widgetsList[0].isVisible);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/newtask.png',
                                  height: 50,
                                  width: 50,
                                ),
                                Text('Tasks',
                                    style: ColorCollection.titleStyleWhite
                                        .copyWith(fontSize: 14)),
                              ],
                            ),
                            if (widgetsList[0].isVisible)
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                          ],
                        )),
                    Divider(
                      color: ColorCollection.containerC,
                    ),
                    InkWell(
                        onTap: () async {
                          // setState(() {
                          //   !widgetsList[2].isVisible
                          //       ? widgetsList[2].isVisible = true
                          //       : widgetsList[2].isVisible = false;
                          //   CommanClass.showProjects = widgetsList[2].isVisible;
                          // });
                          // await SharedPreferenceClass.SetSharedData(
                          //     'showProjects', widgetsList[2].isVisible);
                          Navigator.pushNamed(context, TasksScreen.id,
                                  arguments: CommanClass.StaffId)
                              .then((value) =>
                                  _scaffoldkey.currentState?.closeDrawer());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/newtask.png',
                                  height: 50,
                                  width: 50,
                                ),
                                Text(' My Tasks',
                                    style: ColorCollection.titleStyleWhite
                                        .copyWith(fontSize: 14)),
                              ],
                            ),
                          ],
                        )),
                    Divider(
                      color: ColorCollection.containerC,
                    ),
                    InkWell(
                        onTap: () async {
                          setState(() {
                            !widgetsList[1].isVisible
                                ? widgetsList[1].isVisible = true
                                : widgetsList[1].isVisible = false;
                            CommanClass.showSupport = widgetsList[1].isVisible;
                          });
                          await SharedPreferenceClass.SetSharedData(
                              'showSupport', widgetsList[0].isVisible);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/newticket.png',
                                  height: 50,
                                  width: 50,
                                ),
                                Text(' Support',
                                    style: ColorCollection.titleStyleWhite
                                        .copyWith(fontSize: 14)),
                              ],
                            ),
                            if (widgetsList[1].isVisible)
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                          ],
                        )),
                    Divider(
                      color: ColorCollection.containerC,
                    ),
                    InkWell(
                        onTap: () async {
                          setState(() {
                            !widgetsList[2].isVisible
                                ? widgetsList[2].isVisible = true
                                : widgetsList[2].isVisible = false;
                            CommanClass.showProjects = widgetsList[2].isVisible;
                          });
                          await SharedPreferenceClass.SetSharedData(
                              'showProjects', widgetsList[2].isVisible);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/projects.png',
                                  height: 50,
                                  width: 50,
                                ),
                                Text(' Projects',
                                    style: ColorCollection.titleStyleWhite
                                        .copyWith(fontSize: 14)),
                              ],
                            ),
                            if (widgetsList[2].isVisible)
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                          ],
                        )),
                    Divider(
                      color: ColorCollection.containerC,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    BorderSide(color: Colors.white))),
                            onPressed: () {
                              setState(() {
                                List<DashBoardWidgets> newList = [];
                                newList.addAll(widgetsList);
                                for (var element in widgetsList) {
                                  setState(() {
                                    element.isVisible = false;
                                  });
                                }
                                CommanClass.dashBoardfirtsTime = true;
                                CommanClass.taskDetailfirtsTime = true;
                                Navigator.pop(context);
                                Future.delayed(
                                        Duration(seconds: 1), showTutorial)
                                    .then((value) {
                                  Timer.periodic(
                                    Duration(seconds: 3),
                                    (timer) {
                                      tutorialCoachMark.isShowing
                                          ? tutorialCoachMark.next()
                                          : null;
                                    },
                                  );
                                });
                              });
                            },
                            child: Text('Tutorial',
                                style: ColorCollection.titleStyleWhite)),
                      ],
                    ),
                  ],
                ),
              )),
        ),
        body: SingleChildScrollView(
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
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.04, horizontal: width * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommanClass.HeaderLogo == null
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  FittedBox(
                                    child: Text('SECOMUSA',
                                        style: ColorCollection.screenTitleStyle
                                            .copyWith(
                                                fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  // FittedBox(
                                  //   child: Text('',
                                  //       style: ColorCollection.screenTitleStyle
                                  //           .copyWith(
                                  //               fontWeight: FontWeight.normal)),
                                  // ),
                                ],
                              )
                            : Image.network(CommanClass.HeaderLogo!,
                                // color: Colors.white,
                                height: 100,
                                width: 200,
                                errorBuilder: (context, error, stackTrace) =>
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width * 0.03,
                                        ),
                                        FittedBox(
                                          child: Text('SECOMUSA',
                                              style: ColorCollection
                                                  .screenTitleStyle
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ),
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                        // FittedBox(
                                        //   child: Text('',
                                        //       style: ColorCollection
                                        //           .screenTitleStyle
                                        //           .copyWith(
                                        //               fontWeight:
                                        //                   FontWeight.normal)),
                                        // ),
                                      ],
                                    )),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, SearchScreen.id);
                          },
                          icon: Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.white54,
                          ),
                        ),
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
                            child: profile_image == ''
                                ? Text(staff_firstname == ''
                                    ? ''
                                    : staff_firstname[0])
                                : Image.network(
                                    'http://' +
                                        Base_Url_For_App +
                                        '/crm/uploads/staff_profile_images/' +
                                        staff_ID +
                                        '/thumb_' +
                                        profile_image,
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
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.152),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          topContainer(
                            context,
                            width,
                            height,
                            key: keyButton1,
                            imagePath: 'assets/robo.png',
                            title: 'Customer',
                            onTap: () {
                              Navigator.pushNamed(context, CustomerScreen.id);
                            },
                          ),
                          topContainer(
                            context,
                            width,
                            height,
                            key: keyButton2,
                            imagePath: 'assets/newtask.png',
                            title: 'Task',
                            onTap: () {
                              Navigator.pushNamed(context, TasksScreen.id);
                            },
                          ),
                          topContainer(
                            context,
                            width,
                            height,
                            key: keyButton3,
                            imagePath: 'assets/newticket.png',
                            title: 'Support',
                            onTap: () {
                              Navigator.pushNamed(context, SupportScreen.id);
                            },
                          ),
                          topContainer(
                            context,
                            width,
                            height,
                            key: keyButton4,
                            imagePath: 'assets/second.png',
                            title: 'Invoice',
                            onTap: () {
                              Navigator.pushNamed(context, InvoiceScreen.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.03,
                child: demoshowing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            key: keyButton5,
                            color: ColorCollection.backColor,
                          ),
                        ],
                      )
                    : null,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: widgetsList.length,
                itemBuilder: (context, index) {
                  return widgetsList[index].isVisible
                      ? widgetsList[index].widget
                      : SizedBox();
                },
              ),
              Container(
                height: height * 0.05,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                  color: ColorCollection.tabBarDisabled,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: border(),
                    color: ColorCollection.tabBarEnabled,
                  ),
                  labelColor: Colors.white,
                  labelStyle:
                      TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: TextStyle(fontSize: 11),
                  unselectedLabelColor: Colors.grey.shade600,
                  onTap: (_) {
                    setState(() {
                      _tabController.index;
                    });
                  },
                  tabs: [
                    Text(
                      KeyValues.leadsoverview,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      KeyValues.peojectStatus,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      KeyValues.tickets,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      KeyValues.status,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.6,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    DashBoardChart(
                        dataMap: lead_chart,
                        colorList: lead_chartcolorList,
                        isdatafetched: true,
                        index: 0),
                    DashBoardChart(
                        dataMap: project_chart,
                        colorList: project_chartcolorList,
                        isdatafetched: true,
                        index: 1),
                    DashBoardChart(
                        dataMap: ticketdepartment_chart,
                        colorList: ticketdepartment_chartcolorList,
                        isdatafetched: true,
                        index: 2),
                    DashBoardChart(
                        dataMap: ticketstatus_chart,
                        colorList: ticketstatus_chartcolorList,
                        isdatafetched: true,
                        index: 3),
                  ],
                ),
              ),
              Container(
                height: height * 0.1,
                color: ColorCollection.containerC,
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector topContainer(
      BuildContext context, double width, double height,
      {required Key key,
      required String imagePath,
      required String title,
      Function()? onTap}) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.015,
        ),
        height: height * 0.1,
        width: width * 0.2,
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
            color: ColorCollection.containerC,
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: width * 0.1,
              width: width * 0.1,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              width: width * 0.01,
            ),
            Text(title, style: ColorCollection.titleStyle),
          ],
        ),
      ),
    );
  }

  void showTutorial() {
    setState(() {
      demoshowing = true;
    });
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: ColorCollection.green,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () async {
        print("finish");
        await SharedPreferenceClass.SetSharedData('dashBoardFirstTime', false);
        setState(() {
          demoshowing = false;
          CommanClass.dashBoardfirtsTime = false;
        });
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () async {
        print("skip");
        await SharedPreferenceClass.SetSharedData('dashBoardFirstTime', false);
        setState(() {
          demoshowing = false;
          CommanClass.dashBoardfirtsTime = false;
        });
      },
    )..show(context: context);
  }

  void initTargets() {
    targets.clear();

    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyButton1,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Customer",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "This will give you all the info regarding the customers",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(TargetFocus(
      identify: "Target 1",
      keyTarget: keyButton2,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Task",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
              Text(
                "This will show all the tasks",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
      shape: ShapeLightFocus.Circle,
    ));
    targets.add(TargetFocus(
      identify: "Target 2",
      keyTarget: keyButton3,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Support",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
              Text(
                "This will show all the tickets",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
      shape: ShapeLightFocus.Circle,
    ));
    targets.add(TargetFocus(
      identify: "Target 3",
      keyTarget: keyButton4,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Invoice",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
              Text(
                "This will show all the invoices",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
      shape: ShapeLightFocus.Circle,
    ));
    targets.add(
      TargetFocus(
        identify: "Target 4",
        keyTarget: keyButton5,
        contents: [
          TargetContent(
            align: ContentAlign.right,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Shortcuts",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        "Swipe from left to right to see shortcuts and perforn more actions !",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class DashBoardWidgets {
  bool isVisible;
  Widget widget;
  DashBoardWidgets({required this.isVisible, required this.widget});
}
