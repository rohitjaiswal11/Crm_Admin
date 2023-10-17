// ignore_for_file: file_names, prefer_const_constructors, avoid_print, import_of_legacy_library_into_null_safe, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Projects/projects_screen.dart';

import '../Plugin/lbmplugin.dart';

import '../Projects/project_details_screen.dart';
import '../util/APIClasses.dart';
import '../util/LicenceKey.dart';
import '../util/ToastClass.dart';
import '../util/app_key.dart';
import '../util/colors.dart';

class DashBoardProjects extends StatefulWidget {
  const DashBoardProjects({Key? key}) : super(key: key);

  @override
  State<DashBoardProjects> createState() => _DashBoardProjectsState();
}

class _DashBoardProjectsState extends State<DashBoardProjects> {
  //initalization the variable
  List Passproject = [];
  List project = [];
  List projectnew = [];
  List projectsearch = [];
  List dataproject = [];
  List dataHeader = [];
  int limit = 20;
  int start = 1;
  var isDataFetched = false;

  @override
  void initState() {
    super.initState();
    getprojectDashboard();
  }

  //page finish then dispose all the field
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

  //fetch the project data on server by api
  Future<void> getprojectDashboard() async {
    final paramDic = {
      // "start": start.toString(),
      if (limit != 'All') 'limit': '$limit',
      "order_by": 'desc',
      "detailtype": 'project',
      "typeof": 'project',
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDetail, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
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
      if (mounted) {
        setState(() {
          project = data['data'];
          dataHeader = data['projectCount'];
          projectnew.addAll(project);
          projectsearch.addAll(project);
          isDataFetched = true;
        });
      }
    } else {
      setState(() {
        isDataFetched = true;
        project.clear();
        projectnew.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.37,
      margin: EdgeInsets.only(bottom: height * 0.02),
      decoration: BoxDecoration(
          color: isDataFetched
              ? ColorCollection.navBarColor
              : ColorCollection.containerC,
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
                Image.asset(
                  'assets/projects.png',
                  height: 30,
                  width: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ProjectsScreen.id);
                  },
                  child: Text(
                    ' PROJECTS',
                    style: ColorCollection.titleStyleWhite.copyWith(
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
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
                    itemCount: dataHeader.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => projectsContainer(
                        width: width,
                        height: height,
                        i: i,
                        color: projectItems[i].color),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                isDataFetched == false
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.005),
                        height: height * 0.25,
                        child: projectnew.isNotEmpty
                            ? ListView.builder(
                                itemCount: projectnew.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (ctx, i) =>
                                    projectDetailsContainer(height, width, i))
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

  Widget projectsContainer(
      {required double width,
      required double height,
      required int i,
      Color? color}) {
    return InkWell(
      onTap: () {
        setState(() {
          projectnew.clear();
          projectnew.addAll(project.where((element) {
            return element['projectstatusname']['name']
                    .toString()
                    .toLowerCase() ==
                dataHeader[i]['status_name'].toString().toLowerCase();
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
              Text(dataHeader[i]['status_name'],
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: ColorCollection.titleStyle2.copyWith(
                      color: color,
                      fontWeight: FontWeight.normal,
                      fontSize: 11)),
              Text(' (${dataHeader[i]['total'] ?? '0'})',
                  style: ColorCollection.titleStyle2.copyWith(fontSize: 11))
            ],
          )),
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
            margin: EdgeInsets.only(bottom: height * 0.005),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: width*0.15,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: getMemberDisplay(
                        projectnew[index]['datamembers'],
                        _colorFromHex(projectnew[index]['projectstatusname']
                                ['color']
                            .toString())),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.005,
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
                            style: ColorCollection.titleStyle),
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
                    SizedBox(
                      height: height * 0.005,
                    )
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: width * 0.2,
              height: height * 0.025,
              decoration: BoxDecoration(
                color: _colorFromHex(
                    projectnew[index]['projectstatusname']['color'].toString()),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    topRight: Radius.circular(6)),
              ),
              child: Padding(
                padding: EdgeInsets.all(2),
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
                  width: 22,
                  height: 22,
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
      ));
    }
    return Row(children: list);
  }
}
