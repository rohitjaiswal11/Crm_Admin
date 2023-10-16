// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, must_be_immutable, import_of_legacy_library_into_null_safe, avoid_print, prefer_if_null_operators

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Invoice/add_invoice_screen.dart';
import 'package:lbm_crm/Invoice/invoice_detail_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/routesArguments.dart';

import '../LBM_Plugin/lbmplugin.dart';
import 'package:marquee_widget/marquee_widget.dart';

import '../util/ToastClass.dart';

class InvoiceScreen extends StatefulWidget {
  static const id = '/invoices';

  @override
  State<InvoiceScreen> createState() => _InvoicesScrenState();
}

class _InvoicesScrenState extends State<InvoiceScreen> {
  List listProposal = [];
  var isDataFetched = false;
  bool isLoading = false;
  late String limit;
  List invoice_status = [];
  String? status;
  Map dataHeader = {};
  //get the proposal or invoice data by api
  Future<void> getproposalinvoicedata({String? search}) async {
    // setState(() {
    //   isDataFetched = false;
    // });

    final paramDic = {
      "staff_id": CommanClass.StaffId,
      "type": 'invoices',
      "order_by": 'desc',
      if (limit != 'All') 'limit': '$limit',
      if (search != null && search.isNotEmpty) 'search': '$search',
      if (status != null) 'status': '$status'
    };
    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.GetProposalInvoice, paramDic, "Get", Api_Key_by_Admin);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          if (data['status'] != true) if (data['status'].toString() != '1') {
            print('data ==> $data');
            ToastShowClass.toastShow(
                null, data['message'] ?? 'Failed to Load Data', Colors.red);

            setState(() {
              isLoading = false;
            });
          }
        } catch (e) {
          print('e-- > $e');

          setState(() {
            isLoading = false;
          });

          setState(() {
            listProposal.clear();
            isDataFetched = true;
          });
          ToastShowClass.toastShow(null, 'Failed to Load Data', Colors.red);
        }
        log('Invoice Data' + data.toString());

        setState(() {
          isLoading = false;
        });

        setState(() {
          listProposal = data['data'];
          dataHeader = data['invoice'];
          invoice_status = data['invoice_status'];
          invoice_status.insert(0, {'statusName': 'All'});
          isDataFetched = true;
        });
      } else {
        print('else -- ');

        setState(() {
          isLoading = false;
        });

        setState(() {
          listProposal.clear();
          isDataFetched = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print('e-- > $e');
      setState(() {
        listProposal.clear();
        isDataFetched = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      limit = CommanClass.limitList[2];
    });
    getproposalinvoicedata();
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty || text == '') {
      getproposalinvoicedata();
    } else {
      getproposalinvoicedata(search: text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // print('invoice List ====' + listProposal.length.toString());
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorCollection.backColor,
          child: Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            Navigator.pushNamed(context, AddInvoiceScreen.id)
                .then((value) => getproposalinvoicedata());
          },
        ),
        backgroundColor: ColorCollection.grey,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height * 0.15,
                decoration: BoxDecoration(
                  color: ColorCollection.backColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
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
                height: height * 0.01,
              ),
              Container(
                margin: EdgeInsets.only(top: height * 0.0),
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
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: height * 0.06),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.06,
                    ),
                    width: width,
                    decoration:
                        kContaierDeco.copyWith(color: ColorCollection.containerC),
                    child: isDataFetched
                        ? Column(children: [
                            SizedBox(
                              height: height * 0.04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: height * 0.06,
                                  width: width * 0.5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: height * 0.06,
                                        width: width * 0.4,
                                        child: TextFormField(
                                          onChanged: onSearchTextChanged,
                                          decoration: InputDecoration(
                                            hintText: 'Search Invoice',
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: width * 0.02,
                                                vertical: height * 0.01),
                                            hintStyle: TextStyle(
                                                color: Colors.grey, fontSize: 12),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.06,
                                        width: width * 0.09,
                                        decoration: BoxDecoration(
                                            color: ColorCollection.darkGreen,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: IconButton(
                                          onPressed: () {
                                            FocusManager.instance.primaryFocus!
                                                .unfocus();
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
                                 width: width * 0.25,
                                  decoration: kDropdownContainerDeco,
                                  child: DropdownButtonFormField<String>(
                                    hint: Text(KeyValues.nothingSelected),
                                    style: ColorCollection.titleStyle,
                                  //  isDense: false,
                                    elevation: 8,
                                    isExpanded: true,
                                    iconSize: 15,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: width * 0.04),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade100,
                                            width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade100,
                                            width: 2),
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
                                      getproposalinvoicedata();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: height * 0.55,
                                child: listProposal.isNotEmpty
                                    ? ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            vertical: height * 0.05),
                                        itemCount: listProposal.length,
                                        itemBuilder: (c, i) =>
                                            invoicesContainer(width, height, i),
                                      )
                                    : Center(
                                        child: Text('No Data'),
                                      )),
                            SizedBox(height: height * 0.01)
                          ])
                        : SizedBox(
                            height: height * 0.75,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.005),
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
        log(listProposal[index].toString());
        Navigator.pushNamed(
          context,
          InvoiceDetailScreen.id,
          arguments: PageArgument(
              Staff_id: listProposal[index]['addedfrom'].toString(),
              Title: 'payment',
              Invoiceid: listProposal[index]['id'].toString(),
              InvoiceNumber: listProposal[index]['number'].toString()),
        );
        print('INV ID' + listProposal[index]['id'].toString());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.015),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.01),
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
                Row(
                  children: [
                    Icon(Icons.contact_page_outlined),
                    SizedBox(width: width * 0.01),
                    SizedBox(
                      width: width * 0.35,
                      child: Marquee(
                        child: Text(
                            listProposal[index]['prefix'].toString() +
                                listProposal[index]['number'].toString() +
                                " " +
                                (listProposal[index]['Invoice_name'] ?? ''),
                            style: ColorCollection.titleStyle2),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                        '${KeyValues.dueAmount} :' +
                            (listProposal[index]['currency_name'] == null
                                ? ''
                                : listProposal[index]['currency_name']
                                        .toString() +
                                    "-"),
                        style: ColorCollection.subTitleStyle2),
                    Text(
                        listProposal[index]['duepayment'] == null
                            ? ''
                            : listProposal[index]['duepayment'].toString(),
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
                    listProposal[index]['status_name'] == null
                        ? ''
                        : listProposal[index]['status_name'].toString(),
                    style: ColorCollection.titleStyle.copyWith(
                        color: listProposal[index]['status_name'] == 'UNPAID'
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
                        ((listProposal[index]['currency_name'] == null
                                        ? ''
                                        : listProposal[index]
                                            ['currency_name']) +
                                    listProposal[index]['total'] ==
                                null
                            ? ''
                            : listProposal[index]['total']),
                    style: ColorCollection.subTitleStyle2,
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Text(
                    '${KeyValues.date}-' +
                        (listProposal[index]['datecreated'] == null
                            ? ''
                            : listProposal[index]['datecreated'].toString()),
                    style: ColorCollection.subTitleStyle2,
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Text(
                      '${KeyValues.dueDate}-' +
                          (listProposal[index]['duedate'] == null
                              ? ''
                              : listProposal[index]['duedate'].toString()),
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
        setState(() {
          status = title == 'All' ? null : id;
        });
        ToastShowClass.toastShow(context, 'Loading', Colors.green);
        await getproposalinvoicedata();
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
            Text('\$.$amount', style: ColorCollection.titleStyle2),
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
    );
  }
}
