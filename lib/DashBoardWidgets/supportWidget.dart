// ignore_for_file: file_names, import_of_legacy_library_into_null_safe, non_constant_identifier_names, avoid_print, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Support/support_screen.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

import '../Support/add_new_ticket.dart';
import '../Support/support_detail_screen.dart';
import '../util/APIClasses.dart';
import '../util/LicenceKey.dart';
import '../util/ToastClass.dart';
import '../util/app_key.dart';
import '../util/colors.dart';
import '../util/storage_manger.dart';

class DashBoardSupport extends StatefulWidget {
  const DashBoardSupport({Key? key}) : super(key: key);

  @override
  State<DashBoardSupport> createState() => _DashBoardSupportState();
}

class _DashBoardSupportState extends State<DashBoardSupport> {
  List PassTicket = [];
  List Ticket = [];
  List Ticketnew = [];
  List Ticketsearch = [];
  List dataTicket = [];
  List dataHeader = [];
  int limit = 10;
  int start = 1;
  var isDataFetched = false;
  bool isLoading = false;
  String TicketStatusCurrent = "0";

  @override
  void initState() {
    super.initState();
    getTicketDashboard("0");
  }

  //Page finish
  @override
  void dispose() {
    super.dispose();
    dataTicket = [];
    dataHeader = [];
    limit = 10;
    start = 1;
    isDataFetched = false;
    Ticket.clear();
    Ticketnew.clear();
  }

  //Fetch the Support data by api with pagination
  Future<void> getTicketDashboard(String TicketStatus) async {
    final paramDic = {
      "staff_id": await SharedPreferenceClass.GetSharedData('staff_id'),
      "start": start.toString(),
      if (limit != 'All') 'limit': '$limit',
      "order_by": 'desc',
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
      isDataFetched = true;
      Ticket.clear();
      Ticketnew.clear();
    }
  }

  //fetch the more data
  getTicketDashboardMore(String TicketStatus) async {
    final paramDic = {
      "staff_id": await SharedPreferenceClass.GetSharedData('staff_id'),
      "limit": limit.toString(),
      "start": start.toString(),
      "status": TicketStatus.toString(),
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetSupportAll, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    Ticket.clear();
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
        Ticket = data['data'];
        if (Ticket.isEmpty) {
          setState(() {
            isLoading = false;
          });
        } else {
          Ticketnew.addAll(Ticket);
          Ticketsearch.addAll(Ticket);

          isLoading = false;
        }
      });
    } else {
      setState(() {
        isLoading = false;
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
        child: Column(children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: height * 0.005),
            decoration: BoxDecoration(
                color: ColorCollection.backColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Image.asset(
                  'assets/newticket.png',
                  height: 30,
                  width: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SupportScreen.id);
                  },
                  child: Text(
                    ' Support'.toUpperCase(),
                    style: ColorCollection.titleStyleWhite.copyWith(
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.pushNamed(context, AddNewTicket.id,
                                arguments:
                                    await SharedPreferenceClass.GetSharedData(
                                        'staff_id'))
                            .then((val) => val != null
                                ? getTicketDashboard(TicketStatusCurrent)
                                : null);
                      },
                      child: Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.04,
                    )
                  ],
                )
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
                              child: Text('No Data'),
                            ),
                ),
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isLoading &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      // start loading data
                      setState(() {
                        start = start + limit;
                        getTicketDashboardMore(TicketStatusCurrent);
                        isLoading = true;
                      });
                    }
                    return false;
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.01),
                        width: width,
                        height: height * 0.25,
                        child: isDataFetched == false
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Ticketnew.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
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
                      Container(
                        height: isLoading ? 30.0 : 0,
                        color: Colors.transparent,
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]));
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
        margin: EdgeInsets.only(bottom: height * 0.005),
        padding: EdgeInsets.only(
          left: width * 0.02,
          right: width * 0.01,
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            color: Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(6)),
        child: Column(
          children: [
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.4,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                        Ticketnew[index]['ticketid'] == null
                            ? ''
                            : "#" +
                                Ticketnew[index]['ticketid'].toString() +
                                "-" +
                                Ticketnew[index]['subject'].toString(),
                        style: ColorCollection.titleStyle),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: height * 0.002),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: _colorFromHex(
                          Ticketnew[index]['status_color'] ?? '')),
                  child: Center(
                      child: Text(Ticketnew[index]['status_name'] ?? '',
                          style: ColorCollection.titleStyleWhite2)),
                ),
                if (Ticketnew[index]['priority_name'] != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02, vertical: height * 0.002),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.grey.shade500),
                    child: Center(
                        child: Text(Ticketnew[index]['priority_name'] ?? '',
                            style: ColorCollection.titleStyleWhite2)),
                  ),
              ],
            ),
            SizedBox(height: height * 0.005),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${KeyValues.dept} - ' +
                      (Ticketnew[index]['department_name'] ?? ''),
                  style: ColorCollection.subTitleStyle,
                ),
                SizedBox(
                  width: width * 0.5,
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
              ],
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
    );
  }

  Widget supportContainer(
      {required double width, required double height, required int index}) {
    return InkWell(
      onTap: () {
        Ticketnew.clear();
        setState(() {
          Ticketnew.addAll(Ticket.where((element) =>
              element['status_name'].toString().toUpperCase() ==
              dataHeader[index]['name'].toString().toUpperCase()));
        });
      },
      child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.01,
          ),
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dataHeader[index]['name'],
                textAlign: TextAlign.center,
                softWrap: true,
                style: ColorCollection.titleStyle2.copyWith(
                    color: _colorFromHex(dataHeader[index]['statuscolor']),
                    fontSize: 11),
              ),
              SizedBox(
                width: width * 0.01,
              ),
              Text(' ${dataHeader[index]['total']}',
                  style: ColorCollection.titleStyle2.copyWith(fontSize: 11))
            ],
          )),
    );
  }

//Search the ticket
  onSearchTextChanged(String text) async {
    Ticketnew.clear();
    if (text.isEmpty) {
      setState(() {
        Ticketnew = List.from(Ticketsearch);
      });
      return;
    }

    setState(() {
      Ticketnew = Ticketsearch.where((item) => item['ticketid']
          .toString()
          .toLowerCase()
          .contains(text.toString().toLowerCase())).toList();
    });
  }

  //hax color change into color name
  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
