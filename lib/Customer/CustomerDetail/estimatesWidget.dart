// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, use_key_in_widget_constructors, non_constant_identifier_names, must_be_immutable, avoid_print, import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';


import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';

import '../../Estimates/add_estimate_screen.dart';
import '../../LBM_Plugin/lbmplugin.dart';
import '../../util/ToastClass.dart';

class EstimatesWidget extends StatefulWidget {
  static const id = 'estimatesWidget';

  String CustomerID = '';
  EstimatesWidget({required this.CustomerID});
  @override
  _EstimatesWidgetState createState() => _EstimatesWidgetState();
}

class _EstimatesWidgetState extends State<EstimatesWidget> {
  List Passestimate = [];
  List estimate = [];
  List estimatenew = [];
  List estimatesearch = [];
  List dataestimate = [];
  Map dataHeader = {};
  int limit = 20;
  int start = 1;
  var isDataFetched = false;
  bool isLoading = false;
  String? dueDateYear;

  @override
  void initState() {
    super.initState();
    print(widget.CustomerID);
    getestimateDashboard();
  }

  @override
  void dispose() {
    super.dispose();
    dataestimate = [];
    dataHeader = {};
    limit = 20;
    start = 1;
    isDataFetched = false;
    estimate.clear();
    estimatenew.clear();
    estimatesearch.clear();
  }

  Future<void> getestimateDashboard() async {
    final paramDic = {
      "customer_id": widget.CustomerID.toString(),

      // "start": start.toString(),
      // "limit": limit.toString(),
      "detailtype": 'estimate',
      "duedateyear": (dueDateYear ?? DateTime.now().year).toString()
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDetail, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    log(data.toString());
    estimate.clear();
    estimatenew.clear();
    estimatesearch.clear();
    dataHeader.clear();
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
      print(estimate);
      if (mounted) {
        setState(() {
          estimate = data['data'];
          dataHeader = data['estimate_head'];
          // dataHeader.add(data['data']);
          estimatenew.addAll(estimate);
          estimatesearch.addAll(estimate);
          isDataFetched = true;
        });
      }
    } else {
      setState(() {
        isDataFetched = true;
        estimate.clear();
        estimatenew.clear();
      });
    }
  }

  onSearchTextChanged(String text) async {
    estimatenew.clear();
    if (text.isEmpty) {
      setState(() {
        estimatenew = List.from(estimatesearch);
      });
      return;
    }

    setState(() {
      estimatenew = estimatesearch
          .where((item) =>
              item['number'].toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
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
          Navigator.pushNamed(context, AddEstimateScreen.id,
              arguments: {'customerID': widget.CustomerID});
        },
      ),
      body: SingleChildScrollView(
        child: SelectionArea(
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
                          getestimateDashboard();
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
                                hintText: 'Search Performa',
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
              SizedBox(height: height * 0.02),
              isDataFetched
                  ? Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: height * 0.05),
                          height: height * 0.59,
                          padding: EdgeInsets.only(
                              left: width * 0.04,
                              right: width * 0.04,
                              top: height * 0.1,
                              bottom: height * 0.03),
                          width: width,
                          decoration: kContaierDeco.copyWith(
                              color: ColorCollection.containerC),
                          child: estimatenew.isNotEmpty
                              ? ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: estimatenew.length,
                                  shrinkWrap: true,
                                  itemBuilder: (c, i) => estimateContainer(
                                      height,
                                      width,
                                      estimatenew[i]['prefix'].toString() +
                                          estimatenew[i]['number'].toString() +
                                          "  (" +
                                          estimatenew[i]['currency_name'] +
                                          "-" +
                                          estimatenew[i]['total'] +
                                          ")",
                                      estimatenew[i]['status_name'].toString(),
                                      estimatenew[i]['total_tax'].toString(),
                                      estimatenew[i]['date'].toString(),
                                      estimatenew[i]['expirydate'].toString()),
                                )
                              : Center(child: Text('No Data')),
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
                    )
                  : Container(
                      margin: EdgeInsets.only(top: height * 0.05),
                      height: height * 0.59,
                      padding: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                          top: height * 0.1,
                          bottom: height * 0.03),
                      width: width,
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget estimateContainer(
    double height,
    double width,
    String title,
    String status,
    String gst,
    String date,
    String expiry,
  ) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.011, bottom: height * 0.015),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.02),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          color: Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: ColorCollection.titleStyle),
              Row(
                children: [
                  Text('${KeyValues.status} :',
                      style: ColorCollection.subTitleStyle),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  Text(
                    status,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: height * 0.015,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${KeyValues.gst} :$gst%',
                  style: ColorCollection.subTitleStyle),
              Text('${KeyValues.date} : $date',
                  style: ColorCollection.subTitleStyle),
              Text('${KeyValues.expiryDate} : $expiry',
                  style: ColorCollection.subTitleStyle),
            ],
          ),
        ],
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
    return Card(
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
            boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 2)]),
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
              textAlign: TextAlign.center,
              style: ColorCollection.subTitleStyle3,
            ),
          ],
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
  TitleClass(amount: '60000', title: 'On Hold', color: Colors.blue),
  TitleClass(amount: '0', title: 'Pending', color: Colors.orange.shade400),
];

class EstimateClass {
  final String title;
  final String status;
  final double gst;
  final String date;
  final String expiry;

  EstimateClass(this.title, this.status, this.gst, this.date, this.expiry);
}

List<EstimateClass> estimateItems = [
  EstimateClass(
      'EST - 8 (USD-0.00)', 'Draft', 0.00, '2022-01-06', '2022-01-06'),
  EstimateClass(
      'EST - 8 (USD-0.00)', 'Draft', 25.00, '2022-01-06', '2022-01-06'),
  EstimateClass(
      'EST - 8 (USD-0.00)', 'Draft', 0.00, '2022-01-06', '2022-01-06'),
  EstimateClass(
      'EST - 8 (USD-0.00)', 'Draft', 90.00, '2022-01-06', '2022-01-06'),
  EstimateClass(
      'EST - 8 (USD-0.00)', 'Draft', 58.75, '2022-01-06', '2022-01-06'),
  EstimateClass(
      'EST - 8 (USD-0.00)', 'Draft', 20.00, '2022-01-06', '2022-01-06'),
];
