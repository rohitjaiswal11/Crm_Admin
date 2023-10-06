// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, must_be_immutable, prefer_final_fields, unused_field, import_of_legacy_library_into_null_safe, avoid_print, unnecessary_null_comparison, prefer_if_null_operators, non_constant_identifier_names, deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Customer/CustomerDetail/customer_detail_screen.dart';
import 'package:lbm_crm/Customer/add_new_customers.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/ToastClass.dart';

class CustomerScreen extends StatefulWidget {
  static const id = '/customer';
  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List PassCustomer = [];
  List customer = [];
  List customernew = [];
  List customernewActive = [];
  List customersearch = [];
  List dataHeader = [];
  late String limit;
  // List limitList = ['10', '20', '50', '100', 'All'];
  int start = 1;
  var isDataFetched = false;
  bool isLoading = false;
  bool status = false;
  final searchController = TextEditingController();

  customerSearch(String text) async {
    if (text.isEmpty) {
      customernew.clear();
      customernew.addAll(customer);
      return;
    }
    final paramDic = {
      "search": text,
      "order_by": 'desc',
      if (limit != 'All') "limit": '$limit',
    };
    print("dtatat " + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDashboard, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    log(data.toString());
    if (response.statusCode == 200) {
      if (data['status'] != false) {
        customernew.clear();
        customersearch.clear();
        customersearch = data['data']['customer_data'];
        print(customersearch.toString());
        customernew.addAll(customersearch);
        setState(() {});
      } else {}
    } else {}
  }

  Future<void> getCustomField() async {
    final paramDic = {
      "type": "customers",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          print(data['data']);
          CommanClass.CustomFieldData = data['data'];
        });
      }
    } else {
      print('status = ' + response.statusCode.toString());
    }
  }

  Future<void> getCustomerDashboard() async {
    setState(() {
      isDataFetched = false;
    });
    final paramDic = {
      "staff_id": CommanClass.StaffId,
      "order_by": 'desc',
      // "start": start.toString(),
      if (limit != 'All') "limit": limit.toString(),
    };

    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDashboard, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    customer.clear();
    customernew.clear();
    customersearch.clear();
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
      print(customer);
      if (mounted) {
        setState(() {
          customer = data['data']['customer_data'];
          dataHeader.add(data['data']);
          customernew.addAll(customer);
          print(customernew.length);
          for (int i = 0; i < customernew.length; i++) {
            if (customernew[i]['active'] == '1') {
              customernewActive.add(customernew[i]);
              // print("active =-=-=-= " + customernewActive.toString());
            }
          }
          customersearch.addAll(customer);
          isDataFetched = true;
        });
      }
    } else {
      customer.clear();
      customernew.clear();
    }
  }

  // getCustomerDashboardMore() async {
  //   final paramDic = {
  //     "staff_id": CommanClass.StaffId,
  //     "limit": limit.toString(),
  //     "start": start.toString(),
  //   };
  //   var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
  //       APIClasses.GetCustomerDashboard, paramDic, "Get", Api_Key_by_Admin);
  //   var data = json.decode(response.body);
  //   customer.clear();
  //   if (response.statusCode == 200) {
  //     try {
  //       final data = json.decode(response.body);
  //       if (data['status'] != true) if (data['status'].toString() != '1') {
  //         ToastShowClass.toastShow(
  //             null, data['message'] ?? 'Failed to Load Data', Colors.red);
  //       }
  //     } catch (e) {
  //       ToastShowClass.toastShow(null, 'Failed to Load Data', Colors.red);
  //     }
  //     setState(() {
  //       customer = data['data']['customer_data'];
  //       if (customer.isEmpty) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       } else {
  //         customernew.addAll(customer);
  //         customersearch.addAll(customer);
  //         isLoading = false;
  //       }
  //     });
  //   }
  // }

