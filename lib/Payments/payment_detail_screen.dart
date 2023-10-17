// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, must_be_immutable, import_of_legacy_library_into_null_safe, prefer_adjacent_string_concatenation, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/routesArguments.dart';

import '../Plugin/lbmplugin.dart';

class PaymentDetailScreen extends StatefulWidget {
  static const id = '/PaymentDetail';
  String? Invoiceid;
  String? Paymentid;
  PaymentArgument paymentArgument;
  PaymentDetailScreen({required this.paymentArgument}) {
    Invoiceid = paymentArgument.Invoiceid!;
    Paymentid = paymentArgument.paymentid!;
  }
  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  var isDataFetched = false;
  List listProposal = [];
  List PaymentList = [];
  List PaidList = [];
  double totalpaymentpaid = 0.0, balance = 0.0;

  //fetch the invoice data on server by api
  Future<void> getproposalinvoicedata() async {
    final paramDic = {
      "staff_id": CommanClass.StaffId,
      "type": 'invoices',
      "invoiceid": widget.Invoiceid,
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetProposalInvoice, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        listProposal = data['data'];

        isDataFetched = true;
      });
    } else {
      listProposal.clear();

      isDataFetched = true;
    }
  }

  @override
  void initState() {
    super.initState();
    getproposalinvoicedata();
    getinvoicepayment();
  }

