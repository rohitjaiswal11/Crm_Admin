// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, import_of_legacy_library_into_null_safe, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Estimates/add_estimate_screen.dart';
import 'package:lbm_crm/Estimates/estimates_view.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/routesArguments.dart';
import 'package:lbm_crm/util/storage_manger.dart';

import '../Plugin/lbmplugin.dart';
import 'package:marquee_widget/marquee_widget.dart';

import '../util/ToastClass.dart';
import '../util/commonClass.dart';

class EstimatesScreen extends StatefulWidget {
  static const id = '/estimates';

  @override
  State<EstimatesScreen> createState() => _EstimatesScrenState();
}

class _EstimatesScrenState extends State<EstimatesScreen> {
  List estimate = [];
  List estimatenew = [];
  late String limit;
  List estimatesearch = [];
  var isDataFetched = false;
  @override
  void initState() {
    setState(() {
      limit = CommanClass.limitList[2];
    });
    super.initState();
    getestimatesdata();
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty || text == '') {
      getestimatesdata();
    } else {
      getestimatesdata(search: text);
    }
  }

// //get the proposal or invoice data by api
  Future<void> getestimatesdata({String? search}) async {
    setState(() {
      isDataFetched=false;
    });
    final paramDic = {
      "id": await SharedPreferenceClass.GetSharedData("staff_id"),
      "detailtype": 'estimate',
      'order_by': 'desc',
      if (limit != 'All') 'limit': '$limit',
      if (search != null && search.isNotEmpty) 'search': '$search',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDetail, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    estimate.clear();
    estimatenew.clear();
    estimatesearch.clear();
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
        estimate = data['data'];
        estimatenew.addAll(estimate);
        estimatesearch.addAll(estimate);
        isDataFetched = true;
      });
    } else {
      setState(() {
        isDataFetched = true;
        estimate.clear();
        estimatenew.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    log(estimatenew.toString());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          Navigator.pushNamed(context, AddEstimateScreen.id)
              .then((value) => getestimatesdata());
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
                      height: height * 0.07,
                      width: width * 0.13,
                      child: Image.asset(
                        'assets/estimate.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Text(KeyValues.estimates,
                        style: ColorCollection.screenTitleStyle),
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
                              hintText: 'Search Estimates',
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
                        getestimatesdata();
                      },
                    ),
                  ),
                ],
              ),
            ),
    SizedBox(
              height: height * 0.02,
            ),
Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.06,
              ),
              width: width,
              decoration:
                  kContaierDeco.copyWith(color: ColorCollection.containerC),
              child: Column(children: [
                SizedBox(height: height * 0.05),
                SizedBox(
                  height: height * 0.64,
                  child: isDataFetched == false
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : estimatenew.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: estimate.length,
                              itemBuilder: (c, i) => proposalContainer(
                                  width: width, height: height, index: i))
                          : Center(
                              child: Text('No Data'),
                            ),
                ),
                SizedBox(height: height * 0.01)
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget proposalContainer(
      {required double width, required double height, required int index}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, EstimatesView.id,
            arguments: Proposalinvoice(
              url: 'https://' +
                  APIClasses.BaseURL +
                  '/crm/estimate/' +
                  estimatenew[index]['id'].toString() +
                  '/' +
                  estimatenew[index]['hash'].toString(),
              Title: '',
            ));
      },
      child: Container(width: width/2,
          margin: EdgeInsets.only(bottom: height * 0.015),
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.01),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color:Colors.white,
              borderRadius: BorderRadius.circular(6)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.contact_page_outlined,
                        color: Colors.black,
                      ),
                   Marquee(direction: Axis.horizontal,  directionMarguee: DirectionMarguee.TwoDirection,
                     child: Container(
                            width: width *0.48,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'EST-' +
                                    estimatenew[index]['id'].toString() +
                                    " " +
                                    (estimatenew[index]['Customer_name'] ?? ''),
                                style: ColorCollection.titleStyle2,
                              ),
                            )),
                   )
                    ],
                  ),
                  Text(
                    '${KeyValues.openTill} : ' +
                        estimatenew[index]['expirydate'].toString(),
                    style: ColorCollection.smalltTtleStyle,
                  )
                ],
              ),
              SizedBox(height: height * 0.005),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${KeyValues.status}-',
                        style: ColorCollection.smalltTtleStyle,
                      ),
                      SizedBox(
                        width: width * 0.005,
                      ),
                      Text(
                        estimatenew[index]['status_name'].toString(),
                        style: ColorCollection.titleStyle
                            .copyWith(color: Colors.orange),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Project Name : ',
                        style: ColorCollection.smalltTtleStyle,
                      ),
                      SizedBox(
                        width: width * 0.1,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            (estimatenew[index]['project_name'] ?? ''),
                            style: ColorCollection.smalltTtleStyle,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.005,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${KeyValues.totalAmount} - ' +
                        estimatenew[index]['currency_name'] +
                        "-" +
                        estimatenew[index]['total'],
                    style: ColorCollection.smalltTtleStyle,
                  ),
                  Text(
                    '${KeyValues.date} -' +
                        estimatenew[index]['date'].toString(),
                    style: ColorCollection.smalltTtleStyle,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
