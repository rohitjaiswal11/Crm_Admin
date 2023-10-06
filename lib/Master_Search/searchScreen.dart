// ignore_for_file: file_names, prefer_const_constructors, use_key_in_widget_constructors, import_of_legacy_library_into_null_safe, non_constant_identifier_names, avoid_print
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Customer/CustomerDetail/customer_detail_screen.dart';
import 'package:lbm_crm/Estimates/estimates_view.dart';
import 'package:lbm_crm/Invoice/invoiceView.dart';
import 'package:lbm_crm/Invoice/invoice_detail_screen.dart';
import 'package:lbm_crm/Payments/payment_detail_screen.dart';
import 'package:lbm_crm/Projects/project_details_screen.dart';
import 'package:lbm_crm/Tasks/task_detail_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/routesArguments.dart';
import 'package:lbm_crm/util/storage_manger.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class SearchScreen extends StatefulWidget {
  static const id = 'searchScreen';
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  List PassCustomer = [];
  List MasterSearch = [];
  List customernew = [];
  List customersearch = [];
  List datacustomer = [];
  List dataHeader = [];
  List passData = [];
  var isDataFetched = false;
  bool isLoading = false;
  TextEditingController textcontroller = TextEditingController();
  SpeechToText _speechToText = SpeechToText();