//fetch the payment info regarding invoice by api
  Future<void> getinvoicepayment() async {
    final paramDic = {
      "staff_id": CommanClass.StaffId,
      "type": 'payment',
      "invoiceid": widget.Invoiceid,
      "ispaid": 'True',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetProposalInvoice, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        PaidList = data['data'];
        for (int i = 0; i < PaidList.length; i++) {
          if (widget.Paymentid.toString() == PaidList[i]['id'].toString()) {
            PaymentList.add(PaidList[i]);
            print('Payment List ==>' + PaymentList.toString());
          }
          totalpaymentpaid =
              totalpaymentpaid + double.parse(PaidList[i]['amount'].toString());
        }
        isDataFetched = true;
      });
    } else {
      PaidList.clear();
      isDataFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    log(listProposal.toString());
    return Scaffold(
      backgroundColor: ColorCollection.grey,
      body: Column(
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
                    width: width * 0.15,
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
                              fit: BoxFit.fill, errorBuilder: (_, __, ___) {
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
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.14),
                height: height * 0.64,
                padding: EdgeInsets.only(
                  top: height * 0.23,
                  left: width * 0.06,
                  right: width * 0.06,
                ),
                width: width,
                decoration:
                    kContaierDeco.copyWith(color: ColorCollection.containerC),
                child: isDataFetched
                    ? PaymentList.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: PaymentList.length,
                            itemBuilder: (c, i) =>
                                paymentContainer(width, height, i))
                        : Center(
                            child: Text('No Data'),
                          )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Card(
                  margin: EdgeInsets.only(top: height * 0.027),
                  elevation: 30,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                          colors: [
                            darken(ColorCollection.backColor, 0.1),
                            lighten(ColorCollection.backColor, 0.1),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: width * 0.03, vertical: height * 0.025),
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05, vertical: height * 0.03),
                      width: width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54, width: 0.7),
                        borderRadius: BorderRadius.circular(10),
                        color: lighten(ColorCollection.backColor, 0.3),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade500),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * 0.35,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Text(
                                        '${KeyValues.paymentDate} : ',
                                        style: ColorCollection.darkGreenStyle,
                                      ),
                                      Text(
                                        isDataFetched == false
                                            ? ' '
                                            : listProposal.isNotEmpty
                                                ? listProposal[0]['date']
                                                    .toString()
                                                : '',
                                        style: ColorCollection.titleStyleWhite,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: width * 0.35,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${KeyValues.paymentMode} : ',
                                          style: ColorCollection.darkGreenStyle,
                                        ),
                                        Text(
                                          isDataFetched == false
                                              ? ' '
                                              : listProposal.isNotEmpty
                                                  ? (listProposal[0]
                                                          ['paymentmode_name']??'')
                                                      .toString()
                                                  : '',
                                          style:
                                              ColorCollection.titleStyleWhite,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.pin_drop,
                                color: Colors.black87,
                                size: 20,
                              ),
                              SizedBox(
                                width: width * 0.01,
                              ),
                              Text(
                                KeyValues.billingAddress,
                                style: ColorCollection.darkGreenStyle,
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.02),
                          Row(
                            children: [
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Text(
                                '${KeyValues.address} : ',
                                style: ColorCollection.titleStyleWhite,
                              ),
                              SizedBox(
                                width: width * 0.5,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                      isDataFetched == false
                                          ? ' '
                                          : listProposal.isNotEmpty
                                              ? listProposal[0]
                                                      ['billing_street']
                                                  .toString()
                                              : '',
                                      style: ColorCollection.titleStyleWhite),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.01),
                          SizedBox(
                            width: width * 0.65,
                            child: Text(
                              isDataFetched == false
                                  ? ' '
                                  : listProposal.isNotEmpty
                                      ? listProposal[0]['billing_city']
                                              .toString() +
                                          " " +
                                          listProposal[0]['billing_state']
                                              .toString()
                                      : '',
                              style: ColorCollection.titleStyleWhite,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Row(
                            children: [
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Text(
                                '${KeyValues.country} : ',
                                style: ColorCollection.titleStyleWhite,
                              ),
                              Text(
                                  isDataFetched == false
                                      ? ' '
                                      : listProposal.isNotEmpty
                                          ? listProposal[0]
                                                      ['billing_countryname']
                                                  .toString() +
                                              " " +
                                              listProposal[0]['billing_zip']
                                                  .toString()
                                          : '',
                                  style: ColorCollection.titleStyleWhite),
                            ],
                          ),
                          SizedBox(height: height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '# ${KeyValues.paymentReciept}',
                                style: ColorCollection.darkGreenStyle,
                              ),
                              SizedBox(
                                width: width * 0.4,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    '${KeyValues.amountDue}: ' +
                                        (isDataFetched == false
                                            ? ''
                                            : listProposal.isNotEmpty
                                                ? listProposal[0]
                                                            ['currency_name']
                                                        .toString() +
                                                    (' - ' +
                                                        (PaymentList.isEmpty
                                                            ? ' '
                                                            : PaymentList[0]
                                                                    ['duepay']
                                                                .toString()))
                                                : ''),
                                    style: ColorCollection.titleStyleWhite
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.07, vertical: height * 0.009),
                    decoration: BoxDecoration(
                      color: ColorCollection.darkGreen,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      isDataFetched == false
                          ? ' '
                          : listProposal.isNotEmpty
                              ? listProposal[0]['Invoice_name'].toString()
                              : '',
                      style: ColorCollection.titleStyleWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container paymentContainer(double width, double height, int i) {
    return Container(
        margin: EdgeInsets.only(bottom: height * 0.01),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.01),
        decoration: BoxDecoration(
            color: Color(0xFFF8F8F8),
            border: Border.all(color: Colors.grey.shade300),
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
                      '${i + 1} # INV-' +
                          (isDataFetched == false
                              ? ''
                              : PaymentList[i]['invoiceid'] ?? ''),
                      style: ColorCollection.titleStyle2,
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Text(PaymentList[i]['status_name'] ?? 'NULL',
                    style: ColorCollection.subTitleStyle),
                SizedBox(
                  height: height * 0.005,
                ),
                Row(
                  children: [
                    Text(
                      '${KeyValues.date}- ',
                      style: ColorCollection.subTitleStyle2,
                    ),
                    Text(
                        isDataFetched == false
                            ? ''
                            : PaymentList[i]['date'] ?? '',
                        style: ColorCollection.subTitleStyle),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Text(
                    '${KeyValues.paymentAmount} - ' +
                        (isDataFetched == false
                            ? ''
                            : listProposal.isNotEmpty
                                ? (listProposal[i]['currency_name'] ?? '') +
                                    ' - ' +
                                    PaymentList[i]['amount']
                                : ''),
                    style: ColorCollection.darkGreenStyle2),
                SizedBox(height: height * 0.015),
                Text(
                    '${KeyValues.invoiceAmount} ' +
                        (isDataFetched == false
                            ? ''
                            : listProposal.isNotEmpty
                                ? ('- ' +
                                        (listProposal[0]['currency_name'] ??
                                            '')) +
                                    ' - ' +
                                    listProposal[i]['total']
                                : ''),
                    style: ColorCollection.darkGreenStyle2)
              ],
            )
          ],
        ));
  }
}
