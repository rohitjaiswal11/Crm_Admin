// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, must_be_immutable, prefer_final_fields, unused_field, non_constant_identifier_names, avoid_print, import_of_legacy_library_into_null_safe, unnecessary_null_comparison, prefer_if_null_operators

import 'dart:convert';

import 'package:flutter/material.dart';

import '../LBM_Plugin/lbmplugin.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Support/add_new_ticket.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/Support/support_detail_screen.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/storage_manger.dart';

import '../util/ToastClass.dart';
import '../util/commonClass.dart';

class SupportScreen extends StatefulWidget {
  static const id = '/Support';
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
//variable initialization

  List PassTicket = [];
  List Ticket = [];
  List Ticketnew = [];
  List Ticketsearch = [];
  List dataTicket = [];
  List dataHeader = [];
  late String limit;
  int start = 1;
  var isDataFetched = false;
  bool isLoading = false;
  String TicketStatusCurrent = "0";

  @override
  void initState() {
    super.initState();
    limit = CommanClass.limitList[2];
    setState(() {});
    getTicketDashboard("0");
  }

  //Page finish
  @override
  void dispose() {
    super.dispose();
    dataTicket = [];
    dataHeader = [];

    start = 1;
    isDataFetched = false;
    Ticket.clear();
    Ticketnew.clear();
  }

  //Fetch the Support data by api with pagination
  Future<void> getTicketDashboard(String TicketStatus, {String? search}) async {
    setState(() {
      isDataFetched = false;
    });
    final paramDic = {
      "staff_id": await SharedPreferenceClass.GetSharedData('staff_id'),
      "start": start.toString(),
      "order_by": 'desc',
      if (limit != 'All') "limit": limit.toString(),
      if (search != null && search.isNotEmpty) "search": '$search',
      "status": TicketStatus.toString(),
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetSupportAll, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    Ticket.clear();
    Ticketnew.clear();
    Ticketsearch.clear();
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
      setState(() {
        Ticket = data['data'];
        print(Ticket);
        dataHeader = data['status_count'];
        print(dataHeader);
        Ticketnew.addAll(Ticket);
        Ticketsearch.addAll(Ticket);
        isDataFetched = true;
      });
    } else {
      setState(() {
        isDataFetched = true;
      });
      Ticket.clear();
      Ticketnew.clear();
    }
  }

  //fetch the more data
  // getTicketDashboardMore(String TicketStatus) async {
  //   final paramDic = {
  //     "staff_id": await SharedPreferenceClass.GetSharedData('staff_id'),
  //     "limit": limit.toString(),
  //     "start": start.toString(),
  //     "status": TicketStatus.toString(),
  //   };
  //   var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
  //       APIClasses.GetSupportAll, paramDic, "Get", Api_Key_by_Admin);
  //   var data = json.decode(response.body);
  //   Ticket.clear();
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       Ticket = data['data'];
  //       if (Ticket.isEmpty) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       } else {
  //         Ticketnew.addAll(Ticket);
  //         Ticketsearch.addAll(Ticket);

