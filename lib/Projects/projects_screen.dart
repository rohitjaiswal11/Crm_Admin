// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, must_be_immutable, prefer_final_fields, unused_field, import_of_legacy_library_into_null_safe, non_constant_identifier_names, avoid_print, prefer_if_null_operators

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Projects/add_new_project.dart';
import 'package:lbm_crm/util/commonClass.dart';

import '../LBM_Plugin/lbmplugin.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/Projects/project_details_screen.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/constants.dart';

import '../util/ToastClass.dart';

class ProjectsScreen extends StatefulWidget {
  static const id = '/Projects';

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  //initalization the variable
  List Passproject = [];
  List project = [];
  List projectnew = [];
  List projectsearch = [];
  List dataproject = [];
  List dataHeader = [];
  late String limit;
  int start = 1;
  var isDataFetched = false;

  @override
  void initState() {
    setState(() {
      limit = CommanClass.limitList[2];
    });
    super.initState();
    getprojectDashboard();
  }

  //page finish then dispose all the field
  @override
  void dispose() {
    super.dispose();
    dataproject = [];
    dataHeader = [];

    start = 1;
    isDataFetched = false;
    project.clear();
    projectnew.clear();
    projectsearch.clear();
  }

  //fetch the project data on server by api
  Future<void> getprojectDashboard({String? search}) async {
    setState(() {
      isDataFetched = false;
    });
    final paramDic = {
      // "start": start.toString(),
      // "limit": limit.toString(),
      "detailtype": 'project',
      "typeof": 'project',
      'order_by': 'desc',
      if (limit != 'All') 'limit': '$limit',
      if (search != null && search.isNotEmpty) 'search': '$search',
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
      print(data);
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
    return Scaffold(
      backgroundColor: ColorCollection.grey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () async {
          Navigator.pushNamed(
            context,
            AddNewProject.id,
          ).then((val) => getprojectDashboard());
        },
      ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: height * 0.07,
                        width: width * 0.15,
                        child: Image.asset(
                          'assets/projects.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Text(KeyValues.projects,
                          style: ColorCollection.screenTitleStyle),
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
                      itemCount: dataHeader.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) => projectsContainer(
                          width: width,
                          height: height,
                          i: i,
                          color: i >= projectItems.length
                              ? ColorCollection.green
                              : projectItems[i].color),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    height: height * 0.06,
                    width: width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: height * 0.06,
                          width: width * 0.35,
                          child: TextFormField(
                            onChanged: onSearchTextChanged,
                            decoration: InputDecoration(
                              hintText: 'Search Projects',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.01),
                              hintStyle: ColorCollection.subTitleStyle2,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.06,
                          width: width * 0.1,
                          decoration: BoxDecoration(
                              color: ColorCollection.darkGreen,
                              borderRadius: BorderRadius.circular(10)),
                          child: IconButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
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
                  Container(
                    width: width * 0.34,
                    decoration: kDropdownContainerDeco,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      hint: Text(KeyValues.nothingSelected),
                      style: ColorCollection.titleStyle,
                      isDense: false,
                      elevation: 8,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: width * 0.04),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade100, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade100, width: 2),
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
                        getprojectDashboard();
                      },
                    ),
                  ),
                ],
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
                  SizedBox(
                      width: width,
                      height: height * 0.6,
                      child: isDataFetched
                          ? projectnew.isNotEmpty
                              ? ListView.builder(
                                  itemCount: projectnew.length,
                                  itemBuilder: (ctx, i) =>
                                      projectDetailsContainer(height, width, i))
                              : Center(
                                  child: Text('No Data'),
                                )
                          : Center(
                              child: CircularProgressIndicator(),
                            ))
                ],
              ),
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
                  width: width * 0.1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: getMemberDisplay(
                      projectnew[index]['datamembers'],
                      _colorFromHex(
                        projectnew[index]['projectstatusname']['color']
                            .toString(),
                      ),
                    ),
                  ),
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
              // alignment: Alignment.center,
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
              Container(
                height: height * 0.05,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Text(
                      dataHeader[i]['status_name'] == null
                          ? '0'
                          : dataHeader[i]['status_name'],
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: ColorCollection.titleStyle2
                          .copyWith(color: color, fontSize: 14)),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Text(
                  dataHeader[i]['total'] == null ? '0' : dataHeader[i]['total'],
                  style: ColorCollection.titleStyle2)
            ],
          )),
    );
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
                  size: 40,
                  color: ColorCollection.backColor,
                )
              : Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
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
                          size: 40,
                        ));
                      },
                    ),
                  ),
                ),
        ),
      ));
    }
    return Row(children: list);
  }

  //search the project
  onSearchTextChanged(String text) async {
    if (text.isEmpty || text == '') {
      getprojectDashboard();
    } else {
      getprojectDashboard(search: text);
    }
  }
}

class Projects {
  final Color color;
  Projects({
    required this.color,
  });
}

List<Projects> projectItems = <Projects>[
  Projects(color: Colors.grey),
  Projects(color: ColorCollection.green),
  Projects(color: Colors.orange),
  Projects(color: Colors.blue),
  Projects(color: Colors.lightGreen),
];




/* Container(
      height: height * 0.09,
      width: width,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          color: ColorCollection.backColor.withOpacity(0.02),
          borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: CircleAvatar(
                    backgroundColor: ColorCollection.green,
                    child: Icon(Icons.person_outline, color: Colors.white),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('9 Testing Architecture'),
                    SizedBox(height: height * 0.01),
                    SizedBox(
                      child: Row(
                        children: [
                          Text(
                            'Start Date-',
                            style: detailStyle,
                          ),
                          SizedBox(
                            width: width * 0.03,
                          ),
                          Text(
                            ' 2021-09-28',
                            style: detailStyle,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Created Date-',
                          style: detailStyle,
                        ),
                        Text(
                          ' 2021-09-28',
                          style: detailStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                      children: [
                        Text(
                          'Deadline-',
                          style: detailStyle,
                        ),
                        Text(
                          '2021-09-28',
                          style: detailStyle,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Finishline-',
                          style: detailStyle,
                        ),
                        Text(
                          'Null',
                          style: detailStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ), */