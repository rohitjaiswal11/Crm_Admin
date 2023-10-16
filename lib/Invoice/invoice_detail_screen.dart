// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, must_be_immutable, avoid_print, import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Invoice/invoiceView.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/routesArguments.dart';
import 'package:lbm_crm/util/separator_line.dart';

import '../LBM_Plugin/lbmplugin.dart';
import 'package:marquee_widget/marquee_widget.dart';

class InvoiceDetailScreen extends StatefulWidget {
  static const id = '/invoiceDetails';
  PageArgument pageArgument;
  String? InvocieNumber;
  String? LeadID;
  String? Title;
  String? Invoiceid;
  InvoiceDetailScreen({required this.pageArgument}) {
    InvocieNumber = pageArgument.InvoiceNumber;
    LeadID = pageArgument.Staff_id;
    Title = pageArgument.Title;
    Invoiceid = pageArgument.Invoiceid;
  }

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailsScrenState();
}

class _InvoiceDetailsScrenState extends State<InvoiceDetailScreen> {
  List PaymentList = [];
  List PaidList = [];
  var isDataFetched = false;
  var isDataFetcheded = false;
  List listProposal = [];
  double totalpaymentpaid = 0.0, balance = 0.0;

  @override
  void initState() {
    super.initState();
    getproposalinvoicedata();
    getinvoicepaymentitem();
    getinvoicepayment();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getproposalinvoicedata() async {
    print(widget.LeadID);
    print(widget.Invoiceid);
    print(widget.Title);
    final paramDic = {
      "staff_id":CommanClass.StaffId,
      "type": 'invoices',
      "invoiceid": widget.Invoiceid,
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetProposalInvoice, paramDic, "Get", Api_Key_by_Admin);
    // var data = json.decode(response.body);
    print("resp == " + response.statusCode.toString());

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("abcd == " + data.toString());

      if (data['status'] == 1) {
        setState(() {
          listProposal = data['data'];

          isDataFetcheded = true;
        });
      } else {
        isDataFetcheded = true;
        listProposal.clear();
      }
    } else {
      setState(() {
        isDataFetcheded = true;
        listProposal.clear();
      });
    }
  }

