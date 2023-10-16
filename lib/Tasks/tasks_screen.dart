// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, must_be_immutable, prefer_final_fields, unused_field, import_of_legacy_library_into_null_safe, non_constant_identifier_names, avoid_print, prefer_if_null_operators, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Tasks/add_new_tasks.dart';
import 'package:lbm_crm/Tasks/task_detail_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';

import '../LBM_Plugin/lbmplugin.dart';
import 'package:marquee_widget/marquee_widget.dart';

import '../Contract/add_new_contracts.dart';
import '../Customer/CustomerDetail/customer_detail_screen.dart';
import '../Estimates/estimates_view.dart';
import '../Expenses/add_new_expenses.dart';
import '../Invoice/invoice_detail_screen.dart';
import '../Leads/lead_detail_screen.dart';
import '../Leads/lead_screen.dart';
import '../Projects/project_details_screen.dart';
import '../Proposals/add_new_proposals.dart';
import '../Support/support_detail_screen.dart';
import '../util/ToastClass.dart';
import '../util/commonClass.dart';
import '../util/routesArguments.dart';
import '../util/storage_manger.dart';

class TasksScreen extends StatefulWidget {
  static const id = '/Tasks';
  String? staffID;
  TasksScreen(this.staffID);
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final searchController = TextEditingController();
  String relatedName = '';
  Function()? relatedOnTap;
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

