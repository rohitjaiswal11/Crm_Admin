// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, must_be_immutable, avoid_print, import_of_legacy_library_into_null_safe, file_names, prefer_if_null_operators

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Invoice/invoice_detail_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/routesArguments.dart';


import 'package:marquee_widget/marquee_widget.dart';

import '../../Invoice/add_invoice_screen.dart';
import '../../Plugin/lbmplugin.dart';
import '../../util/ToastClass.dart';

class Performa extends StatefulWidget {
  static const id = 'perfroma';
  PageArgument pageArgument;
  String? CustomerID;
  String? Title;
  Performa({Key? key, required this.pageArgument}) : super(key: key) {
    CustomerID = pageArgument.Staff_id;
    Title = pageArgument.Title;
  }
  @override
  _PerformaState createState() => _PerformaState();
}

class _PerformaState extends State<Performa> {
  List Passperforma = [];
  List performa = [];
  List performanew = [];
  List performasearch = [];
  List dataperforma = [];
  List invoice_status = [];
  Map dataHeader = {};
  int limit = 20;
  int start = 1;
  String? dueDateYear;
  // String? status;
  var isDataFetched = false;
  bool isLoading = false;
  Future<void> getperformaDashboard({String? status}) async {
    final paramDic = {
      "customer_id": widget.CustomerID.toString(),
      "detailtype": 'invoice',
      "duedateyear": (dueDateYear ?? DateTime.now().year).toString(),
      if (status != null) "status": status,
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDetail, paramDic, "Get", Api_Key_by_Admin);

    if (response.statusCode == 200) {
      try {
        log(response.body);

        final data = json.decode(response.body);
        if (data['status'] != true) if (data['status'].toString() != '1') {
          setState(() {
            isDataFetched = true;
            performa.clear();
            performanew.clear();
            invoice_status.clear();
          });
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Load Data', Colors.red);
          return;
        }
      } catch (e) {
        setState(() {
          isDataFetched = true;
          performa.clear();
          performanew.clear();
          invoice_status.clear();
        });
        ToastShowClass.toastShow(null, 'Failed to Load Data', Colors.red);
        return;
      }
      final data = json.decode(response.body);
      log(data.toString());
      performa.clear();
      performanew.clear();
      performasearch.clear();
      invoice_status.clear();
      dataHeader.clear();
      print(performa);
      if (!mounted) {
        return;
      }
      setState(() {
        performa = data['data'];
        dataHeader = data['invoice_head'];
        invoice_status = data['invoice_status'];
        invoice_status.insert(0, {'statusName': 'All'});
        performanew.addAll(performa);
        performasearch.addAll(performa);
        isDataFetched = true;
      });
    } else {
      log(response.body);
      setState(() {
        isDataFetched = true;
        performa.clear();
        performanew.clear();
        invoice_status.clear();
      });
    }
    if (dataHeader.isEmpty) {
      setState(() {
        dataHeader = {
          'Outstanding Invoices': '0',
          'Past Due Invoices': '0',
          'Paid Invoices': '0'
        };
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.CustomerID);
    getperformaDashboard();
  }

  @override
  void dispose() {
    super.dispose();
    dataperforma = [];
    dataHeader = {};
    limit = 20;
    start = 1;
    isDataFetched = false;
    performa.clear();
    performanew.clear();
    performasearch.clear();
  }

  onSearchTextChanged(String text) async {
    performanew.clear();
    if (text.isEmpty) {
      setState(() {
        performanew = List.from(performasearch);
      });
      return;
    }

    setState(() {
      performanew = performasearch
          .where((item) =>
              item['number'].toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // log(DateTime.now().year.toString());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          Navigator.pushNamed(context, AddInvoiceScreen.id,
              arguments: {"customerID": widget.CustomerID}).then((value) {
            getperformaDashboard();
          });
        },
      ),
      body: SelectionArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: width * 0.25,
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField(
                        hint: dueDateYear != null
                            ? Text(
                                '$dueDateYear',
                                style: TextStyle(color: Colors.black),
                              )
                            : Text('${DateTime.now().year}'),
                        style: ColorCollection.titleStyle,
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
                        // value: _contact,
                        onChanged: (val) async {
                          setState(() {
                            dueDateYear = val.toString();
                          });
                          getperformaDashboard();
                        },
                        items: [
                          DateTime.now().year,
                          (DateTime.now().year - 1),
                          (DateTime.now().year - 2)
                        ].map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(
                              '$year',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      height: height * 0.06,
                      width: width * 0.65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: height * 0.06,
                            width: width * 0.5,
                            child: TextFormField(
                              onChanged: onSearchTextChanged,
                              decoration: InputDecoration(
                                hintText: 'Search Invoice',
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
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
              Stack(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: height * 0.05),
                      height: height * 0.6,
                      padding: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                          top: height * 0.08,
                          bottom: height * 0.03),
                      width: width,
                      decoration: kContaierDeco.copyWith(
                          color: ColorCollection.containerC),
                      child: isDataFetched == false
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : performanew.isNotEmpty
                              ? ListView.builder(
                                  padding: EdgeInsets.only(top: height*0.11,bottom: height * 0.03),
                                  itemCount: performanew.length,
                                  itemBuilder: (context, index) {
                                    return invoicesContainer(
                                        width, height, index);
                                  })
                              : Center(
                                  child: Text('No Data'),
                                )),
                                 Container(
                    margin: EdgeInsets.only(top: height * 0.13),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03,
                    ),
                    height: height * 0.08,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: invoice_status.length,
                      itemBuilder: (c, i) => inoviceStatusCard(
                        width,
                        height,
                        invoice_status[i]['status'].toString(),
                        invoice_status[i]['statusName'] ?? '',
                        invoice_status[i]['Count'] ?? '',
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
                      itemBuilder: (c, i) => titleCard(
                          width,
                          height,
                          dataHeader.values.toList()[i].toString(),
                          dataHeader.keys.toList()[i].toString(),
                          dataHeader.length < (i + 1)
                              ? null
                              : titleList[i].color),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget invoicesContainer(double width, double height, int index) {
    return GestureDetector(
      onTap: () {
        log(performanew[index].toString());
        Navigator.pushNamed(
          context,
          InvoiceDetailScreen.id,
          arguments: PageArgument(
            Staff_id: performanew[index]['addedfrom'].toString(),
            Title: 'payment',
            Invoiceid: performanew[index]['id'].toString(),
            InvoiceNumber: performanew[index]['number'].toString(),
          ),
        );
        print('INV ID' + performanew[index]['id'].toString());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.015),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.01),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            color: ColorCollection.backColor.withOpacity(0.02),
            borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.contact_page_outlined),
                    SizedBox(width: width * 0.01),
                    SizedBox(
                      width: width * 0.5,
                      child: Marquee(
                        child: Text(
                            performanew[index]['prefix'].toString() +
                                performanew[index]['number'].toString() +
                                " " +
                                performanew[index]['Invoice_name'].toString(),
                            style: ColorCollection.titleStyle2),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                        '${KeyValues.dueAmount} :' +
                            (performanew[index]['currency_name'] == null
                                ? ''
                                : performanew[index]['currency_name']
                                        .toString() +
                                    "-"),
                        style: ColorCollection.subTitleStyle2),
                    Text(
                        performanew[index]['duepayment'] == null
                            ? ''
                            : performanew[index]['duepayment'].toString(),
                        style: ColorCollection.subTitleStyle2),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height * 0.005,
            ),
            Row(
              children: [
                Text('${KeyValues.status} -',
                    style: ColorCollection.titleStyle),
                Text(
                    performanew[index]['status_name'] == null
                        ? ''
                        : performanew[index]['status_name'].toString(),
                    style: ColorCollection.titleStyle.copyWith(
                        color: performanew[index]['status_name'] == 'UNPAID'
                            ? Colors.red
                            : Colors.orange)),
              ],
            ),
            SizedBox(height: height * 0.007),
            FittedBox(
              child: Row(
                children: [
                  Text(
                    '${KeyValues.totalAmount}- ' +
                        ((performanew[index]['currency_name'] == null
                                        ? ''
                                        : performanew[index]['currency_name']) +
                                    performanew[index]['total'] ==
                                null
                            ? ''
                            : performanew[index]['total']),
                    style: ColorCollection.subTitleStyle2,
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Text(
                    '${KeyValues.date}-' +
                        (performanew[index]['datecreated'] == null
                            ? ''
                            : performanew[index]['datecreated'].toString()),
                    style: ColorCollection.subTitleStyle2,
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Text(
                      '${KeyValues.dueDate}-' +
                          (performanew[index]['duedate'] == null
                              ? ''
                              : performanew[index]['duedate'].toString()),
                      style: ColorCollection.subTitleStyle2),
                ],
              ),
            ),
            SizedBox(height: height * 0.01),
          ],
        ),
      ),
    );
  }

  Widget inoviceStatusCard(
      double width, double height, String id, String title, String count) {
    return InkWell(
      onTap: () async {
        
        ToastShowClass.toastShow(context, 'Loading', Colors.green);
        await getperformaDashboard(status: title == 'All' ? null:id);
      },
      child: Card(
        color: Colors.white60,
        elevation: 4,
        shadowColor: Colors.grey.shade100,
        child: Container(
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.all(5),
          // height: height * 0.1,
          width: width * 0.2,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade400, blurRadius: 2)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('$title', style: ColorCollection.titleStyle),
              if (title != 'All')
                SizedBox(
                  height: height * 0.01,
                ),
              if (title != 'All')
                Text(
                  '$count',
                  style: ColorCollection.subTitleStyle3,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleCard(
    double width,
    double height,
    String amount,
    String title,
    Color? color,
  ) {
    return InkWell(
      onTap: () async {
        if (title.toLowerCase() == 'Outstanding Invoices'.toLowerCase()) {
          await getperformaDashboard(status: '1,4');
        } else if (title.toLowerCase() == 'Paid Invoices'.toLowerCase()) {
          await getperformaDashboard(status: '2');
        } else if (title.toLowerCase() == 'Past Due Invoices'.toLowerCase()) {
          await getperformaDashboard(status: '4');
        }
      },
      child: Card(
        color: Colors.white60,
        elevation: 4,
        shadowColor: Colors.grey.shade100,
        child: Container(
          margin: EdgeInsets.all(3),
          height: height * 0.1,
          width: width * 0.3,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade400, blurRadius: 2)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('\$.$amount',
                  style: ColorCollection.titleStyle2.copyWith(color: color)),
              SizedBox(
                height: height * 0.01,
              ),
              Text(
                title,
                style: ColorCollection.subTitleStyle3,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleClass {
  final String amount;
  final String title;
  final Color? color;

  TitleClass({required this.amount, required this.title, this.color});
}

List<TitleClass> titleList = [
  TitleClass(amount: '0', title: 'Outstanding', color: Colors.black),
  TitleClass(amount: '10000', title: 'Past Due', color: Colors.red),
  TitleClass(amount: '5000', title: 'Paid', color: ColorCollection.green),
];
