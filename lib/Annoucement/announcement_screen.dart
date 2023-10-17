// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, avoid_print, import_of_legacy_library_into_null_safe, prefer_if_null_operators

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Annoucement/add_new_announcement.dart';
import 'package:lbm_crm/Annoucement/announcement_detail.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';

import '../Plugin/lbmplugin.dart';

class AnnouncementScreen extends StatefulWidget {
  static const id = '/Announcement';

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  List Announcements = [];
  List Announcementsnew = [];
  List AnnouncementsSearch = [];
  List SendData = [];
  late String limit;
  bool isfetched = false;

  Future<void> getAnouncements({String? search}) async {
    setState(() {
      isfetched = false;
    });
    final paramDic = {
      'order_by': 'desc',
      if (limit != 'All') 'limit': '$limit',
      if (search != null && search.isNotEmpty) 'search': '$search',
    };
    print(paramDic);
    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.getAnnouncements, paramDic, "Get", Api_Key_by_Admin);

      Announcements.clear();
      Announcementsnew.clear();
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
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
          isfetched = true;
        });
        Announcements = data['data'];

        setState(() {
          Announcementsnew.addAll(Announcements);
          AnnouncementsSearch.addAll(Announcementsnew);
        });
      } else {
        log(' Else Case  ==> ${response.statusCode}');
        setState(() {
          isfetched = true;
        });
      }
    } catch (e) {
      log('Error $e ');
      setState(() {
        isfetched = true;
      });
    }
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty || text == '') {
      getAnouncements();
    } else {
      getAnouncements(search: text);
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    final paramDic = {
      "id": id,
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.delAnnouncements, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      getAnouncements();
     ToastShowClass.coolToastShow(context, data['message'], CoolAlertType.success);
    } else {
     ToastShowClass.coolToastShow(context, data['message'], CoolAlertType.error);

    }
  }

  @override
  void initState() {
    setState(() {
      limit = CommanClass.limitList[2];
    });
    getAnouncements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    log(Announcements.toString());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          Navigator.pushNamed(context, AddNewAnnouncementScreen.id)
              .then((value) => getAnouncements());
        },
      ),
      backgroundColor: ColorCollection.grey,
      body: SingleChildScrollView(
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
                      height: height * 0.08,
                      width: width * 0.17,
                      child: Image.asset(
                        'assets/announcements.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Text(
                      KeyValues.announcement,
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
              height: height * 0.02,
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
                              hintText: 'Search Announcement',
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
                        getAnouncements();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Stack(
              children: [
                Container(
                    margin: EdgeInsets.only(top: height * 0.02),
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.02,
                      horizontal: width * 0.06,
                    ),
                    width: width,
                    decoration: kContaierDeco.copyWith(
                        color: ColorCollection.containerC),
                    child: SizedBox(
                      height: height * 0.67,
                      child: isfetched == true
                          ? Announcementsnew.isNotEmpty
                              ? ListView.builder(
                                  padding: EdgeInsets.only(bottom: 20),
                                  itemCount: Announcementsnew.length,
                                  itemBuilder: (c, i) {
                                    return Announcementsnew.isNotEmpty
                                        ? Dismissible(
                                            key: UniqueKey(),
                                            onDismissed: (direction) {
                                              if (direction ==
                                                  DismissDirection.startToEnd) {
                                                setState(() {
                                                  SendData.clear();
                                                  SendData.add(
                                                      Announcementsnew[i]);
                                                  Navigator.pushNamed(
                                                          context,
                                                          AddNewAnnouncementScreen
                                                              .id,
                                                          arguments: SendData)
                                                      .then((value) =>
                                                          initState());
                                                });
                                              } else if (direction ==
                                                  DismissDirection.endToStart) {
                                                setState(() {
                                                  deleteAnnouncement(
                                                          Announcementsnew[i][
                                                                  'announcementid']
                                                              .toString())
                                                      .then((value) =>
                                                          getAnouncements());
                                                });
                                              }
                                            },
                                            background: slideRightBackground(),
                                            secondaryBackground:
                                                slideLeftBackground(),
                                            child: announcementContainer(
                                                width,
                                                height,
                                                Announcementsnew[i]['name'] ==
                                                        null
                                                    ? ""
                                                    : Announcementsnew[i]
                                                        ['name'],
                                                Announcementsnew[i]
                                                            ["dateadded"] ==
                                                        null
                                                    ? ""
                                                    : Announcementsnew[i]
                                                            ["dateadded"]
                                                        .toString()
                                                        .split(' ')[0],
                                                i),
                                          )
                                        : Center(
                                            child: Text('No Data'),
                                          );
                                  },
                                )
                              : Center(
                                  child: Text('No Data'),
                                )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.06),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: height * 0.01),
                  decoration: BoxDecoration(
                      color: ColorCollection.green,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(KeyValues.name,
                          style: ColorCollection.titleStyleWhite),
                      Text(KeyValues.date,
                          style: ColorCollection.titleStyleWhite),
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

  Widget announcementContainer(
      double width, double height, String title, String date, int i) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AnnouncementDetail(data: Announcementsnew[i]),
            ));
      },
      child: Container(
          margin: EdgeInsets.only(bottom: height * 0.02),
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.015),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(6)),
          child: Row(
            children: [
              Icon(
                Icons.person,
                size: 35,
                color: ColorCollection.green,
              ),
              SizedBox(
                width: width * 0.02,
              ),
              SizedBox(
                width: width * 0.5,
                child: Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: ColorCollection.titleStyle2),
              ),
              Spacer(),
              Text(
                date,
                style: ColorCollection.titleStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: ColorCollection.backColor,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: ColorCollection.titleStyleWhite2,
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: ColorCollection.titleStyleWhite2,
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}

class Announcements {
  final String title;
  final String date;
  Announcements({required this.title, required this.date});
}