// Each time to start a speech recognition session
  Future<void> _startListening() async {
    log(CommanClass.speechEnabled.toString());
    await _speechToText.listen(
        cancelOnError: true,
        listenMode: ListenMode.search,
      onSoundLevelChange: (val){
        log(val.toString());
        setState(() {
          
        });
      },
        onResult: (SpeechRecognitionResult result) {
          log(result.recognizedWords.toString());
          textcontroller.text = result.recognizedWords;

          onSearchTextChanged(result.recognizedWords);
        });
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  // ignore: unused_element
  void _stopListening() async {
    await _speechToText.stop();

  }

  @override
  void dispose() {
    super.dispose();
    datacustomer = [];
    dataHeader = [];
_stopListening();
    isDataFetched = false;
    MasterSearch.clear();
    customernew.clear();
  }

  //search page open with focus textfield
  @override
  Widget build(BuildContext context) {
//    createTile(Customer friend) =>
    Icon cumSearch = Icon(
      Icons.cancel,
    );
    Widget cumSearchBar = TextField(
      autofocus: true,
      controller: textcontroller,
      onChanged: onSearchTextChanged,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: "Search ",
          hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 13)),
    );
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorCollection.backColor,
          title: cumSearchBar,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  _startListening();
                },
                icon: Icon(
                  Icons.mic,
                  color: _speechToText.isListening ? Colors.red : Colors.white,
                )),
            IconButton(
              onPressed: () {
                setState(() {
                  //click on cancel icon then change the icon to search icon, if again click then change the icon
                  if (cumSearch.icon == Icons.search) {
                    print("CANCE-----------1" 'Cancel');
                    cumSearch = Icon(Icons.cancel);
                    cumSearchBar = TextField(
                      onChanged: onSearchTextChanged,
                      autofocus: true,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: _speechToText.isListening ? 'Listening...' : "Search ",
                          hintStyle:
                              TextStyle(color: Colors.black38, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 0, vertical: 13)),
                    );
                  } else {
                    print("CANCE-----------2" 'Cancel');

                    cumSearch = Icon(Icons.search);
                    cumSearchBar = Text('Search');
                    setState(() {
                      textcontroller.clear();
                      onSearchTextChanged("");
                    });
                  }
                });
              },
              icon: cumSearch,
            ),
          ]),
      backgroundColor: Colors.white,

      //show all filter data in list view on sticky header
      body: ListView.builder(
          itemCount: MasterSearch.length,
          itemBuilder: (context, index) {
            print('performa invoice Data' +
                MasterSearch[0]['search_heading'].toString());
            var newlist = MasterSearch.where(
                (element) => element['search_heading'] == 'Invoices');
            print('New LIst ++++++' + newlist.toString());

            if (MasterSearch[index]['search_heading'] == 'Estimate Items') {
              return SizedBox();
            } else if (MasterSearch[index]['search_heading'] ==
                'Invoice Items') {
              return SizedBox();
            }

            return StickyHeader(
              header: Container(
                height: 50.0,
                color: ColorCollection.backColor,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  MasterSearch[index]['search_heading'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              content: Column(
                children: List<int>.generate(
                        MasterSearch[index]['result'].length, (i) => i)
                    .map((item) => Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(width: .2, color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (MasterSearch[index]['search_heading'] ==
                                      'Customers') {
                                    print("ID------------  " +
                                        MasterSearch[index]['result'][item]
                                            .toString());
                                    passData.clear();
                                    passData.add(
                                        MasterSearch[index]['result'][item]);
                                    Navigator.of(context).pushNamed(
                                        CustomerDetailScreen.id,
                                        arguments: passData);
                                  } else if (MasterSearch[index]
                                          ['search_heading'] ==
                                      'Proposals') {
                                    print("Proposal------------  " +
                                        MasterSearch[index]['result'][item]
                                                ['id']
                                            .toString() +
                                        MasterSearch[index]['result'][item]
                                                ['hash']
                                            .toString());
                                    Navigator.of(context).pushNamed(
                                        InvoiceView.id,
                                        arguments: Proposalinvoice(
                                            url: 'https://' +
                                                APIClasses.BaseURL +
                                                '/crm/proposal/' +
                                                MasterSearch[index]['result']
                                                        [item]['id']
                                                    .toString() +
                                                '/' +
                                                MasterSearch[index]['result']
                                                        [item]['hash']
                                                    .toString(),
                                            Title: 'Proposal View'));
                                  } else if (MasterSearch[index]
                                          ['search_heading'] ==
                                      'Invoices') {
                                    print('invoice Data' +
                                        MasterSearch[index]['result']
                                            .toString());
                                    Navigator.pushNamed(
                                        context, InvoiceDetailScreen.id,
                                        arguments: PageArgument(
                                            Staff_id: MasterSearch[index]
                                                ['result'][item]['addedfrom'],
                                            Title: 'payment',
                                            InvoiceNumber: MasterSearch[index]
                                                ['result'][item]['number'],
                                            Invoiceid: MasterSearch[index]
                                                ['result'][item]['id']));
                                  } else if (MasterSearch[index]
                                          ['search_heading'] ==
                                      'Projects') {
                                    // MasterSearch[index]['search_heading']==MasterSearch[index]['type']?
                                    print("ID------------  " +
                                        MasterSearch.length.toString() +
                                        MasterSearch[index]['result']
                                            .toString() +
                                        MasterSearch[index]['type']);
                                    //  :print("mom    ");
                                    passData.clear();
                                    passData.add(
                                        MasterSearch[index]['result'][item]);
                                    print(passData);
                                    Navigator.of(context).pushNamed(
                                        ProjectDetailScreen.id,
                                        arguments: passData);
                                  } else if (MasterSearch[index]
                                          ['search_heading'] ==
                                      'Tasks') {
                                    passData.clear();
                                    passData.add(
                                        MasterSearch[index]['result'][item]);
                                    print("T A S K ////////////" +
                                        passData.toString());
                                    setState(() {
                                      Navigator.of(context).pushNamed(
                                          TaskDetailScreen.id,
                                          arguments: passData);
                                    });
                                  } else if (MasterSearch[index]
                                          ['search_heading'] ==
                                      'Payments') {
                                    passData.clear();
                                    passData.add(
                                        MasterSearch[index]['result'][item]);
                                    print(passData[0]['id']);
                                    Navigator.of(context).pushNamed(
                                        PaymentDetailScreen.id,
                                        arguments: PaymentArgument(
                                            Invoiceid: passData[0]['invoiceid'],
                                            paymentid: passData[0]['id']));
                                  }
                                  // else if (MasterSearch[index]
                                  //         ['search_heading'] ==
                                  //     'Invoice Items') {
                                  //   passData.clear();
                                  //   passData.add(
                                  //       MasterSearch[index]['result'][item]);
                                  //   print('Invocie Items ' +
                                  //       passData.toString());
                                  //   //   Navigator.of(context).pushNamed(
                                  //   //       PaymentDetailScreen.id,
                                  //   //       arguments: PaymentArgument(
                                  //   //           Invoiceid: passData[0]
                                  //   //               ['invoiceid'],
                                  //   //           paymentid: passData[0]['id']));
                                  // }
                                  else if (MasterSearch[index]
                                          ['search_heading'] ==
                                      'Estimates') {
                                    print(('https://' +
                                        APIClasses.BaseURL +
                                        '/crm/estimate/' +
                                        MasterSearch[index]['result'][item]
                                                ['id']
                                            .toString() +
                                        '/' +
                                        MasterSearch[index]['result'][item]
                                                ['hash']
                                            .toString()));
                                    Navigator.pushNamed(
                                        context, EstimatesView.id,
                                        arguments: Proposalinvoice(
                                            url: 'https://' +
                                                APIClasses.BaseURL +
                                                '/crm/estimate/' +
                                                MasterSearch[index]['result']
                                                        [item]['id']
                                                    .toString() +
                                                '/' +
                                                MasterSearch[index]['result']
                                                        [item]['hash']
                                                    .toString()));
                                  } else if (MasterSearch[index]
                                          ['search_heading'] ==
                                      'Estimate Items') {
                                    passData.clear();
                                    passData.add(
                                        MasterSearch[index]['result'][item]);
                                    print('EStimate Items Data' +
                                        passData.toString());
                                    // Navigator.of(context).pushNamed(
                                    //     '/ProposalView',
                                    //     arguments: passData);
                                  }
                                },
                                child: Text(
                                  MasterSearch[index]['search_heading'] ==
                                          'Customers'
                                      ? MasterSearch[index]['result'][item]['company']
                                          .toString()
                                      : MasterSearch[index]['search_heading'] ==
                                              'Proposals'
                                          ? '#' +
                                              MasterSearch[index]['result']
                                                      [item]['id']
                                                  .toString() +
                                              ' - ' +
                                              MasterSearch[index]['result']
                                                      [item]['proposal_to']
                                                  .toString()
                                          : MasterSearch[index]['search_heading'] ==
                                                  'Invoices'
                                              ? 'INV - ' +
                                                  MasterSearch[index]['result']
                                                          [item]['number']
                                                      .toString() +
                                                  ' - ' +
                                                  MasterSearch[index]['result']
                                                          [item]['company']
                                                      .toString()
                                              : MasterSearch[index]
                                                          ['search_heading'] ==
                                                      'Projects'
                                                  ? MasterSearch[index]['result'][item]['id'].toString() +
                                                      ' - ' +
                                                      MasterSearch[index]['result'][item]['name'].toString()
                                                  : MasterSearch[index]['search_heading'] == 'Tasks'
                                                      ? MasterSearch[index]['result'][item]['name'].toString()
                                                      : MasterSearch[index]['search_heading'] == 'Payments'
                                                          ? 'INV - ' + MasterSearch[index]['result'][item]['number'].toString() + ' - ' + MasterSearch[index]['result'][item]['date'].toString()
                                                          : MasterSearch[index]['search_heading'] == 'Invoice Items'
                                                              ? 'INV - ' + MasterSearch[index]['result'][item]['id'].toString() + ' - ' + MasterSearch[index]['result'][item]['description'].toString()
                                                              : MasterSearch[index]['search_heading'] == 'Estimates'
                                                                  ? MasterSearch[index]['result'][item]['prefix'].toString() + ' - ' + MasterSearch[index]['result'][item]['number'].toString()
                                                                  : MasterSearch[index]['search_heading'] == 'Estimate Items'
                                                                      ? MasterSearch[index]['result'][item]['id'].toString() + ' - ' + MasterSearch[index]['result'][item]['description'].toString()
                                                                      : '',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            );
          }

//            child: isDataFetched == false
//                ? ShimmerList():liste,
          ),
    );
  }

  //Search all data fetch by server by using api
  void onSearchTextChanged(String value) async {
    final paramDic = {
      "search": value,
      "staffid": await SharedPreferenceClass.GetSharedData('staff_id'),
    };
    print("paramDic" + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetMasterSearch, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);
    MasterSearch.clear();
    if (response.statusCode == 200) {
      setState(() {
        MasterSearch = data['data'];
        print("DATA---------" + MasterSearch.toString());
      });
    } else {
      setState(() {});
    }
  }
}
