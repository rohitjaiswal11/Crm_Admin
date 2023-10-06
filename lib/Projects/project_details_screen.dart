// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, must_be_immutable, non_constant_identifier_names, prefer_if_null_operators


import 'package:flutter/material.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Projects/DiscussionView.dart';
import 'package:lbm_crm/Projects/files_widget.dart';
import 'package:lbm_crm/Projects/project_ticket.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/routesArguments.dart';

class ProjectDetailScreen extends StatefulWidget {
  static const id = '/ProjectDetailScreen';
  List ProjectData;
  ProjectDetailScreen({required this.ProjectData});
  @override
  ProjectDetailScreenState createState() => ProjectDetailScreenState();
}

class ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  var _tagsExpand = false;
  var _descExpand = false;
  var _memExpand = false;

  int? index;
  Widget? showFab(int? index) {
    if (index == 2) {
      return FloatingActionButton(
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {},
      );
    }
    return null;
  }

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        index = _tabController.index;
      });
      // Do whatever you want based on the tab index
    });
    super.initState();
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
    return Scaffold(
      backgroundColor: ColorCollection.grey,
      floatingActionButton: showFab(index),
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
                      SizedBox(
                        width: width * 0.7,
                        child: Text(
                          '#' +
                              widget.ProjectData[0]['id'].toString() +
                              '-' +
                              widget.ProjectData[0]['name'],
                          softWrap: true,
                          style: ColorCollection.screenTitleStyle,
                        ),
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
                      isScrollable: true,
                      indicator: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                        color: ColorCollection.backColor,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      labelStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                          KeyValues.projectOverView,
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          KeyValues.Files,
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          KeyValues.discussion,
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          KeyValues.tickets,
                          style: TextStyle(fontSize: 14),
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
            SizedBox(
              height: height * 0.7,
              width: width,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // 1st Tab (Project OverView)
                  projectOverView(width, height, widget.ProjectData),
                  // 2nd Tab (Files) (files_widget.dart)
                  ProjectFiles(
                    routefile: RouteFile(
                        ID: widget.ProjectData[0]['id'], Type: 'project'),
                  ),
                  // 3rd Tab (Discussion)
                  Container(
                      decoration: kContaierDeco.copyWith(
                          color: ColorCollection.containerC),
                      child: DiscussionView(
                          projectId: widget.ProjectData[0]['id'])),
                  // 4th Tab (Tickets)
                  ProjectTickets(
                    ticketFileRoute: TicketFileRoute(
                        CustomerID:
                            widget.ProjectData[0]['clientid'].toString(),
                        Type: 'project',
                        ProjectID: widget.ProjectData[0]['id'].toString()),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1st Tab (Project OverView)
  Widget projectOverView(double width, double height, List projectDetail) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.08, vertical: height * 0.04),
      decoration: kContaierDeco.copyWith(color: ColorCollection.containerC),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${KeyValues.project} #',
                    style: ColorCollection.subTitleStyle3),
                Text(
                  widget.ProjectData[0]['id'],
                  style: ColorCollection.subTitleStyle3,
                ),
              ],
            ),
            SizedBox(height: height * 0.025),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  KeyValues.billingType,
                  style: ColorCollection.titleStyle2
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                Text(
                  projectDetail[0]['billing_type'],
                  style: ColorCollection.titleStyleGreen2,
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  KeyValues.totalRate,
                  style: ColorCollection.titleStyle2
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                Text(
                  projectDetail[0]['project_cost'] == null
                      ? "\$ "
                      : "\$ " + projectDetail[0]['project_cost'],
                  style: ColorCollection.titleStyleGreen2,
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  KeyValues.status,
                  style: ColorCollection.titleStyle2
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                Text(
                  projectDetail[0]['projectstatusname']['name'] ??'',
                  style: ColorCollection.titleStyleGreen2,
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  KeyValues.startDate,
                  style: ColorCollection.titleStyle2
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                Text(
                  projectDetail[0]['start_date'],
                  style: ColorCollection.titleStyleGreen2,
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  KeyValues.deadline,
                  style: ColorCollection.titleStyle2
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                Text(
                  projectDetail[0]['deadline'] == null
                      ? ''
                      : projectDetail[0]['deadline'],
                  style: ColorCollection.titleStyleGreen2,
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  KeyValues.domainName,
                  style: ColorCollection.titleStyle2
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                Text(
                  'Not Found',
                  style: ColorCollection.titleStyleGreen2,
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  projectDetail[0]['extra_field'] == null ||
                          projectDetail[0]['extra_field'].length == 0
                      ? ''
                      : projectDetail[0]['extra_field'][0]['name'],
                  style: ColorCollection.titleStyle2
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                Text(
                  projectDetail[0]['extra_field'] == null ||
                          projectDetail[0]['extra_field'].length == 0
                      ? ''
                      : projectDetail[0]['extra_field'][0]['value'],
                  style: ColorCollection.titleStyleGreen2,
                ),
              ],
            ),
            SizedBox(height: height * 0.025),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02, vertical: height * 0.005),
              height: height * 0.05,
              width: width,
              color: ColorCollection.lightgreen,
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: ColorCollection.green,
                      child: Icon(
                        Icons.flag,
                        color: Colors.white,
                        size: 15,
                      )),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  Text(KeyValues.tags, style: ColorCollection.titleStyleGreen2),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _tagsExpand = !_tagsExpand;
                        });
                      },
                      child: Icon(
                        _tagsExpand
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: ColorCollection.backColor,
                      )),
                ],
              ),
            ),
            if (_tagsExpand)
              Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.008),
                  height: height * 0.07,
                  width: width,
                  color: ColorCollection.lightgreen,
                  child: getprojectTags(projectDetail[0]['tags_field'])),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02, vertical: height * 0.005),
              height: height * 0.05,
              width: width,
              color: ColorCollection.lightgreen,
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: ColorCollection.green,
                      child: Icon(
                        Icons.text_snippet_outlined,
                        color: Colors.white,
                        size: 15,
                      )),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  Text(KeyValues.description,
                      style: ColorCollection.titleStyleGreen2),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _descExpand = !_descExpand;
                        });
                      },
                      child: Icon(
                        _descExpand
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: ColorCollection.backColor,
                      )),
                ],
              ),
            ),
            if (_descExpand)
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.008),
                height: height * 0.15,
                width: width,
                color: ColorCollection.lightgreen,
                child: ListView(padding: EdgeInsets.zero, children: [
                  Text(
                    projectDetail[0]['description'],
                  )
                ]),
              ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02, vertical: height * 0.005),
              height: height * 0.05,
              width: width,
              color: ColorCollection.lightgreen,
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: ColorCollection.green,
                      child: Icon(
                        Icons.groups,
                        color: Colors.white,
                        size: 15,
                      )),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  Text(KeyValues.members,
                      style: ColorCollection.titleStyleGreen2),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _memExpand = !_memExpand;
                        });
                      },
                      child: Icon(
                        _memExpand
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: ColorCollection.backColor,
                      )),
                ],
              ),
            ),
            if (_memExpand)
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.008),
                height: height * 0.1,
                width: width,
                color: ColorCollection.lightgreen,
                child: ListView(padding: EdgeInsets.zero, children: [
                  getMemberDisplay(
                    projectDetail[0]['datamembers'],
                  )
                ]),
              ),
          ],
        ),
      ),
    );
  }

  //Project tags Show
  Widget getprojectTags(List member) {
    List<Widget> list = [];
    for (var i = 0; i < member.length; i++) {
      list.add(Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          child: Chip(
            label: Text(
              member[i]['name'],
              style: ColorCollection.titleStyle,
            ),
          )));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: list),
    );
  }

  //Get Member Display in Project
  Widget getMemberDisplay(List member) {
    List<Widget> list = [];
    for (var i = 0; i < member.length; i++) {
      list.add(Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          child: Chip(
            backgroundColor: ColorCollection.backColor,
            avatar: CircleAvatar(
              backgroundColor: Colors.grey.shade50,
              child: member[i]['profile_image'] == null
                  ? Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
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
            ),
            label: Text(
              member[i]['member_name'],
              style: ColorCollection.titleStyleWhite,
            ),
          )));
    }
    return Wrap(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: list);
  }
}
