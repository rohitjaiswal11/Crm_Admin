// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, must_be_immutable, prefer_if_null_operators, deprecated_member_use

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lbm_crm/Customer/CustomerDetail/addressWidget.dart';
import 'package:lbm_crm/Customer/CustomerDetail/contacts.dart';
import 'package:lbm_crm/Customer/CustomerDetail/customerNotes.dart';
import 'package:lbm_crm/Customer/CustomerDetail/customerProjects.dart';
import 'package:lbm_crm/Customer/CustomerDetail/customerfield.dart' as field;
import 'package:lbm_crm/Customer/CustomerDetail/estimatesWidget.dart';
import 'package:lbm_crm/Customer/CustomerDetail/performaWidget.dart';
import 'package:lbm_crm/Customer/CustomerDetail/reminderWidget.dart';
import 'package:lbm_crm/Customer/add_new_customers.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Projects/files_widget.dart';
import 'package:lbm_crm/Projects/project_ticket.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/routesArguments.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'customer_tasks.dart';

class CustomerDetailScreen extends StatefulWidget {
  List CustomerData = [];
  static const id = '/CustomerDetailScreen';
  CustomerDetailScreen({required this.CustomerData});
  @override
  CustomerDetailScreenState createState() => CustomerDetailScreenState();
}

