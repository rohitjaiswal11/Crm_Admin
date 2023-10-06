// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, import_of_legacy_library_into_null_safe, avoid_print, prefer_if_null_operators

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Proposals/add_new_proposals.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';

import '../util/ToastClass.dart';

class ProposalScreen extends StatefulWidget {
  static const id = '/Proposals';

  @override
  State<ProposalScreen> createState() => _ProposalScrenState();
}

class _ProposalScrenState extends State<ProposalScreen> {
  List listProposal = [];
  var isDataFetched = false;
  late String limit;
  @override
  void initState() {
    setState(() {
      limit = CommanClass.limitList[2];
    });
    super.initState();
    getproposalinvoicedata();
  }

//get the proposal or invoice data by api
  Future<void> getproposalinvoicedata({String? search}) async {
    setState(() {
      isDataFetched = false;
    });
    final paramDic = {
      "staff_id": CommanClass.StaffId,
      "type": 'proposals',
      if (limit != 'All') 'limit': '$limit',
      "order_by": 'desc',
      if (search != null && search.isNotEmpty) 'search': '$search',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetProposalInvoice, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] != true) if (data['status'].toString() != '1') {
          print('here');
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Load Data', Colors.red);
        }
      } catch (e) {
        ToastShowClass.toastShow(null, 'Failed to Load Data', Colors.red);
      }
      setState(() {
        listProposal = data['data'];
        isDataFetched = true;
      });
    } else {
     setState(() {
        listProposal.clear();
      isDataFetched = true;
     });
    }
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          Navigator.pushNamed(context, AddNewProposalScreen.id)
              .then((value) => getproposalinvoicedata());
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
                        'assets/third.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Text(KeyValues.proposals,
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
                SizedBox(height: height * 0.02),
              Row(
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
                              hintText: 'Search Proposal',
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
                        getproposalinvoicedata();
                      },
                    ),
                  ),
                ],
              ),  SizedBox(height: height * 0.02),
             
                SizedBox(
                  height: height * 0.65,
                  child: isDataFetched == false
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : listProposal.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.only(bottom: height * 0.1),
                              itemCount: listProposal.length,
                              itemBuilder: (c, i) => proposalContainer(
                                width: width,
                                height: height,
                                index: i,
                              ),
                            )
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

  Widget proposalContainer({
    required double width,
    required double height,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AddNewProposalScreen.id,
          arguments: listProposal[index],
        ).then((value) =>
            getproposalinvoicedata()); // Navigator.pushNamed(context, ProposalDetailScreen.id);
        // log(listProposal[index].toString());
        // Navigator.of(context).pushNamed(InvoiceView.id,
        //     arguments: Proposalinvoice(
        //         url: 'https://' +
        //             APIClasses.BaseURL +
        //             '/proposal/' +
        //             listProposal[index]['id'].toString() +
        //             '/' +
        //             listProposal[index]['hash'].toString(),
        //         Title: 'Proposal View'));
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
                      SizedBox(
                        width: width * 0.4,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            'PRO-' +
                                listProposal[index]['id'].toString() +
                                " " +
                                listProposal[index]['subject'].toString(),
                            style: ColorCollection.titleStyle2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${KeyValues.openTill} : ' +
                        listProposal[index]['open_till'].toString(),
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
                        listProposal[index]['status_name'].toString(),
                        style: ColorCollection.titleStyle.copyWith(
                            color:
                                listProposal[index]['status_name'] == 'UNPAID'
                                    ? Colors.red
                                    : Colors.orange),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: width * 0.4,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        ' ${KeyValues.proposalTo} : ' +
                            (listProposal[index]['proposal_to'].toString()),
                        style: ColorCollection.smalltTtleStyle,
                      ),
                    ),
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
                        ((listProposal[index]['currency_name'] == null
                                ? ''
                                : listProposal[index]['currency_name']) +
                            "-" +
                            (listProposal[index]['total'] == null
                                ? ''
                                : listProposal[index]['total'])),
                    style: ColorCollection.smalltTtleStyle,
                  ),
                  Text(
                    '${KeyValues.date} -' +
                        (listProposal[index]['datecreated'].toString()),
                    style: ColorCollection.smalltTtleStyle,
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: ColorCollection.backColor,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: ColorCollection.titleStyleWhite2,
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