  //Invoice payment API Hit
  Future<void> getinvoicepaymentitem() async {
    final paramDic = {
      "staff_id":CommanClass.StaffId,
      "type": widget.Title!.toLowerCase(),
      "invoiceid": widget.Invoiceid,
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetProposalInvoice, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    PaymentList.clear();
    if (response.statusCode == 200) {
      setState(() {
        PaymentList = data['data'];

        print('Payment List Data ===' + PaymentList.toString());
        for (int i = 0; i < PaymentList.length; i++) {
          print(PaymentList[0]['total_tax'] == null ? '1' : '0');
        }
        isDataFetched = true;
      });
    } else {
      setState(() {
        isDataFetched = true;
        print('Failed Payment List ' + response.statusCode.toString());
      });
    }
  }

  Future<void> getinvoicepayment() async {
    final paramDic = {
      "staff_id":CommanClass.StaffId,
      "type": widget.Title!.toLowerCase(),
      "invoiceid": widget.Invoiceid,
      "ispaid": 'True',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetProposalInvoice, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    PaidList.clear();
    if (response.statusCode == 200) {
      setState(() {
        PaidList = data['data'];
        print('Paid List ===' + PaidList.toString());

        for (int i = 0; i < PaidList.length; i++) {
          totalpaymentpaid =
              totalpaymentpaid + double.parse(PaidList[i]['amount'].toString());
          print(totalpaymentpaid);
        }
        isDataFetched = true;
      });
    } else {
      setState(() {
        isDataFetched = true;
        print('Failed Paid List ' + response.statusCode.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log(listProposal.toString());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                          height: height * 0.08,
                          width: width * 0.12,
                          child: Image.asset(
                            'assets/second.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Text(
                          KeyValues.invoices,
                          style: ColorCollection.screenTitleStyle,
                        ),
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: height * 0.18),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.1, vertical: height * 0.009),
                      decoration: BoxDecoration(
                        color: ColorCollection.darkGreen,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'INV -' + (widget.InvocieNumber ?? ''),
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
            !isDataFetched
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : listProposal.isEmpty
                    ? Center(
                        child: Text('No Data'),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      KeyValues.invocieDate,
                                      style: ColorCollection.darkGreenStyle,
                                    ),
                                    Text(
                                      KeyValues.dueDate,
                                      style: ColorCollection.darkGreenStyle,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      isDataFetched == false
                                          ? ' '
                                          : listProposal.isNotEmpty
                                              ? listProposal[0]['date']
                                                  .toString()
                                              : '',
                                      style: ColorCollection.subTitleStyle2,
                                    ),
                                    Text(
                                      isDataFetched == false
                                          ? ' '
                                          : listProposal.isNotEmpty
                                              ? listProposal[0]['duedate']
                                                  .toString()
                                              : '',
                                      style: ColorCollection.subTitleStyle2,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      KeyValues.shippingAddress,
                                      style: ColorCollection.darkGreenStyle,
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    SizedBox(
                                      width: width * 0.3,
                                      child: Text(
                                        '${KeyValues.address} : ' +
                                            (isDataFetched == false
                                                ? ' '
                                                : listProposal.isNotEmpty
                                                    ? (listProposal[0][
                                                                    'shipping_street'] ??
                                                                '')
                                                            .toString() +
                                                        ' '
                                                    : '') +
                                            (isDataFetched == false
                                                ? ' '
                                                : listProposal.isNotEmpty
                                                    ? (listProposal[0][
                                                                    'shipping_city'] ??
                                                                '')
                                                            .toString() +
                                                        ' '
                                                    : '') +
                                            (isDataFetched == false
                                                ? ' '
                                                : listProposal.isNotEmpty
                                                    ? (listProposal[0][
                                                                    'shipping_state'] ??
                                                                '')
                                                            .toString() +
                                                        ' '
                                                    : ''),
                                        style: ColorCollection.subTitleStyle2,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.003,
                                    ),
                                    Text(
                                      '${KeyValues.country} : ' +
                                          (isDataFetched == false
                                              ? ' '
                                              : listProposal.isNotEmpty
                                                  ? (listProposal[0][
                                                                  'shipping_countryname'] ??
                                                              '-')
                                                          .toString() +
                                                      ' '
                                                  : ' ') +
                                          (isDataFetched == false
                                              ? ' '
                                              : listProposal.isNotEmpty
                                                  ? (listProposal[0][
                                                                  'shipping_zip'] ??
                                                              '-')
                                                          .toString() +
                                                      ' '
                                                  : ' '),
                                      style: ColorCollection.subTitleStyle2,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      KeyValues.billingAddress,
                                      style: ColorCollection.darkGreenStyle,
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Tooltip(
                                      message: (isDataFetched == false
                                              ? ' '
                                              : listProposal.isNotEmpty
                                                  ? (listProposal[0][
                                                                  'billing_street'] ??
                                                              '')
                                                          .toString() +
                                                      ''
                                                  : ' ') +
                                          (isDataFetched == false
                                              ? ' '
                                              : listProposal.isNotEmpty
                                                  ? (listProposal[0][
                                                                  'billing_city'] ??
                                                              '')
                                                          .toString() +
                                                      ' '
                                                  : ' ') +
                                          (isDataFetched == false
                                              ? ' '
                                              : listProposal.isNotEmpty
                                                  ? (listProposal[0][
                                                                  'billing_state'] ??
                                                              '')
                                                          .toString() +
                                                      ' '
                                                  : ' '),
                                      child: SizedBox(
                                          width: width * 0.3,
                                          child: Text(
                                            '${KeyValues.address} : ' +
                                                (isDataFetched == false
                                                    ? ' '
                                                    : listProposal.isNotEmpty
                                                        ? (listProposal[0][
                                                                        'billing_street'] ??
                                                                    '')
                                                                .toString() +
                                                            ''
                                                        : ' ') +
                                                (isDataFetched == false
                                                    ? ' '
                                                    : listProposal.isNotEmpty
                                                        ? (listProposal[0][
                                                                        'billing_city'] ??
                                                                    '')
                                                                .toString() +
                                                            ' '
                                                        : ' ') +
                                                (isDataFetched == false
                                                    ? ' '
                                                    : listProposal.isNotEmpty
                                                        ? (listProposal[0][
                                                                        'billing_state'] ??
                                                                    '')
                                                                .toString() +
                                                            ' '
                                                        : ' '),
                                            style:
                                                ColorCollection.subTitleStyle2,
                                          )),
                                    ),
                                    SizedBox(
                                      height: height * 0.003,
                                    ),
                                    Text(
                                      '${KeyValues.country} : ' +
                                          (isDataFetched == false
                                              ? ' '
                                              : listProposal.isNotEmpty
                                                  ? (listProposal[0][
                                                                  'billing_countryname'] ??
                                                              '-')
                                                          .toString() +
                                                      ' '
                                                  : ' ') +
                                          (isDataFetched == false
                                              ? ' '
                                              : listProposal.isNotEmpty
                                                  ? (listProposal[0][
                                                                  'billing_zip'] ??
                                                              '-')
                                                          .toString() +
                                                      " "
                                                  : ' '),
                                      style: ColorCollection.subTitleStyle2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
            SizedBox(
              height: height * 0.04,
            ),
            !isDataFetched
                ? SizedBox(
                    height: height * 0.58,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : PaymentList.isEmpty
                    ? SizedBox(
                        height: height * 0.6 +
                            (listProposal.isEmpty ? height * 0.09 : 0),
                        child: Center(
                          child: Text('No Data'),
                        ),
                      )
                    : Container(
                        height: height * 0.6 +
                            (listProposal.isEmpty ? height * 0.09 : 0),
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.06,
                        ),
                        width: width,
                        decoration: kContaierDeco.copyWith(
                            color: ColorCollection.containerC),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Text(
                              '# ${KeyValues.items}',
                              style: ColorCollection.titleStyle2,
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            SizedBox(
                              height: height * 0.23,
                              child: PaymentList.isEmpty
                                  ? Center(
                                      child: Text('No Data'),
                                    )
                                  : ListView.builder(
                                      padding:
                                          EdgeInsets.only(top: height * 0.01),
                                      itemCount: PaymentList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (c, i) => invoicesDetailContainer(
                                          width,
                                          height,
                                          PaymentList[i]['description']
                                              .toString(),
                                          PaymentList[i]['qty'].toString(),
                                          ((double.tryParse(PaymentList[i]['rate'].toString()) ??
                                                      0.0) *
                                                  ((double.tryParse(
                                                          PaymentList[i]['qty']
                                                              .toString()) ??
                                                      0.0)))
                                              .toString(),
                                          PaymentList[0]['total_tax'] == null
                                              ? '0 %'
                                              : PaymentList[i]
                                                          ['total_tax']
                                                      .toString() +
                                                  ' %',
                                          PaymentList[i]['long_description']
                                              .toString(),
                                          i + 1)),
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            MySeparator(
                              color: ColorCollection.backColor,
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${KeyValues.subTotal} :',
                                      style: ColorCollection.subTitleStyle2,
                                    ),
                                    SizedBox(
                                      height: height * 0.007,
                                    ),
                                    Text(
                                      '${KeyValues.total} :',
                                      style: ColorCollection.subTitleStyle2,
                                    ),
                                    SizedBox(
                                      height: height * 0.007,
                                    ),
                                    Text(
                                      '${KeyValues.totalPaid} :',
                                      style: ColorCollection.subTitleStyle2,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      !isDataFetched
                                          ? ''
                                          : '\$' +
                                              (listProposal.isEmpty
                                                  ? ''
                                                  : listProposal[0]['subtotal']
                                                      .toString()),
                                      style: ColorCollection.titleStyle,
                                    ),
                                    SizedBox(
                                      height: height * 0.007,
                                    ),
                                    Text(
                                      !isDataFetched
                                          ? ''
                                          : '\$' +
                                              (listProposal.isEmpty
                                                  ? ''
                                                  : listProposal[0]['total']
                                                      .toString()),
                                      style: ColorCollection.titleStyle,
                                    ),
                                    SizedBox(
                                      height: height * 0.007,
                                    ),
                                    Text(
                                      !isDataFetched
                                          ? ''
                                          : '\$' +
                                              (totalpaymentpaid.toString()),
                                      style: ColorCollection.titleStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            MySeparator(
                              color: ColorCollection.backColor,
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: height * 0.05,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                ColorCollection.titleColor)),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, InvoiceView.id,
                                          arguments: Proposalinvoice(
                                              url: 'https://' +
                                                  APIClasses.BaseURL +
                                                  '/crm/invoice/' +
                                                  listProposal[0]['id']
                                                      .toString() +
                                                  '/' +
                                                  listProposal[0]['hash']
                                                      .toString(),
                                              Title: 'Invoice View'));
                                    },
                                    child: Text(KeyValues.viewPdf,
                                        style: ColorCollection.buttonTextStyle),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget invoicesDetailContainer(double width, double height, String name,
      String qty, String amount, String igst, String company, int number) {
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.015),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          color: Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$number.', style: ColorCollection.titleStyleGreen2),
          SizedBox(
            width: width * 0.01,
          ),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: width*0.3,
                  child: Marquee(
                    child: Text(
                      name,
                      style: ColorCollection.titleStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Text(
                  '${KeyValues.qty} : $qty',
                  style: ColorCollection.subTitleStyle2,
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                SizedBox(
                  width: width * 0.4,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(company, style: ColorCollection.subTitleStyle2),
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('${KeyValues.amount} : ',
                      style: ColorCollection.subTitleStyle2),
                  Text(
                    amount,
                    style: ColorCollection.titleStyle,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.005,
              ),
              Row(
                children: [
                  Text('${KeyValues.igst} : ',
                      style: ColorCollection.subTitleStyle2),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Text(
                    igst,
                    style: ColorCollection.titleStyle,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
