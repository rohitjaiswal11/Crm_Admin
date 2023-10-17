// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names, must_be_immutable, import_of_legacy_library_into_null_safe, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, prefer_if_null_operators, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Customer/CustomerDetail/addnewContact.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';


import 'package:url_launcher/url_launcher.dart';

import '../../Plugin/lbmplugin.dart';
import '../../util/ToastClass.dart';

class Contacts extends StatefulWidget {
  static const id = 'Contacts';
  String customerID = '';

  Contacts({required this.customerID});
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List Passcontact = [];
  List contact = [];
  List contactnew = [];
  List contactsearch = [];
  List datacontact = [];
  List dataHeader = [];
  int limit = 20;
  int start = 1;
  var isDataFetched = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initPlatformState(context);
    getcontactDashboard();
  }

  Future<void> initPlatformState(BuildContext context) async {
    var platformVersion = await LbmPlugin.platformVersion(
        Base_Url_For_App, Purchase_Code_envato, Licence_Key_by_Admin);
    var data = json.decode(platformVersion.body);
    print(data['message']);
    if (data['message'] == "Allow") {
      print('Allow');
    } else {
      print('Dont Allow');
    }
  }

  @override
  void dispose() {
    super.dispose();
    datacontact = [];
    dataHeader = [];
    limit = 20;
    start = 1;
    isDataFetched = false;
    contact.clear();
    contactnew.clear();
    contactsearch.clear();
  }

  //fetch the Contact data by api
  Future<void> getcontactDashboard() async {
    final paramDic = {
      "customer_id": widget.customerID.toString(),
      // "start": start.toString(),
      // "limit": limit.toString(),
      "detailtype": 'contact',
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDetail, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    contact.clear();
    contactnew.clear();
    contactsearch.clear();
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
      print(contact);
      if (mounted) {
        setState(() {
          contact = data['data'];
          // dataHeader.add(data['data']);
          contactnew.addAll(contact);
          contactsearch.addAll(contact);
          isDataFetched = true;
        });
      }
    } else {
      setState(() {
        isDataFetched = true;
        contact.clear();
        contactnew.clear();
      });
    }
  }

//Fetch data more in contact api
  getcontactDashboardMore() async {
    final paramDic = {
      "staff_id": CommanClass.StaffId,
      "limit": limit.toString(),
      "start": start.toString(),
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDetail, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    contact.clear();
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
        contact = data['data']['contact_data'];
        if (contact.isEmpty) {
          setState(() {
            isLoading = false;
          });
        } else {
          contactnew.addAll(contact);
          contactsearch.addAll(contact);

          isLoading = false;
        }
      });
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
          Navigator.pushNamed(context, AddNewContact.id, arguments: {
            'customerID': widget.customerID,
          }).then((value) => getcontactDashboard());
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
                        onChanged: onSearchTextChanged,
                        decoration: InputDecoration(
                          hintText: KeyValues.searchContacts,
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
              height: height * 0.04,
            ),
            Container(
              height: height * 0.62,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.06,
              ),
              width: width,
              decoration:
                  kContaierDeco.copyWith(color: ColorCollection.containerC),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    isDataFetched == false
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : contactnew.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: contactnew.length,
                                itemBuilder: (c, i) => contactDetailContainer(
                                    width,
                                    height,
                                    contactnew[i]['firstname'] == null
                                        ? ''
                                        : contactnew[i]['firstname']
                                                .toString()
                                                .toUpperCase() +
                                            " " +
                                            contactnew[i]['lastname']
                                                .toString()
                                                .toUpperCase(),
                                    contactnew[i]['company'] == null
                                        ? ''
                                        : contactnew[i]['company'].toString(),
                                    '',
                                    contactnew[i]['datecreated'] == null
                                        ? ''
                                        : contactnew[i]['datecreated']
                                            .toString(),
                                    contactnew[i]['last_login'] == null
                                        ? ''
                                        : contactnew[i]['last_login']
                                            .toString(),
                                    i),
                              )
                            : Container(
                                child: Center(
                                  child: Text('no data'),
                                ),
                              ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container contactDetailContainer(
      double width,
      double height,
      String name,
      String companyName,
      String lastContact,
      String added,
      String lastLogin,
      int index) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          color: Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(6)),
      margin: EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: width * 0.02,
              ),
              SizedBox(
                height: width * 0.14,
                width: width * 0.14,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: ColorCollection.green, width: 1.5)),
                      margin: EdgeInsets.all(2),
                      child: Center(
                          child: Icon(
                        Icons.person,
                        color: ColorCollection.green,
                      )),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                          radius: 6,
                          backgroundColor: contactnew[index]['active'] == '1'
                              ? Colors.green
                              : Colors.orange),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: ColorCollection.titleStyle),
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_city,
                          color: ColorCollection.green,
                          size: 14,
                        ),
                        SizedBox(
                          width: width * 0.25,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              '${KeyValues.company}- $companyName',
                              style: ColorCollection.subTitleStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    SizedBox(
                      width: width * 0.25,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text('${KeyValues.lastcontact}-$lastContact',
                            style: ColorCollection.subTitleStyle),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: ColorCollection.green,
                          size: 12,
                        ),
                        SizedBox(
                          width: width * 0.25,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              ' ${KeyValues.added}-' +
                                  (added != '' ? added.substring(0, 10) : ''),
                              style: ColorCollection.subTitleStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    SizedBox(
                      width: width * 0.25,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '${KeyValues.lastLogin}-' +
                              (lastLogin != ''
                                  ? lastLogin.substring(0, 10)
                                  : ''),
                          style: ColorCollection.subTitleStyle,
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AddNewContact.id,
                              arguments: {
                                'customerID': widget.customerID,
                                'contactID': contactnew[index]['id'].toString()
                              }).then((value) => getcontactDashboard());
                        },
                        child: Icon(
                          Icons.note_alt_outlined,
                          color: ColorCollection.backColor,
                        ))
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              try {
                print("Phone number :" + contactnew[index]['phonenumber']);
                contactnew[index]['phonenumber'] == null
                    ? ToastShowClass.coolToastShow(
                        context, "no phone number", CoolAlertType.info)
                    : await launch("tel://" + contactnew[index]['phonenumber']);
              } catch (e) {
                print('Error ----- $e');
              }
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 42),
              height: height * 0.045,
              width: width * 0.1,
              decoration: BoxDecoration(
                  color: ColorCollection.green,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topRight: Radius.circular(6))),
              child: Center(
                  child: Icon(
                Icons.call,
                color: Colors.white,
                size: 16,
              )),
            ),
          )
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    contactnew.clear();
    if (text.isEmpty) {
      setState(() {
        contactnew = List.from(contactsearch);
      });
      return;
    }

    setState(() {
      contactnew = contactsearch
          .where((item) =>
              item['firstname']
                  .toString()
                  .toLowerCase()
                  .contains(text.toString().toLowerCase()) ||
              item['lastname']
                  .toString()
                  .toLowerCase()
                  .contains(text.toString().toLowerCase()))
          .toList();
    });
  }
}