class CustomerDetailScreenState extends State<CustomerDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? tabindex;
  String groups = '';
  PlatformFile? file;
  final deco = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: Colors.grey.shade300, width: 1),
    color: Color(0xFFF8F8F8),
  );

  @override
  void initState() {
    _tabController = TabController(length: 12, vsync: this);
    _tabController.addListener(() {
      setState(() {
        tabindex = _tabController.index;
      });
      // Do whatever you want based on the tab index
    });
    if (widget.CustomerData[0]['groups'] != null &&
        widget.CustomerData[0]['groups'].isNotEmpty) {
      for (var i = 0; i < widget.CustomerData[0]['groups'].length; i++) {
        groups += widget.CustomerData[0]['groups'][i]['name'].toString() +
            (i == widget.CustomerData[0]['groups'].length - 1 ? '' : ', ');
      }
    }
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
    // print('--------- $groups ---' +
    //     widget.CustomerData[0]['groups'][0]['name'].toString());
    return Scaffold(
      backgroundColor: ColorCollection.grey,
      body: SingleChildScrollView(
        child: SelectionArea(
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
                                image: AssetImage('assets/robo.png'),
                                fit: BoxFit.fill),
                          ),
                          height: height * 0.12,
                          width: width * 0.17,
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FittedBox(
                              child: Text(
                                KeyValues.customers,
                                softWrap: true,
                                style: ColorCollection.screenTitleStyle,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            SizedBox(
                              width: width * 0.17,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  widget.CustomerData[0]['company'] ?? '',
                                  softWrap: true,
                                  style: ColorCollection.screenTitleStyle
                                      .copyWith(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, NewCustomer.id,
                                  arguments: widget.CustomerData);
                            },
                            child: Text(
                              'Edit',
                              style: ColorCollection.titleStyleWhite.copyWith(
                                  fontWeight: FontWeight.w800, fontSize: 14),
                            )),
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
                          border: Border.all(color: Colors.white),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 5)
                          ]),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorCollection.backColor,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        labelStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 13,
                        ),
                        unselectedLabelColor: Colors.grey.shade600,
                        tabs: [
                          Text(
                            KeyValues.details,
                          ),
                          Text(
                            KeyValues.tasks,
                          ),
                          Text(
                            KeyValues.tickets,
                          ),
                          Text(
                            KeyValues.contacts,
                          ),
                          Text(
                            KeyValues.address,
                          ),
                          Text(
                            KeyValues.fields,
                          ),
                          Text(
                            KeyValues.notes,
                          ),
                          Text(
                            KeyValues.invoices,
                          ),
                          Text(
                            KeyValues.estimates,
                          ),
                          Text(
                            KeyValues.projects,
                          ),
                          Text(
                            KeyValues.Files,
                          ),
                          Text(
                            KeyValues.reminders,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              SizedBox(
                height: height * 0.72,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Details Tab
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.04),
                      child: Stack(
                        children: [
                          Container(
                            height: height * 0.7,
                            margin: EdgeInsets.only(top: height * 0.025),
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.06,
                            ),
                            width: width,
                            decoration: kContaierDeco.copyWith(
                                color: ColorCollection.containerC),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.03,
                                  ),
                                  customerDetailContainer(
                                      width,
                                      height,
                                      'Company',
                                      widget.CustomerData[0]['company'] == null
                                          ? ''
                                          : widget.CustomerData[0]['company'],
                                      'GSTIN NUMBER',
                                      widget.CustomerData[0]['vat'] == null
                                          ? ''
                                          : widget.CustomerData[0]['vat'],
                                      Icons.location_city,
                                      Icons.contact_page),
                                  customerDetailContainer(
                                      width,
                                      height,
                                      'Phone Number',
                                      widget.CustomerData[0]['phonenumber'] ==
                                              null
                                          ? ''
                                          : widget.CustomerData[0]
                                              ['phonenumber'],
                                      'Website',
                                      widget.CustomerData[0]['website'] == null
                                          ? ''
                                          : widget.CustomerData[0]['website'],
                                      Icons.phone,
                                      Icons.sports_basketball_outlined),
                                  customerDetailContainer(
                                      width,
                                      height,
                                      'Groups',
                                      '$groups',
                                      'Currency',
                                      widget.CustomerData[0]
                                                  ['default_currency_name'] ==
                                              null
                                          ? ''
                                          : widget.CustomerData[0]
                                              ['default_currency_name'],
                                      Icons.group,
                                      Icons.monetization_on),
                                  customerDetailContainer(
                                      width,
                                      height,
                                      'Address',
                                      widget.CustomerData[0]['address'] == null
                                          ? ''
                                          : widget.CustomerData[0]['address']
                                              .toString(),
                                      'City',
                                      widget.CustomerData[0]['city'] == null
                                          ? ''
                                          : widget.CustomerData[0]['city'],
                                      Icons.pin_drop,
                                      Icons.saved_search_outlined),
                                  customerDetailContainer(
                                      width,
                                      height,
                                      'State',
                                      widget.CustomerData[0]['state'] == null
                                          ? ''
                                          : widget.CustomerData[0]['state'],
                                      'Zip Code',
                                      widget.CustomerData[0]['zip'] == null
                                          ? ''
                                          : widget.CustomerData[0]['zip'],
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
                                          Icons.mail,
                                          color: ColorCollection.backColor,
                                        ),
                                        SizedBox(
                                          width: width * 0.04,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Country',
                                                style:
                                                    ColorCollection.titleStyle),
                                            SizedBox(
                                              height: height * 0.005,
                                            ),
                                            Text(
                                              widget.CustomerData[0]
                                                          ['country_name'] ==
                                                      null
                                                  ? ''
                                                  : widget.CustomerData[0]
                                                      ['country_name'],
                                              style: ColorCollection
                                                  .subTitleStyle
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 14,
                                                      color: Colors.black),
                                            ),
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
                                      horizontal: width * 0.03,
                                      vertical: height * 0.005),
                                  height: height * 0.035,
                                  decoration: BoxDecoration(
                                    color: ColorCollection.backColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                          '#' +
                                              widget.CustomerData[0]['userid'],
                                          style:
                                              ColorCollection.titleStyleWhite),
                                      SizedBox(width: width * 0.02),
                                      SizedBox(
                                        width: width * 0.13,
                                        child: Marquee(
                                          child: Text(
                                            widget.CustomerData[0]['company'],
                                            textAlign: TextAlign.start,
                                            style: ColorCollection
                                                .titleStyleWhite
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
                                  width: width * 0.03,
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
                    ),

                    // Tasks Tab
                    CustomerTasks(
                        rel_id: widget.CustomerData[0]['userid'].toString()),

                    // Tickets Tab
                    ProjectTickets(
                      ticketFileRoute: TicketFileRoute(
                          CustomerID: widget.CustomerData[0]['userid'],
                          Type: 'customer',
                          ProjectID: '0'),
                    ),

                    // Contacts Tab
                    Contacts(
                      customerID: widget.CustomerData[0]['userid'],
                    ),

                    // Address Tab
                    AddressWidget(
                      CustomerData: widget.CustomerData,
                    ),

                    // Fields Tab
                    Container(
                      height: height * 0.62,
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.06, vertical: 20),
                      width: width,
                      decoration: kContaierDeco.copyWith(
                          color: ColorCollection.containerC),
                      child: field.FieldScreen(
                        CustomField: widget.CustomerData[0]
                            ['Customer_customfield'],
                      ),
                    ),
                    // Notes Tab
                    CustomerNotes(
                      CustomerID: widget.CustomerData[0]['userid'],
                    ),
                    // Performa Tab
                    Performa(
                      pageArgument: PageArgument(
                        Staff_id: widget.CustomerData[0]['userid'],
                        Title: 'Invoices',
                      ),
                    ),
                    //Estimates Tab
                    EstimatesWidget(
                      CustomerID: widget.CustomerData[0]['userid'],
                    ),

                    //Projects Tab
                    CustomerProjects(
                        CustomerID: widget.CustomerData[0]['userid']),

                    // Files Tab
                    ProjectFiles(
                      routefile: RouteFile(
                          ID: widget.CustomerData[0]['userid'],
                          Type: 'customer'),
                    ),
                    // Reminders Tab
                    ReminderList(
                      CustomerID: widget.CustomerData[0]['userid'],
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

  Widget customerDetailContainer(
      double width,
      double height,
      String title,
      String value,
      String title2,
      String value2,
      IconData? icon1,
      IconData? icon2) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (title.toLowerCase() == 'address' && value != '') {
                launchMap(value);
              } else if (title.toLowerCase() == 'Phone Number'.toLowerCase() &&
                  value != '') {
                launch("tel://" + value);
              } else if (title.toLowerCase() == 'Website'.toLowerCase() &&
                  value != '') {
                launch(value);
              }
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                decoration: deco,
                height: height * 0.08,
                // width: width * 0.42,
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
                            width: width * 0.18,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(title,
                                    style: ColorCollection.titleStyle))),
                        SizedBox(height: height * 0.005),
                        SizedBox(
                            width: width * 0.6,
                            child: Marquee(
                              child: Text(
                                value,
                                style: ColorCollection.subTitleStyle.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
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
          SizedBox(
            height: height * 0.02,
          ),
          InkWell(
            onTap: () {
              if (title2.toLowerCase() == 'address' && value2 != '') {
                launchMap(value2);
              } else if (title2.toLowerCase() == 'Phone Number'.toLowerCase() &&
                  value2 != '') {
                launch("tel://" + value2);
              } else if (title2.toLowerCase() == 'Website'.toLowerCase() &&
                  value2 != '') {
                launch(value2);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              decoration: deco,
              height: height * 0.08,
              // width: width * 0.42,
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
                          width: width * 0.18,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child:
                                Text(title2, style: ColorCollection.titleStyle),
                          )),
                      SizedBox(height: height * 0.005),
                      SizedBox(
                        width: width * 0.6,
                        child: Marquee(
                          child: Text(
                            value2,
                            overflow: TextOverflow.ellipsis,
                            style: ColorCollection.subTitleStyle.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: Colors.black),
                          ),
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

  void launchMap(String address) async {
    try {
      String query = Uri.encodeComponent(address);
      String googleUrl =
          "https://www.google.com/maps/search/?api=1&query=$query";
      // if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(
        Uri.parse(googleUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print('Launch map --Error $e');
    }
    // } else {
    //   print('cant Launch');
    // }
  }
}