  //         isLoading = false;
  //       }
  //     });
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print(Ticketnew.length);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () async {
          Navigator.pushNamed(context, AddNewTicket.id,
                  arguments:
                      await SharedPreferenceClass.GetSharedData('staff_id'))
              .then((val) =>
                  val != null ? getTicketDashboard(TicketStatusCurrent) : null);
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
                        height: height * 0.07,
                        width: width * 0.15,
                        child: Image.asset(
                          'assets/newticket.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Text(
                        KeyValues.support,
                        style: ColorCollection.screenTitleStyle,
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
                    child: isDataFetched == false
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : dataHeader.isNotEmpty
                            ? ListView.builder(
                                itemCount: dataHeader.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) => supportContainer(
                                    width: width, height: height, index: i),
                              )
                            : Center(
                                child: Text(''),
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
                  borderRadius: BorderRadius.circular(10),
                ),
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
                          hintText: KeyValues.searchTickets,
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
                        onPressed: () {
                          FocusManager.instance.primaryFocus!.unfocus();
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: width * 0.3,
                        decoration: kDropdownContainerDeco,
                        child: DropdownButtonFormField<String>(
                          hint: Text(KeyValues.nothingSelected),
                          style: ColorCollection.titleStyle,
                          isExpanded: true,
                        //  isDense: false,
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
                            getTicketDashboard('0');
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: width,
                    height: height * 0.53,
                    child: isDataFetched == false
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Ticketnew.isNotEmpty
                            ? ListView.builder(
                                itemCount: Ticketnew.length,
                                itemBuilder: (ctx, i) =>
                                    supportDetailsContainer(
                                  height,
                                  width,
                                  i,
                                ),
                              )
                            : Center(
                                child: Text('No Data'),
                              ),
                  ),
                  SizedBox(
                    height: height * 0.07,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget supportDetailsContainer(
    double height,
    double width,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        PassTicket.clear();
        PassTicket.add(Ticketnew[index]);
        print('Pass Ticket ===' + PassTicket.toString());

        Navigator.pushNamed(context, SupportDetailScreen.id,
            arguments: PassTicket);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.01),
        padding: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.01,
            top: height * 0.005,
            bottom: height * 0.005),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            color: Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(6)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.4,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                        Ticketnew[index]['ticketid'].toString() == null
                            ? ''
                            : "#" +
                                Ticketnew[index]['ticketid'].toString() +
                                "-" +
                                Ticketnew[index]['subject'].toString(),
                        style: ColorCollection.titleStyle2),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: height * 0.008),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: _colorFromHex(
                          Ticketnew[index]['status_color'] == null
                              ? ''
                              : Ticketnew[index]['status_color'])),
                  child: Center(
                      child: Text(
                          Ticketnew[index]['status_name'].toString() == null
                              ? ''
                              : Ticketnew[index]['status_name'].toString(),
                          style: ColorCollection.titleStyleWhite2)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: height * 0.008),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.grey.shade500),
                  child: Center(
                      child: Text(
                          Ticketnew[index]['priority_name'].toString() == null
                              ? ''
                              : Ticketnew[index]['priority_name'].toString(),
                          style: ColorCollection.titleStyleWhite2)),
                ),
              ],
            ),
            SizedBox(height: height * 0.007),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${KeyValues.dept} - ' +
                      (Ticketnew[index]['department_name'].toString() == null
                          ? ''
                          : Ticketnew[index]['department_name'].toString()),
                  style: ColorCollection.subTitleStyle,
                ),
                Text(
                  '${KeyValues.createdAt}-' +
                      (Ticketnew[index]['date'].toString() == null
                          ? ''
                          : Ticketnew[index]['date'].toString()),
                  style: ColorCollection.subTitleStyle,
                )
              ],
            ),
            SizedBox(height: height * 0.007),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.4,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      (Ticketnew[index]['contact_name'] ?? '') +
                          (Ticketnew[index]['project_name'] == null
                              ? ''
                              : '( ' +
                                  Ticketnew[index]['project_name'].toString() +
                                  ' )'),
                      style: ColorCollection.subTitleStyle,
                    ),
                  ),
                ),
                Text(
                  '${KeyValues.lastReply}-' +
                      (Ticketnew[index]['lastreply'] == null
                          ? '-'
                          : Ticketnew[index]['lastreply'].toString()),
                  style: ColorCollection.subTitleStyle,
                )
              ],
            ),
            SizedBox(height: height * 0.007),
          ],
        ),
      ),
    );
  }

  Widget supportContainer(
      {required double width, required double height, required int index}) {
    return InkWell(
      onDoubleTap: () {
        getTicketDashboard('0');
      },
      onTap: () {
        setState(() {
          start = 1;
          TicketStatusCurrent = dataHeader[index]['ticketstatusid'].toString();
          getTicketDashboard(TicketStatusCurrent);
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
              Text(
                dataHeader[index]['name'],
                textAlign: TextAlign.center,
                softWrap: true,
                style: ColorCollection.titleStyle2.copyWith(
                    color: _colorFromHex(dataHeader[index]['statuscolor'])),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Text(dataHeader[index]['total'],
                  style: ColorCollection.titleStyle2)
            ],
          )),
    );
  }

//Search the ticket
  onSearchTextChanged(String text) async {
    if (text.isEmpty || text == '') {
      getTicketDashboard(
        '0',
      );
    } else {
      getTicketDashboard('0', search: text);
    }
  }

  //hax color change into color name
  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
