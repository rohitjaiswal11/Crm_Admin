// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, non_constant_identifier_names, avoid_print, file_names, import_of_legacy_library_into_null_safe, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Projects/add_new_project.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';


import '../../LBM_Plugin/lbmplugin.dart';
import '../../Projects/project_details_screen.dart';
import '../../util/ToastClass.dart';
import '../../util/app_key.dart';

class CustomerProjects extends StatefulWidget {
  String CustomerID = '';
  CustomerProjects({required this.CustomerID});
  @override
  _CustomerProjectsState createState() => _CustomerProjectsState();
}

class _CustomerProjectsState extends State<CustomerProjects> {
  //variable initialization
  List Passproject = [];
  List project = [];
  List projectnew = [];
  List projectsearch = [];
  List dataproject = [];
  List dataHeader = [];
  int limit = 20;
  int start = 1;
  var isDataFetched = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print(widget.CustomerID);
    getprojectDashboard();
  }

  //page finish
  @override
  void dispose() {
    super.dispose();
    dataproject = [];
    dataHeader = [];
    limit = 20;
    start = 1;
    isDataFetched = false;
    project.clear();
    projectnew.clear();
    projectsearch.clear();
  }

  //customer project data show by api
  Future<void> getprojectDashboard() async {
    final paramDic = {
      "customer_id": widget.CustomerID.toString(),
      // "start": start.toString(),
      // "limit": limit.toString(),
      "detailtype": 'project',
      "typeof": 'customer',
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDetail, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    log(data.toString());
    project.clear();
    projectnew.clear();
    projectsearch.clear();
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
      print(project);
      setState(() {
        project = data['data'];
        dataHeader = data['projectCount'];
        projectnew.addAll(project);
        projectsearch.addAll(project);
        isDataFetched = true;
      });
    } else {
      if (mounted) {
        setState(() {
          isDataFetched = true;
          project.clear();
          projectnew.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
    Navigator.pushNamed(context, AddNewProject.id);
        },
      ),
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
                        // onChanged: onSearchTextChanged,
                        decoration: InputDecoration(
                          hintText: 'Search Projects',
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
              height: height * 0.02,
            ),
            !isDataFetched
                ? Expanded(
                    child: Center(
                    child: CircularProgressIndicator(),
                  ))
                : Stack(
                    children: [
                      Container(
                        width: width,
                        margin: EdgeInsets.only(top: height * 0.05),
                        height: height * 0.59,
                        padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.1),
                        decoration: kContaierDeco.copyWith(
                            color: ColorCollection.containerC),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * 0.01,
                              ),
                              projectnew.isNotEmpty
                                  ? ListView.builder(
                                      padding: EdgeInsets.only(bottom: height*0.05),
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: projectnew.length,
                                      itemBuilder: (ctx, i) =>
                                          projectDetailsContainer(height, width, i))
                                  : Center(
                                      child: Text('No Data'),
                                    )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.03,
                        ),
                        height: height * 0.13,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: dataHeader.length,
                          itemBuilder: (context, i) => projectsContainer(
                              width: width,
                              height: height,
                              i: i,
                              color: _colorFromHex(dataHeader[i]['statuscolor'])),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget projectDetailsContainer(double height, double width, int index) {
    return GestureDetector(
      onTap: () {
        Passproject.clear();
        Passproject.add(projectnew[index]);
        print(Passproject);
        Navigator.pushNamed(context, ProjectDetailScreen.id,
            arguments: Passproject);
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: height * 0.015),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: getMemberDisplay(
                      projectnew[index]['datamembers'],
                      _colorFromHex(projectnew[index]['projectstatusname']
                              ['color']
                          .toString())),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    SizedBox(
                      width: width * 0.5,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          projectnew[index]['id'].toString() +
                              "  " +
                              projectnew[index]['name'] +
                              "",
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Row(
                      children: [
                        Text(
                          '${KeyValues.startDate} -     ' +
                              projectnew[index]['start_date']
                                  .toString()
                                  .split(" ")[0],
                          style: ColorCollection.subTitleStyle,
                        ),
                        SizedBox(
                          width: width * 0.06,
                        ),
                        Text(
                          '${KeyValues.deadlineDate} -  ' +
                              projectnew[index]['deadline']
                                  .toString()
                                  .split(" ")[0],
                          style: ColorCollection.subTitleStyle,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${KeyValues.CreateDate} -  ' +
                              projectnew[index]['project_created']
                                  .toString()
                                  .split(" ")[0],
                          style: ColorCollection.subTitleStyle,
                        ),
                        SizedBox(
                          width: width * 0.06,
                        ),
                        SizedBox(
                          width: width * 0.2,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              '${KeyValues.finishedLine} -   ' +
                                  projectnew[index]['date_finished']
                                      .toString()
                                      .split(" ")[0],
                              style: ColorCollection.subTitleStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    )
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: width * 0.25,
              height: 30,
              decoration: BoxDecoration(
                color: _colorFromHex(
                    projectnew[index]['projectstatusname']['color'].toString()),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    topRight: Radius.circular(6)),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    projectnew[index]['projectstatusname']['name'].toString(),
                    style: ColorCollection.titleStyleWhite2,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Widget projectsContainer(
      {required double width,
      required double height,
      Color? color,
      required int i}) {
    return Container(
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
            Text(dataHeader[i]['status_name'] ?? '-',
                textAlign: TextAlign.center,
                softWrap: true,
                style: ColorCollection.titleStyle2.copyWith(color: color)),
            SizedBox(
              height: height * 0.01,
            ),
            Text('${dataHeader[i]['status_order'] ?? '0'}',
                style: ColorCollection.titleStyle2)
          ],
        ));
  }

//display the memeber icons
  Widget getMemberDisplay(List member, Color color) {
    List<Widget> list = [];
    for (var i = 0; i < member.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: Tooltip(
          message: member[i]['member_name'],
          child: member[i]['profile_image'] == null
              ? Icon(
                  Icons.account_circle,
                  color: ColorCollection.backColor,
                )
              : Container(
                  width: 40,
                  height: 40,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    'http://' +
                        Base_Url_For_App +
                        '/crm/uploads/staff_profile_images/' +
                        member[i]['staff_id'] +
                        '/thumb_' +
                        member[i]['profile_image'],
                    fit: BoxFit.fill, errorBuilder: (_, __, ___) {
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
      ));
    }
    return Row(children: list);
  }

  //search the project
  onSearchTextChanged(String text) async {
    projectnew.clear();
    if (text.isEmpty) {
      setState(() {
        projectnew = List.from(projectsearch);
      });
      return;
    }

    setState(() {
      projectnew = projectsearch
          .where((item) =>
              item['id'].toLowerCase().contains(text.toLowerCase()) ||
              item['name']
                  .toString()
                  .toLowerCase()
                  .contains(text.toString().toLowerCase()))
          .toList();
    });
  }
}
