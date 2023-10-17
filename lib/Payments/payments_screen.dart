// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, import_of_legacy_library_into_null_safe, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';

import '../Plugin/lbmplugin.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/routesArguments.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';

import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/Payments/payment_detail_screen.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/constants.dart';

import '../util/ToastClass.dart';
import '../util/commonClass.dart';

class PaymentScreen extends StatefulWidget {
  static const id = '/Payments';

  @override
  State<PaymentScreen> createState() => _PaymentScrenState();
}

class _PaymentScrenState extends State<PaymentScreen> {
  List listPayment = [];
  var isDataFetched = false;
  Future<void> getproposalinvoicedata() async {
    final paramDic = {
      "staff_id": CommanClass.StaffId,
      "type": 'payment',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetProposalInvoice, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('here 1');
      try {
        final data = json.decode(response.body);
        if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Get Data', Colors.red);
        }
      } catch (e) {
        ToastShowClass.toastShow(null, 'Failed to Get Data', Colors.red);
      }
      print(data);
      setState(() {
        listPayment = data['data'];
        isDataFetched = true;
      });
    } else {
      print('here 2');
      setState(() {
        listPayment.clear();
        isDataFetched = true;
      });
    }
  }

  @override
  void initState() {
    getproposalinvoicedata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                      width: width * 0.12,
                      child: Image.asset(
                        'assets/payment.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Text(KeyValues.payment,
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
                                errorBuilder: (context, obj, st) => Icon(
                                      Icons.person,
                                      size: 35,
                                      color: Colors.white,
                                    )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
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
                  height: height * 0.7,
                  child: isDataFetched
                      ? listPayment.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: listPayment.length,
                              itemBuilder: (c, i) =>
                                  paymentsContainer(width, height, i),
                            )
                          : Center(
                              child: Text('No Data'),
                            )
                      : Center(
                          child: CircularProgressIndicator(),
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

  Widget paymentsContainer(double width, double height, int i) {
    return GestureDetector(
      onTap: () {
        print('Payment info ====' + listPayment[i].toString());
        Navigator.pushNamed(
          context,
          PaymentDetailScreen.id,
          arguments: PaymentArgument(
            Invoiceid: listPayment[i]['invoiceid'].toString(),
            paymentid: listPayment[i]['id'].toString(),
          ),
        );
      },
      child: Container(
          margin: EdgeInsets.only(bottom: height * 0.015),
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.01),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(6)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.contact_page_outlined,
                        size: 15,
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Text(
                          listPayment[i]['id'].toString() +
                              "# INV-" +
                              listPayment[i]['invoiceid'].toString(),
                          style: ColorCollection.titleStyle2),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.005,
                  ),
                  Text(listPayment[i]['Invoice_name'].toString(),
                      style: ColorCollection.subTitleStyle),
                  SizedBox(
                    height: height * 0.005,
                  ),
                  Row(
                    children: [
                      Text('${KeyValues.date}- ',
                          style: ColorCollection.subTitleStyle2),
                      Text(listPayment[i]['date'].toString(),
                          style: ColorCollection.subTitleStyle),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${KeyValues.mode} : ' +
                        listPayment[i]['paymentmode_name'].toString(),
                    style: ColorCollection.titleStyle,
                  ),
                  SizedBox(height: height * 0.005),
                  Row(
                    children: [
                      Text('\$', style: ColorCollection.titleStyleGreen2),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Text(listPayment[i]['amount'].toString(),
                          style: ColorCollection.titleStyleGreen2),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
