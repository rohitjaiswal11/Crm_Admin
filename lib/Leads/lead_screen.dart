// ignore_for_file: prefer_const_constructors, prefer_final_fields, non_constant_identifier_names, must_be_immutable, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables,, avoid_print, import_of_legacy_library_into_null_safe, unnecessary_null_comparison, prefer_if_null_operators, prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:lbm_crm/Leads/add_new_lead.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/Leads/lead_detail_screen.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/storage_manger.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadScreen extends StatefulWidget {
  String? leadStatus;
  LeadScreen({this.leadStatus});

  static const id = 'leadScreen';

  @override
  _LeadScreenState createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {
  Widget appBarTitle = Text(
    KeyValues.leads,
    style: ColorCollection.screenTitleStyle,
  );
  Icon cumSearch = Icon(
    Icons.search,
    color: Colors.white,
  );
  List<LeadsDetails> crmleadlist = [];
  List<LeadsDetails> newcrmleadlist = [];
  late String limit;
  int start = 1;
  List listCrm = [];

  var isDataFetched = false;
  String date_added = '';
  String date_assigned = '';
  String date_lastcontact = '';
  String date_converted = '';
  String date_laststatus = '';
  bool isLoading = false;
  bool loadingLeadData = false;
  List searchlist = [];
  List statusList = [];
  List selctedListData = [];
  var additionalFiltersvalue;
  var dropdownValue;

  @override
  void initState() {
    setState(() {
      limit = CommanClass.limitList[2];
    });
    super.initState();

    viewCRMDetail();
  }

  viewCRMDetail({String? search}) async {
    setState(() {
      isDataFetched=false;
    });
    if (CommanClass.isFilter == true) {
      setState(() {
        date_added = CommanClass.DateAdded;
        date_assigned = CommanClass.DateAssigned;
        date_lastcontact = CommanClass.DateLastContact;
        date_converted = CommanClass.DateConverted;
        date_laststatus = CommanClass.DateLastStatus;

        start = 1;
      });
    }
    listCrm.clear();
    newcrmleadlist.clear();
    crmleadlist.clear();
    final paramDic = {
      "staff_id": CommanClass.StaffId,
      "date_added": date_added,
      "date_assigned": date_assigned,
      "date_lastcontact": date_lastcontact,
      "date_converted": date_converted,
      "date_laststatus": date_laststatus,
      "order_by": 'desc',
      if (limit != 'All') 'limit': '$limit',

//      "start_date":"2020-01-10",
//      "end_date":"2020-01-30",
//      "status":"1",
      //"lead_id":"",
    };
    print('params == >' + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.LeadShow, paramDic, "Get", Api_Key_by_Admin);
    log('response == > ' + response.body.toString());
    var data = json.decode(response.body);
    log(data.toString());
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        print(
            '${data['status'].toString() != '1'}  ${data['status'].toString().runtimeType}');
        if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Load Data', Colors.red);
        }
      } catch (e) {
        ToastShowClass.toastShow(null, 'Failed to Load Data', Colors.red);
      }
      if (data['status'].toString() != false) {
        listCrm = data['data'];
        for (int i = 0; i < listCrm.length; i++) {
          crmleadlist.add(
            LeadsDetails(
              name: listCrm[i]['name'],
              id: listCrm[i]['id'],
              phoneNumber: listCrm[i]['phonenumber'],
              status: listCrm[i]['status_name'],
              isPublic: listCrm[i]['is_public'],
              junk: listCrm[i]['junk'],
              lost: listCrm[i]['lost'],
              companyName: listCrm[i]['company'],
              addedDate: listCrm[i]['dateadded'],
              lastDate: listCrm[i]['lastcontact'],
            ),
          );
          if (listCrm[i]['status_name'] != null &&
              statusList.contains(listCrm[i]['status_name']) == false) {
            statusList.add(listCrm[i]['status_name']);
          }
        }
        if (widget.leadStatus != null) {
          crmleadlist.removeWhere((element) {
            if (element.status != null) {
              if (element.status.toUpperCase() !=
                  widget.leadStatus!.toString().split('(')[0].toUpperCase()) {
                print(element.status +
                    '  <=> ${widget.leadStatus!.toString().split('(')[0].toUpperCase()}  ++ ifCase');
                return true;
              } else {
                print(element.status +
                    '  <=> ${widget.leadStatus!.toString().split('(')[0].toUpperCase()}  ++ elseCase');
                return false;
              }
            }
            return true;
          });
          if ((crmleadlist.isEmpty &&
                  int.parse(widget.leadStatus
                          .toString()
                          .split('( ')[1]
                          .split(' )')[0]) >
                      0) ||
              int.parse(widget.leadStatus
                      .toString()
                      .split('( ')[1]
                      .split(' )')[0]) >
                  crmleadlist.length) {
            print('Entered in if mpty Case ');
            setState(() {
              limit = 'All';
            });
            viewCRMDetail();
            return;
          }
        }
        print('crm leadList Length = ' + crmleadlist.length.toString());
        setState(() {
          newcrmleadlist = List.from(crmleadlist);
          isDataFetched = true;
        });
      } else {
        setState(() {
          isDataFetched = true;
        });
        print(" 1 " + response.statusCode.toString());
      }
    } else {
      setState(() {
        isDataFetched = true;
      });
      print('Not Found = ' + response.statusCode.toString());
    }
  }

  LeadSearch(String text) async {
    final paramDic = {
      "keyword": text,
      "order_by": 'desc',
    };
    print("dtatat " + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.LeadSearch, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    log(data.toString());
    if (response.statusCode == 200) {
      if (data['status'] != false) {
        searchlist.clear();
        searchlist = data['data'];
        print(searchlist.toString());
        crmleadlist.clear();
        setState(() {
          for (int i = 0; i < searchlist.length; i++) {
            crmleadlist.add(
              LeadsDetails(
                name: searchlist[i]['name'],
                id: searchlist[i]['id'],
                phoneNumber: searchlist[i]['phonenumber'],
                status: searchlist[i]['status_name'],
                companyName: searchlist[i]['company'],
                isPublic: searchlist[i]['is_public'],
                junk: searchlist[i]['junk'],
                lost: searchlist[i]['lost'],
                addedDate: searchlist[i]['dateadded'],
                lastDate: searchlist[i]['lastcontact'],
              ),
            );
            isDataFetched = true;
          }
        });
      } else {}
    } else {}
  }

  ViewCRMDetailMore() async {
    listCrm.clear();
    newcrmleadlist.clear();
    final paramDic = {
      "staff_id": CommanClass.StaffId,
      "view_all": '1',
      "limit": limit.toString(),
      "date_added": date_added,
      "date_assigned": date_assigned,
      "date_lastcontact": date_lastcontact,
      "date_converted": date_converted,
      "date_laststatus": date_laststatus,
//      "start_date":"2020-01-10",
//      "end_date":"2020-01-30",
      "start": start.toString(),
//      "status":"1",
      //"lead_id":"",
    };

    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.LeadShow, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      if (data['status'].toString() != false) {
        listCrm = data['data'];
        // crmleadlist.clear();
        for (int i = 0; i < listCrm.length; i++) {
          crmleadlist.add(
            LeadsDetails(
              id: listCrm[i]['id'],
              phoneNumber: listCrm[i]['phonenumber'],
              name: listCrm[i]['name'],
              status: listCrm[i]['status_name'],
              companyName: listCrm[i]['company'],
              isPublic: listCrm[i]['is_public'],
              junk: listCrm[i]['junk'],
              lost: listCrm[i]['lost'],
              addedDate: listCrm[i]['dateadded'],
              lastDate: listCrm[i]['lastcontact'],
            ),
          );
          if (listCrm[i]['status_name'] != null &&
              statusList.contains(listCrm[i]['status_name']) == false) {
            statusList.add(listCrm[i]['status_name']);
          }
        }
        if (widget.leadStatus != null) {
          crmleadlist.removeWhere((element) {
            if (element.status != null) {
              if (element.status.toUpperCase() !=
                  widget.leadStatus!.toString().split('(')[0].toUpperCase()) {
                print(element.status +
                    '  <=> ${widget.leadStatus!.toString().split('(')[0].toUpperCase()}  ++ ifCase');
                return true;
              } else {
                print(element.status +
                    '  <=> ${widget.leadStatus!.toString().split('(')[0].toUpperCase()}  ++ elseCase');
                return false;
              }
            }
            return true;
          });
        } else {}
        if (selctedListData.isNotEmpty) {
          for (var selectedValue in selctedListData) {
            crmleadlist.addAll(newcrmleadlist
                .where((element) => element.status == selectedValue));
          }
        }
        if (additionalFiltersvalue != null) {
          final date = DateTime.now();
          final dateFormatted = DateFormat("yyyy-MM-d").format(date);
          if (additionalFiltersvalue == 'Lost') {
            crmleadlist.removeWhere((element) {
              return element.lost.toString() == '0';
            });
          } else if (additionalFiltersvalue == 'Junk') {
            crmleadlist.removeWhere((element) {
              return element.junk.toString() == '0';
            });
          } else if (additionalFiltersvalue == 'Public') {
            crmleadlist.removeWhere((element) {
              return element.isPublic.toString() == '0';
            });
          } else if (additionalFiltersvalue == 'Contacted Today') {
            crmleadlist.removeWhere((element) {
              if (element.lastDate == null) {
                return true;
              } else {
                return element.lastDate.substring(0, 10) != dateFormatted;
              }
            });
          } else if (additionalFiltersvalue == 'Created Today') {
            crmleadlist.removeWhere((element) {
              if (element.addedDate == null) {
                return true;
              } else {
                return element.addedDate.substring(0, 10) != dateFormatted;
              }
            });
          }
        }
        setState(() {
          newcrmleadlist.addAll(crmleadlist);
          isLoading = false;
        });
      }
    } else if (response.statusCode == 404) {
      print('no data');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    print('Page Finish');
    listCrm.clear();
    newcrmleadlist.clear();
    crmleadlist.clear();

    start = 1;
    isDataFetched = false;
    CommanClass.isFilter = false;
  }

  bool sortList = false;
  onSearchTextChanged(String text) async {
    crmleadlist.clear();
    LeadSearch(text);

    if (text.isEmpty) {
      crmleadlist.clear();
      setState(() {
        crmleadlist = List.from(newcrmleadlist);
      });
      return;
    }

    setState(() {
      crmleadlist = newcrmleadlist
          .where((item) => item.name
              .toString()
              .toLowerCase()
              .contains(text.toString().toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorCollection.grey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CommanClass.LeadUpdateNew = "New";
          setState(() {
            start = 1;
          });
          Navigator.pushNamed(context, AddNewLead.id)
              .then((value) => viewCRMDetail());
        },
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: height * 0.23,
                  width: width,
                  decoration: BoxDecoration(
                    color: ColorCollection.backColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: width * 0.016,
                    top: height * 0.1,
                    right: width * 0.016,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/first.png'),
                              fit: BoxFit.fill),
                        ),
                        height: height * 0.06,
                        width: width * 0.2,
                      ),
                      appBarTitle,
                      Spacer(),
                      SizedBox(
                        width: 6,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (cumSearch.icon == Icons.search) {
                                cumSearch = Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                );
                                appBarTitle = Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.white, width: 0.5)),
                                  width: width * 0.5,
                                  child: TextField(
                                    onChanged: onSearchTextChanged,
                                    cursorColor: Colors.white,
                                    autofocus: true,
                                    style: kTextformStyle.copyWith(
                                        color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: "Search Lead By Name",
                                      hintStyle: kTextformHintStyle.copyWith(
                                          color: Colors.white),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 13),
                                    ),
                                  ),
                                );
                              } else {
                                cumSearch = Icon(
                                  Icons.search,
                                  color: Colors.white,
                                );
                                appBarTitle = Text(
                                  KeyValues.leads,
                                  style: ColorCollection.screenTitleStyle,
                                );
                                onSearchTextChanged("");
                              }
                            });
                          },
                          icon: cumSearch)
                    ],
                  ),
                ),
                Container(
                  height: height * 0.044,
                  margin: EdgeInsets.only(
                    left: width * 0.1,
                    top: height * 0.2,
                    right: width * 0.09,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (sortList) {
                            setState(() {
                              crmleadlist.sort((a, b) {
                                return a.name
                                    .toLowerCase()
                                    .compareTo(b.name.toLowerCase());
                              });
                              sortList = false;
                            });
                          } else {
                            setState(() {
                              crmleadlist.sort((a, b) {
                                return b.name
                                    .toLowerCase()
                                    .compareTo(a.name.toLowerCase());
                              });
                              sortList = true;
                            });
                          }
                        },
                        child: Container(
                          width: width * 0.4,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            color: ColorCollection.darkGreen,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              topLeft: Radius.circular(6),
                            ),
                          ),
                          child: Text(
                              !sortList ? KeyValues.sortA_Z : KeyValues.sortZ_A,
                              style: ColorCollection.titleStyleWhite),
                        ),
                      ),
                      Container(
                        width: width * 0.4,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                        child: DropdownButton<dynamic>(
                          value: dropdownValue,
                          hint: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.sort,
                                color: Colors.grey[500],
                              ),
                              Text(KeyValues.filter,
                                  style: ColorCollection.subTitleStyle3),
                            ],
                          ),
                          icon: null,
                          underline: SizedBox(),
                          items: <DropdownMenuItem>[
                            DropdownMenuItem(
                              value: 1,
                              child: Text('Select Status',
                                  style: ColorCollection.subTitleStyle3),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: SizedBox(
                                width: width * 0.3,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DropdownButton<dynamic>(
                                    value: additionalFiltersvalue,
                                    hint: Text('Additional Filters',
                                        style: ColorCollection.subTitleStyle3),
                                    icon: null,
                                    underline: SizedBox(),
                                    items: <DropdownMenuItem>[
                                      DropdownMenuItem(
                                        value: 'Lost',
                                        child: Text('Lost',
                                            style:
                                                ColorCollection.subTitleStyle3),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Junk',
                                        child: Text('Junk',
                                            style:
                                                ColorCollection.subTitleStyle3),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Public',
                                        child: Text('Public',
                                            style:
                                                ColorCollection.subTitleStyle3),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Contacted Today',
                                        child: Text('Contacted Today',
                                            style:
                                                ColorCollection.subTitleStyle3),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Created Today',
                                        child: Text('Created Today',
                                            style:
                                                ColorCollection.subTitleStyle3),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      print(value);
                                      crmleadlist.clear();
                                      if (selctedListData.isNotEmpty) {
                                        for (var selectedValue
                                            in selctedListData) {
                                          crmleadlist.addAll(
                                              newcrmleadlist.where((element) =>
                                                  element.status ==
                                                  selectedValue));
                                        }
                                      } else {
                                        crmleadlist.addAll(newcrmleadlist);
                                      }

                                      final date = DateTime.now();
                                      final dateFormatted =
                                          DateFormat("yyyy-MM-d").format(date);
                                      additionalFiltersvalue = value;
                                      if (additionalFiltersvalue == 'Lost') {
                                        crmleadlist.removeWhere((element) {
                                          return element.lost.toString() == '0';
                                        });
                                        setState(() {});
                                        Navigator.pop(context);
                                        return;
                                      } else if (additionalFiltersvalue ==
                                          'Junk') {
                                        crmleadlist.removeWhere((element) {
                                          return element.junk.toString() == '0';
                                        });
                                        setState(() {});
                                        Navigator.pop(context);
                                        return;
                                      } else if (additionalFiltersvalue ==
                                          'Public') {
                                        crmleadlist.removeWhere((element) {
                                          return element.isPublic.toString() ==
                                              '0';
                                        });
                                        setState(() {});
                                        Navigator.pop(context);
                                        return;
                                      } else if (additionalFiltersvalue ==
                                          'Contacted Today') {
                                        crmleadlist.removeWhere((element) {
                                          if (element.lastDate == null) {
                                            return true;
                                          } else {
                                            return element.lastDate
                                                    .substring(0, 10) !=
                                                dateFormatted;
                                          }
                                        });
                                        setState(() {});
                                        Navigator.pop(context);
                                        return;
                                      } else if (additionalFiltersvalue ==
                                          'Created Today') {
                                        crmleadlist.removeWhere((element) {
                                          if (element.addedDate == null) {
                                            return true;
                                          } else {
                                            return element.addedDate
                                                    .substring(0, 10) !=
                                                dateFormatted;
                                          }
                                        });
                                        setState(() {});
                                        Navigator.pop(context);
                                        return;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == 1) {
                              _openFilterDialog();
                            } else if (value == 2) {}
                          },
                        ),
                      ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Container(
              height: height * 0.72,
              decoration:
                  kContaierDeco.copyWith(color: ColorCollection.containerC),
              padding: EdgeInsets.all(10),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: width * 0.3,
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<String>(
                        hint: Text(KeyValues.nothingSelected),
                        style: ColorCollection.titleStyle,
                      isExpanded: true,
                       // isDense: false,
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
                          viewCRMDetail();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height*0.01,),
                isDataFetched == false
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                      height:height*0.58 ,
                        child: crmleadlist.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: crmleadlist.length,
                                itemBuilder: (context, index) {
                                  return leadDetailsContainer(
                                      i: index,
                                      height: height,
                                      width: width,
                                      leadsDetails: crmleadlist[index],
                                      context: context);
                                },
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return Center(child: Text('No Data'));
                                },
                              ),
                      )
              ]),
            )
          ],
        ),
      ),
    );
  }

  //Show Lead data by particuler lead id for next page
  void showLeadData(String lead_id) async {
    setState(() {
      loadingLeadData = true;
    });
    ToastShowClass.toastShow(context, 'Wait Fetching Info...', Colors.green);
    final paramDic = {
      "staff_id": await SharedPreferenceClass.GetSharedData('staff_id'),
      "view_all": '1',
      "lead_id": lead_id,
    };
    print("Lead id - " + lead_id);
    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.LeadShow, paramDic, "Get", Api_Key_by_Admin);
      var resdata = json.decode(response.body);
      print("Lead Data - " + resdata['data'].toString());
      if (response.statusCode == 200) {
        setState(() {
          Navigator.of(context)
              .pushNamed(LeadDetailScreen.id,
                  arguments: resdata['data'] as List)
              .whenComplete(() {
            setState(() {
              loadingLeadData = false;
            });
          });
        });
      } else {
        ToastShowClass.toastShow(context, 'Failed to load data...', Colors.red);
        setState(() {
          loadingLeadData = false;
        });
      }
    } catch (e) {
      setState(() {
        loadingLeadData = false;
      });
      ToastShowClass.toastShow(context, 'Failed to load data...', Colors.red);
    }
  }

  Widget leadDetailsContainer(
      {required double height,
      required int i,
      required double width,
      required LeadsDetails leadsDetails,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        if (loadingLeadData) {
          return;
        }
        showLeadData(crmleadlist[i].id.toString());
      },
      child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(6)),
              margin: EdgeInsets.only(top: 4, bottom: 4),
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: width * 0.14,
                        width: width * 0.14,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: ColorCollection.green,
                                      width: 1.5)),
                              margin: EdgeInsets.all(2),
                              child: Center(
                                child: Text(
                                  leadsDetails.name.isEmpty
                                      ? ''
                                      : leadsDetails.name[0],
                                  style: ColorCollection.darkGreenStyle
                                      .copyWith(fontSize: 20),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                  radius: 6, backgroundColor: Colors.green),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.03),
                  SizedBox(
                    width: width * 0.67,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (leadsDetails.id == null
                                  ? ''
                                  : '#${leadsDetails.id} ') +
                              (leadsDetails.name == null
                                  ? ''
                                  : leadsDetails.name),
                          style: ColorCollection.titleStyle2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('${KeyValues.status}- ',
                                style: ColorCollection.subTitleStyle2),
                            Text(
                                crmleadlist[i].status == null
                                    ? ''
                                    : leadsDetails.status,
                                style: ColorCollection.darkGreenStyle2),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              color: ColorCollection.green,
                              size: 14,
                            ),
                            SizedBox(
                              width: width * 0.6,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                    leadsDetails.companyName == null
                                        ? '${KeyValues.company}- '
                                        : ('${KeyValues.company}- ' +
                                            leadsDetails.companyName),
                                    style: ColorCollection.titleStyle),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: ColorCollection.green,
                                  size: 14,
                                ),
                                Text(
                                  leadsDetails.addedDate == null
                                      ? '${KeyValues.added}- '
                                      : ('${KeyValues.added}- ' +
                                          leadsDetails.addedDate
                                              .substring(0, 10)),
                                  style: ColorCollection.smalltTtleStyle,
                                ),
                              ],
                            ),
                            SizedBox(width: width * 0.03),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: ColorCollection.green,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: width * 0.3,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                        leadsDetails.lastDate == null
                                            ? '${KeyValues.lastcontact}- '
                                            : ('${KeyValues.lastcontact}- ' +
                                                leadsDetails.lastDate
                                                    .substring(0, 10)),
                                        style: ColorCollection.smalltTtleStyle),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () async {
                try {
                  print("Phone number :" + crmleadlist[i].phoneNumber);
                  crmleadlist[i].phoneNumber == null
                      ?   ToastShowClass.coolToastShow(
                          context, "no phone number", CoolAlertType.info)
                      : await launch("tel://" + crmleadlist[i].phoneNumber);
                } catch (e) {
                  print('error -- -$e');
                }
              },
              child: Container(
                height: height * 0.045,
                width: width * 0.1,
                margin: EdgeInsets.only(top: height * 0.005),
                decoration: BoxDecoration(
                  color: ColorCollection.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    topRight: Radius.circular(6),
                  ),
                ),
                child: Center(
                    child: Icon(
                  Icons.call,
                  color: Colors.white,
                  size: 16,
                )),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _openFilterDialog() async {
    await FilterListDialog.display<Object>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context,
          headerTheme:
              HeaderThemeData(closeIconColor: ColorCollection.backColor),
          choiceChipTheme: ChoiceChipThemeData(
              selectedTextStyle: TextStyle(color: Colors.white),
              selectedBackgroundColor: ColorCollection.backColor),
          controlButtonBarTheme: ControlButtonBarThemeData(context,
              controlButtonTheme: ControlButtonThemeData(
                textStyle: TextStyle(color: ColorCollection.backColor),
                primaryButtonBackgroundColor: ColorCollection.backColor,
              ))),
      headlineText: KeyValues.filter,
      height: 500,
      listData: statusList as List<Object>,
      selectedListData: selctedListData as List<Object>,
      choiceChipLabel: (item) => item as String?,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (user, query) {
        /// When search query change in search bar then this method will be called

        /// Check if items contains query
        return user.toString().toLowerCase().contains(query.toLowerCase());
      },

      onApplyButtonClick: (list) {
        setState(() {
          selctedListData = list!;
          if (selctedListData.isEmpty) {
            setState(() {
              crmleadlist.clear();

              crmleadlist.addAll(newcrmleadlist);
            });
            return;
          }
          crmleadlist.clear();
          for (var selectedValue in selctedListData) {
            crmleadlist.addAll(newcrmleadlist
                .where((element) => element.status == selectedValue));
          }
        });
        if (additionalFiltersvalue != null) {
          final date = DateTime.now();
          final dateFormatted = DateFormat("yyyy-MM-d").format(date);
          if (additionalFiltersvalue == 'Lost') {
            crmleadlist.removeWhere((element) {
              return element.lost.toString() == '0';
            });
          } else if (additionalFiltersvalue == 'Junk') {
            crmleadlist.removeWhere((element) {
              return element.junk.toString() == '0';
            });
          } else if (additionalFiltersvalue == 'Public') {
            crmleadlist.removeWhere((element) {
              return element.isPublic.toString() == '0';
            });
          } else if (additionalFiltersvalue == 'Contacted Today') {
            crmleadlist.removeWhere((element) {
              if (element.lastDate == null) {
                return true;
              } else {
                return element.lastDate.substring(0, 10) != dateFormatted;
              }
            });
          } else if (additionalFiltersvalue == 'Created Today') {
            crmleadlist.removeWhere((element) {
              if (element.addedDate == null) {
                return true;
              } else {
                return element.addedDate.substring(0, 10) != dateFormatted;
              }
            });
          }
        }
        Navigator.pop(context);
      },

      /// uncomment below code to create custom choice chip
      /*choiceChipBuilder: (context, item, isSelected) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(
            color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
          )),
          child: Text(
            item.name,
            style: TextStyle(
                color: isSelected ? Colors.blue[300] : Colors.grey[300]),
          ),
        );
      },*/
    );
  }
}

class LeadsDetails {
  final String name;
  final String status;
  final String companyName;
  final String addedDate;
  final String lastDate;
  final String? id;
  final String isPublic;
  final String junk;
  final String lost;
  final String phoneNumber;

  LeadsDetails({
    required this.phoneNumber,
    required this.id,
    required this.name,
    required this.status,
    required this.companyName,
    required this.isPublic,
    required this.junk,
    required this.lost,
    required this.addedDate,
    required this.lastDate,
  });
}

// List<LeadsDetails> details = <LeadsDetails>[
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltdzgzdfghghfjgdsdfghjmkllncvbns',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Rahul',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'KArtik',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Aman',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Suraj',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Navneet',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Zishan',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Tanvir',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'Diwakar',
//       status: 'shown demo',
//       companyName: 'abc pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
//   LeadsDetails(
//       name: 'wakar',
//       status: 'shown demo',
//       companyName: 'xyz pvt ltd',
//       addedDate: '2012-02-14',
//       lastDate: '2012-02-14'),
// ];