//search the customer by company name
  // onSearchTextChanged(String text) async {
  //   customernew.clear();
  //   if (text.isEmpty) {
  //     setState(() {
  //       customernew = List.from(customersearch);
  //     });
  //     return;
  //   }

  //   setState(() {
  //     customernew = customersearch
  //         .where((item) => item['company']
  //             .toString()
  //             .toLowerCase()
  //             .contains(text.toString().toLowerCase()))
  //         .toList();
  //   });
  // }

  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      limit = CommanClass.limitList[2];
    });
    super.initState();
    getCustomField();
    getCustomerDashboard();
  }

  @override
  void dispose() {
    super.dispose();
    dataHeader = [];
    limit = '20';
    start = 1;
    isDataFetched = false;
    customer.clear();
    customernew.clear();
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
          FocusManager.instance.primaryFocus?.unfocus();

          Navigator.pushNamed(context, NewCustomer.id)
              .then((value) => getCustomerDashboard());
        },
      ),
      backgroundColor: ColorCollection.grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      color: ColorCollection.backColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.07, horizontal: width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: height * 0.1,
                        width: width * 0.18,
                        child: Image.asset(
                          'assets/robo.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Text(KeyValues.customers,
                          style: ColorCollection.screenTitleStyle),
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
                      height: height * 0.11,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            customerContainer(
                              width: width,
                              height: height,
                              title: 'Total Customers',
                              value: isDataFetched
                                  ? int.parse(
                                      dataHeader[0]['total_customer']
                                          .toString(),
                                    )
                                  : 0,
                            ),
                            customerContainer(
                              width: width,
                              height: height,
                              title: 'Active Customers',
                              color: ColorCollection.backColor,
                              value: isDataFetched
                                  ? int.parse(
                                      dataHeader[0]['total_Active_customer']
                                          .toString(),
                                    )
                                  : 0,
                            ),
                            customerContainer(
                              width: width,
                              height: height,
                              title: 'Inactive Customers',
                              color: Colors.orange,
                              value: isDataFetched
                                  ? int.parse(
                                      dataHeader[0]['total_InActive_customer']
                                          .toString(),
                                    )
                                  : 0,
                            ),
                            customerContainer(
                              width: width,
                              height: height,
                              title: 'Active Customers',
                              color: ColorCollection.backColor,
                              value: isDataFetched
                                  ? int.parse(
                                      dataHeader[0]['total_Active_customer']
                                          .toString(),
                                    )
                                  : 0,
                            ),
                            customerContainer(
                              width: width,
                              height: height,
                              title: 'Inactive Customers',
                              color: Colors.orange,
                              value: isDataFetched == false
                                  ? 0
                                  : int.parse(
                                      dataHeader[0]['total_InActive_customer']
                                          .toString(),
                                    ),
                            ),
                          ],
                        ),
                      )),
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
                        controller: searchController,
                        autofocus: false,
                        onChanged: customerSearch,
                        decoration: InputDecoration(
                          hintText: KeyValues.searchCustomers,
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
              height: height * 0.03,
            ),
            Container(
              width: width,
              height: height * 0.61,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Switch(
                              trackColor: MaterialStateProperty.all(
                                  Colors.grey.shade300),
                              thumbColor: MaterialStateProperty.all(
                                  ColorCollection.backColor),
                              value: status,
                              onChanged: (value) {
                                setState(() {
                                  status = value;
                                });
                              }),
                          Text(KeyValues.excludeInactive,
                              style: ColorCollection.titleStyle),
                        ],
                      ),
                      Container(
                        width: width * 0.3,
                        decoration: kDropdownContainerDeco,
                        child: DropdownButtonFormField<String>(
                          hint: Text(KeyValues.nothingSelected),
                          style: ColorCollection.titleStyle,
                          //isDense:true,

                          isExpanded: true,
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
                            getCustomerDashboard();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  SizedBox(
                    height: height * 0.5,
               
                    child:
                        // Stack(
                        //   children: [
                        // NotificationListener<ScrollNotification>(
                        //   onNotification: (ScrollNotification scrollInfo) {
                        //     if (!isLoading &&
                        //         scrollInfo.metrics.pixels ==
                        //             scrollInfo.metrics.maxScrollExtent &&
                        //         scrollInfo.metrics.axis == Axis.vertical &&
                        //         searchController.text.isEmpty) {
                        //       // start loading data
                        //       setState(() {
                        //         start = start + limit;
                        //         getCustomerDashboardMore();
                        //         isLoading = true;
                        //       });
                        //     } else {
                        //       return false;
                        //     }
                        //     return false;
                        //   },
                        //   child:
                        isDataFetched == false
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : customernew.isNotEmpty
                                ? ListView.builder(
                                    itemCount: status
                                        ? customernewActive.length
                                        : customernew.length,
                                    itemBuilder: (ctx, i) => status
                                        ? detailsContainer(
                                            height,
                                            width,
                                            i,
                                            customernewActive[i]['company']
                                                        .toString() ==
                                                    null
                                                ? ''
                                                : customernewActive[i]
                                                        ['company']
                                                    .toString(),
                                            customernewActive[i][
                                                            'primary_contact_name']
                                                        .toString() ==
                                                    null
                                                ? ''
                                                : customernewActive[i]
                                                        ['primary_contact_name']
                                                    .toString(),
                                            customernewActive[i]['active'] ==
                                                '1',
                                            customernewActive,
                                            customernewActive[i]['Task_Count']
                                                .toString(),
                                            customernewActive[i]['Ticket_Count']
                                                .toString(),
                                          )
                                        : detailsContainer(
                                            height,
                                            width*0.8,
                                            i,
                                            customernew[i]['company']
                                                        .toString() ==
                                                    null
                                                ? ''
                                                : customernew[i]['company']
                                                    .toString(),
                                            customernew[i]['primary_contact_name']
                                                        .toString() ==
                                                    null
                                                ? ''
                                                : customernew[i]
                                                        ['primary_contact_name']
                                                    .toString(),
                                            customernew[i]['active'] == '1',
                                            customernew,
                                            customernew[i]['Task_Count']
                                                .toString(),
                                            customernew[i]['Ticket_Count']
                                                .toString(),
                                          ),
                                  )
                                : Center(
                                    child: Text('No Data'),
                                  ),
                    // ),
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child: Container(
                    //     height: isLoading ? 30.0 : 0,
                    //     color: Colors.transparent,
                    //     child: CircularProgressIndicator(),
                    //   ),
                    // ),
                    //   ],
                    // ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailsContainer(
    double height,
   double width,
    int index,
    String companyName,
    String name,
    bool isActive,
    List passList,
    String pendingTasks,
    String pendingTickets,
  ) {
    var groups = '';
    if (passList[index]['groups'] != null &&
        passList[index]['groups'].isNotEmpty) {
      for (var i = 0; i < passList[index]['groups'].length; i++) {
        groups += passList[index]['groups'][i]['name'].toString() +
            (i == passList[index]['groups'].length - 1 ? '' : ', ');
      }
    }
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();

        PassCustomer.clear();
        PassCustomer.add(passList[index]);
        log('passcustomer $PassCustomer');
        CommanClass.CustomerID = passList[index]['userid'].toString();
        print(CommanClass.CustomerID);

        Navigator.pushNamed(context, CustomerDetailScreen.id,
                arguments: PassCustomer)
            .then((value) => getCustomerDashboard());
      },
      child: Container(

      
        margin: EdgeInsets.only(bottom: height * 0.015),
        padding: EdgeInsets.only(bottom: height * 0.005),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            color: Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            SizedBox(
              width: width * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.01),
              child: SizedBox(
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
                          size: 35,
                          color: ColorCollection.green,
                        ),
                      ),
                    ),
                    Container(
                      //margin: EdgeInsets.only(bottom: 4, right:4),
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                          radius: 6,
                          backgroundColor:
                              isActive ? Colors.green : Colors.orange),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: width * 0.6,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(companyName,
                            style: ColorCollection.titleStyle2))),
                SizedBox(
                  height: height * 0.01,
                ),
                FittedBox(
                  child: Row(
                    children: [
                      SizedBox(
                          width: width * 0.3,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(name,
                                style: ColorCollection.subTitleStyle),
                          )),
                      SizedBox(
                        height: height * 0.02,
                        child: VerticalDivider(
                          color: ColorCollection.green,
                          thickness: 1,
                        ),
                      ),
                      Text('Tasks : $pendingTasks',
                          style: ColorCollection.subTitleStyle.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                      SizedBox(
                        height: height * 0.02,
                        child: VerticalDivider(
                          color: ColorCollection.green,
                          thickness: 1,
                        ),
                      ),
                      Text('Tickets : $pendingTickets',
                          style: ColorCollection.subTitleStyle.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  children: [
                    Text('Assigned Groups : ',
                        style: ColorCollection.subTitleStyle.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 11)),
                    SizedBox(
                      width: width * 0.4,
                      child: Marquee(
                        child: Text('$groups',
                            style: ColorCollection.subTitleStyle.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () async {
                // log(passList[index]['phonenumber'].toString());
                try {
                  print("Phone number :" + passList[index]['phonenumber']);
                  passList[index]['phonenumber'] == null
                      ? ToastShowClass.coolToastShow(
                          context, "no phone number", CoolAlertType.info)
                      : await launch("tel://" + passList[index]['phonenumber']);
                } catch (e) {
                  print('-- Launch url error --');
                }
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 42),
                height: height * 0.045,
                width: width * 0.1,
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                    color: ColorCollection.backColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.circular(6))),
                child: Center(
                    child: Icon(
                  Icons.call,
                  color: Colors.white,
                  size: 18,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customerContainer(
      {required double width,
      required double height,
      required String title,
      Color? color,
      required int value}) {
    return Container(
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
            Text(title,
                textAlign: TextAlign.center,
                softWrap: true,
                style: ColorCollection.titleStyle.copyWith(color: color)),
            SizedBox(
              height: height * 0.01,
            ),
            Text('$value', style: ColorCollection.titleStyle)
          ],
        ));
  }
}

class Contracts {
  Contracts({
    required this.title,
    required this.value,
    required this.color,
  });
  final String title;
  final int value;
  final Color color;
}

List<Contracts> contractItems = <Contracts>[
  Contracts(title: 'Total Customer', value: 17, color: Colors.grey),
  Contracts(title: 'Active Customer', value: 5, color: ColorCollection.green),
  Contracts(title: 'Inactive Customer', value: 0, color: Colors.orange),
  Contracts(title: 'Active Contacts', value: 6, color: Colors.greenAccent),
  Contracts(title: 'Inactive Contacts', value: 0, color: Colors.red),
];