  int selectedIndex = 78454656;

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
  bool loading = false;
  late String limit;
  bool tasksAssignedToMe = false;
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
    if (widget.staffID != null) {
      setState(() {
        tasksAssignedToMe = true;
      });
    }
    limit = CommanClass.limitList[2];
    getTask(staffID: widget.staffID);
  }

  Future<void> getTask(
      {String? staffID, String? status, String? search}) async {
    setState(() {
      loading = true;
    });
    final paramDic = {
      if (staffID != null) 'staff_id': '$staffID',
      if (status == null) '': '',
      if (status != null) 'status': '$status',
      if (limit != 'All') 'limit': '$limit',
      "order_by": 'desc',
      if (search != null && search.isNotEmpty) 'search': '$search',

      // "limit": '10000',
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
    if (text.isEmpty || text == '') {
      getTask();
    } else {
      getTask(search: text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    print(TaskList.length);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          Navigator.pushNamed(context, AddNewTasks.id).then((value) {
            FocusManager.instance.primaryFocus?.unfocus();
            searchController.clear();

            getTask();
          });
        },
      ),
      backgroundColor: ColorCollection.grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                    height: height * 0.22,
                    decoration: BoxDecoration(
                      color: ColorCollection.backColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.07, horizontal: width * 0.05),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: height * 0.08,
                        width: width * 0.12,
                        child: Image.asset(
                          'assets/newtask.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Text(KeyValues.tasks,
                              style: ColorCollection.screenTitleStyle)
                          .tr(),
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
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: height * 0.16, left: width * 0.03),
                  child: Container(
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
                ),
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
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
                        controller: searchController,
                        onChanged: onSearchTextChanged,
                        decoration: InputDecoration(
                          hintText: KeyValues.searchTask,
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
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Container(
              width: width,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Switch(
                              value: tasksAssignedToMe,
                              onChanged: (value) {
                                setState(() {
                                  tasksAssignedToMe=value;
                                });
                                if (value) {
                                  getTask(staffID: CommanClass.StaffId);
                                } else {
                                  getTask();
                                }
                              }),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Tasks assigned to me',
                            style: ColorCollection.titleStyle,
                          )
                        ],
                      ),
                      Container(
                    
                       width: width * 0.3,
                        decoration: kDropdownContainerDeco,
                        child: DropdownButtonFormField<String>(isExpanded: true,
                          hint: Text(KeyValues.nothingSelected),
                          style: ColorCollection.titleStyle,
                          isDense: false,
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
                          value: limit,
                          items: CommanClass.limitList.map((item) {
                            return DropdownMenuItem<String>(
                                alignment: Alignment.center,
                                child: Text('$item'),
                                value: item);
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              limit = newVal!;
                            });
                            getTask();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.54,
                    child: loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Tasknew.isNotEmpty
                            ? ListView.builder(
                                itemCount: Tasknew.length,
                                itemBuilder: (ctx, i) => taskDetailsContainer(
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
          ],
        ),
      ),
    );
  }

  Widget taskDetailsContainer(double height, double width, String title,
      String status, String startDate, String dueDate, int i) {
    var tags = '';
    if (Tasknew[i]['tags'] != null && Tasknew[i]['tags'].isNotEmpty) {
      for (var i = 0; i < Tasknew[i]['tags'].length; i++) {
        tags += Tasknew[i]['tags'][i]['name'].toString() +
            (i == Tasknew[i]['tags'].length - 1 ? '' : ', ');
      }
    }
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
              horizontal: width * 0.04, vertical: height * 0.01),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          width: width * 0.4,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                title,
                                style: ColorCollection.titleStyle2,
                              )))
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Row(
                        children: [
                          Text('Tags : ',
                              style: ColorCollection.subTitleStyle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11)),
                          SizedBox(
                            width: width * 0.4,
                            child: Marquee(
                              child: Text('$tags',
                                  style: ColorCollection.subTitleStyle.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      if (Tasknew[i]['rel_id'] != null &&
                          Tasknew[i]['rel_id'] != null)
                        InkWell(
                          onTap: () async {
                            if (relatedOnTap == null) {
                              print('value nul ----');
                            }
                            ToastShowClass.toastShow(
                                context, 'Wait Fetching Info', Colors.green);
                            await getRelatedTOData(
                                    Tasknew[i]['rel_type'].toString(),
                                    Tasknew[i]['rel_id'].toString())
                                .whenComplete(() {
                              relatedOnTap?.call();
                            });
                            setState(() {
                              relatedOnTap = null;
                            });
                          },
                          child: Row(
                            children: [
                              Text('Related to : ',
                                  style: ColorCollection.subTitleStyle.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11)),
                              SizedBox(
                                width: width * 0.4,
                                child: Marquee(
                                  child: Text(
                                    '${Tasknew[i]['rel_name']}',
                                    style: ColorCollection.subTitleStyle
                                        .copyWith(
                                            color: ColorCollection.backColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: width * 0.2,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: getMemberDisplay(
                        Tasknew[i]['assignees'] ?? [],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  //display the memeber icons
  Widget getMemberDisplay(
    List member,
  ) {
    List<Widget> list = [];
    for (var i = 0; i < member.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: SizedBox(
          width: 25,
          height: 25,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.network(
              'http://' +
                  Base_Url_For_App +
                  '/crm/uploads/staff_profile_images/' +
                  member[i]['staffid'].toString() +
                  '/thumb_' +
                  member[i]['assignees_image'].toString(),
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) {
                return Image.network(
                  "https://i1.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg",
                  fit: BoxFit.fill,
                );
              },
            ),
          ),
        ),
      ));
    }
    return Row(children: list);
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
          setState(() {
            tasksAssignedToMe=false;
          });
          await getTask();
          return;
        }

        await getTask(status: statusNumber);
        setState(() {
           tasksAssignedToMe=false;
          // Tasknew.clear();
          // Tasknew.addAll(TaskList.where((element) {
          //   return element['status'].toString().toLowerCase() ==
          //       title.toLowerCase();
          // }));
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
      print('Finished ==============');
    } catch (e) {
      print('''Error Occured d ------''');
    }
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
    final paramDic = {
      "staff_id": CommanClass.StaffId,
    };

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
      relatedName = ticketData[0]['ticketid'].toString() == 'null'
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

  ///////////////// RELATED TO DATA  END////////////////
}

class Task {
  final String title;
  final String? value;
  final Color color;
  String statusNumber;
  Task({
    required this.title,
    this.value,
    required this.color,
    this.statusNumber = '',
  });
}

List<Task> taskItems = <Task>[
  Task(title: 'ALL', value: '', color: Colors.black),
  Task(title: 'Not Started', value: '0', color: Colors.grey),
  Task(title: 'In Progress', value: '1', color: Colors.blue),
  Task(title: 'Testing', value: '2', color: Colors.purple),
  Task(title: 'Awaiting Feedback', value: '0', color: Colors.orange),
  Task(title: 'Complete', value: '0', color: ColorCollection.backColor),
];

class TaskDetail {
  final String title;
  final String status;
  final String startDate;
  final String dueDate;
  TaskDetail({
    required this.title,
    required this.status,
    required this.startDate,
    required this.dueDate,
  });
}

List<TaskDetail> taskDetailItems = [
  TaskDetail(
      title: 'Check Database',
      status: 'Not Started',
      startDate: '2020-09-28',
      dueDate: '2020-09-28'),
  TaskDetail(
      title: 'Check Database',
      status: 'Testing',
      startDate: '2020-09-28',
      dueDate: '2020-09-28'),
  TaskDetail(
      title: 'Check Database',
      status: 'In Progress',
      startDate: '2020-09-28',
      dueDate: '2020-09-28'),
  TaskDetail(
      title: 'Check Database',
      status: 'Testing',
      startDate: '2020-09-28',
      dueDate: '2020-09-28'),
  TaskDetail(
      title: 'Check Database',
      status: 'In Progress',
      startDate: '2020-09-28',
      dueDate: '2020-09-28'),
  TaskDetail(
      title: 'Check Database',
      status: 'Not Started',
      startDate: '2020-09-28',
      dueDate: '2020-09-28'),
];
