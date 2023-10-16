// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, must_be_immutable, non_constant_identifier_names, import_of_legacy_library_into_null_safe, unnecessary_null_comparison, prefer_if_null_operators

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Support/add_new_ticket.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/routesArguments.dart';

import '../LBM_Plugin/lbmplugin.dart';

import '../Support/support_detail_screen.dart';

class ProjectTickets extends StatefulWidget {
  TicketFileRoute ticketFileRoute;
  String CustomerID = '', CustomerType = '', ProjectID = '';

  ProjectTickets({required this.ticketFileRoute}) {
    CustomerID = ticketFileRoute.CustomerID.toString();
    CustomerType = ticketFileRoute.Type.toString();
    ProjectID = ticketFileRoute.ProjectID.toString();
  }
  @override
  _ProjectTicketsState createState() => _ProjectTicketsState();
}

class _ProjectTicketsState extends State<ProjectTickets> {
  //variable initialization
  List Passticket = [];
  List ticket = [];
  List ticketnew = [];
  List ticketsearch = [];
  List dataticket = [];
  List dataHeader = [];
  List Tasksearch = [];

  int limit = 20;
  int start = 1;
  var isDataFetched = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getticketDashboard();
  }

  //page finish
  @override
  void dispose() {
    super.dispose();
    dataticket = [];
    dataHeader = [];
    limit = 20;
    start = 1;
    isDataFetched = false;
    ticket.clear();
    ticketnew.clear();
    ticketsearch.clear();
  }

  //show ticket data according customer and project
  Future<void> getticketDashboard({String? statusId}) async {
    final paramDic = {
      "id": widget.CustomerType.toString() == 'customer'
          ? widget.CustomerID.toString()
          : widget.ProjectID.toString(),
      "type": widget.CustomerType.toString(),
      if (statusId != null) 'status': '$statusId'
    };
    print('====Paraams -- $paramDic');
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetTicketDetail, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    ticket.clear();
    ticketnew.clear();
    ticketsearch.clear();
    if (response.statusCode == 200) {
      if (mounted) {
        log(data.toString());
        setState(() {
          ticket = data['data'];
          dataHeader = data['status_count'];
          ticketnew.addAll(ticket);
          ticketsearch.addAll(ticket);

          isDataFetched = true;
        });
      }
    } else {
      setState(() {
        isDataFetched = true;
        ticket.clear();
        ticketnew.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          print(widget.CustomerID);
          setState(() {
            CommanClass.CustomerID = widget.CustomerID.toString();
            CommanClass.navigatingData = {
              'hasData': true,
              'projectID': widget.ProjectID
            };
          });

          Navigator.pushNamed(
            context,
            AddNewTicket.id,
            arguments: CommanClass.CustomerID,
          );
        },
      ),
      body: SelectionArea(
        child: Column(
          children: [
            if (widget.CustomerType == 'customer')
              SizedBox(height: height * 0.02),
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
            Stack(
              children: [
                Container(
                    height: height * 0.58,
                    margin: EdgeInsets.only(top: height * 0.04),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.06,
                    ),
                    width: width,
                    decoration: kContaierDeco.copyWith(
                        color: ColorCollection.containerC),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.04,
                        ),
                        Flexible(
                            child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          //check data fetch by server or not
                          child: isDataFetched == false
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ticketnew.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: ticketnew.length,
                                      padding:
                                          EdgeInsets.only(top: height * 0.05),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        //                            return buildList(context, index);
                                        return ticketContainer(
                                            width, height, index);
                                      })
                                  : Center(
                                      child: Text('No data'),
                                    ),
                        )),
                        SizedBox(height: height * 0.07),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
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
          ],
        ),
      ),
    );
  }

  Widget supportContainer(
      {required double width, required double height, required int index}) {
    return InkWell(
      onDoubleTap: () {
        // getTicketDashboard('0');
      },
      onTap: () {
        setState(() {
          // limit = 10;
          // start = 1;
          final ticketId = dataHeader[index]['ticketstatusid'].toString();
          getticketDashboard(statusId: ticketId);
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

  //hax color change into color name
  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Widget ticketContainer(double width, double height, int index) {
    return InkWell(
      onTap: () {
        log(ticketnew[index].toString());
        List PassTicket = [];

        PassTicket.add(ticketnew[index]);
        print('Pass Ticket ===' + PassTicket.toString());

        Navigator.pushNamed(context, SupportDetailScreen.id,
            arguments: PassTicket);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.04, vertical: height * 0.02),
        decoration: kDropdownContainerDeco,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.25,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      ticketnew[index]['ticketid'].toString() == null
                          ? ''
                          : "#" +
                              ticketnew[index]['ticketid'].toString() +
                              "-" +
                              ticketnew[index]['subject'].toString(),
                      style: ColorCollection.titleStyle2,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.01),
                      color: ColorCollection.backColor,
                      alignment: Alignment.center,
                      width: width * 0.2,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '${ticketnew[index]['status_name']}',
                          style: ColorCollection.titleStyleWhite2
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.06,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05, vertical: height * 0.01),
                      decoration: kDropdownContainerDeco,
                      alignment: Alignment.center,
                      width: width * 0.22,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          ticketnew[index]['priority_name'].toString() == null
                              ? ''
                              : ticketnew[index]['priority_name'].toString(),
                          style: ColorCollection.subTitleStyle
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height * 0.015,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      KeyValues.dept,
                      style: ColorCollection.titleStyle
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      KeyValues.Client,
                      style: ColorCollection.titleStyle
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      KeyValues.reply,
                      style: ColorCollection.titleStyle
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      KeyValues.createdAt,
                      style: ColorCollection.titleStyle
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticketnew[index]['department_name'].toString() == null
                          ? ''
                          : ticketnew[index]['department_name'].toString(),
                      style: ColorCollection.titleStyleGreen3,
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      ticketnew[index]['project_name'].toString() == null
                          ? ''
                          : ticketnew[index]['project_name'].toString(),
                      style: ColorCollection.titleStyleGreen3,
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      ticketnew[index]['lastreply'] == null
                          ? 'No Reply Yet'
                          : ticketnew[index]['lastreply'].toString(),
                      style: ColorCollection.titleStyleGreen3,
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: ColorCollection.backColor,
                              size: 15,
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Text(
                                ticketnew[index]['date'].toString() == null
                                    ? ''
                                    : ticketnew[index]['date']
                                        .toString()
                                        .substring(0, 10),
                                style: ColorCollection.titleStyleGreen3),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: ColorCollection.backColor,
                              size: 15,
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Text(
                                ticketnew[index]['date'].toString() == null
                                    ? ''
                                    : ticketnew[index]['date']
                                        .toString()
                                        .substring(11),
                                style: ColorCollection.titleStyleGreen3),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //search the ticket by id and subject
  onSearchTextChanged(String text) async {
    ticketnew.clear();
    if (text.isEmpty) {
      setState(() {
        ticketnew = List.from(ticketsearch);
      });
      return;
    }

    setState(() {
      ticketnew = ticketsearch
          .where((item) =>
              item['ticketid'].toLowerCase().contains(text.toLowerCase()) ||
              item['subject']
                  .toString()
                  .toLowerCase()
                  .contains(text.toString().toLowerCase()))
          .toList();
    });
  }
}
