// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, must_be_immutable, prefer_final_fields, unused_field, non_constant_identifier_names, avoid_print, import_of_legacy_library_into_null_safe, unused_import, prefer_if_null_operators, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Contract/add_new_contracts.dart';
import 'package:lbm_crm/Customer/customers_screen.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

class ContractsScreen extends StatefulWidget {
  static const id = '/contractsScreen';

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  List ContractList = [];
  bool isfetched = false;
  List Contractnew = [];
  List ContractSearch = [];
  List SendData = [];
  late String limit;
  var headerList;

  @override
  void initState() {
    setState(() {
      limit = CommanClass.limitList[2];
    });
    getContract();
    super.initState();
  }

  Future<void> getContract({String? search}) async {
    setState(() {
      isfetched = false;
    });
    final paramDic = {
      // "id": CommanClass.StaffId.toString(),
      'order_by': 'desc',
      if (limit != 'All') 'limit': '$limit',
      if (search != null && search.isNotEmpty) 'search': '$search',
    };
    print(paramDic);
    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.getContract, paramDic, "Get", Api_Key_by_Admin);

      ContractList.clear();
      Contractnew.clear();

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        try {
          final data = json.decode(response.body);
          log(data.toString());

          if (data['status'] != true) if (data['status'].toString() != '1') {
            ToastShowClass.toastShow(
                null, data['message'] ?? 'Failed to Load Data', Colors.red);
          }
        } catch (e) {
          ToastShowClass.toastShow(null, 'Failed to Load Data', Colors.red);
        }
        setState(() {
          isfetched = true;
        });
        ContractList = data['data'];
        if (data['header'] != null) {
          headerList = [
            data['header']['count_active'],
            data['header']['count_expired'],
            data['header']['expiring'],
            data['header']['count_recently_created'],
            data['header']['count_trash'],
          ];
        }

        print(ContractList.toString());

        setState(() {
          Contractnew.addAll(ContractList);
          ContractSearch.addAll(Contractnew);
        });
      } else {
        log(response.statusCode.toString());
        setState(() {
          isfetched = true;
        });
      }
    } catch (e) {
      log('ERRRR $e');
      setState(() {
        isfetched = true;
      });
    }
  }

  Future<void> deleteContract(String id) async {
    final paramDic = {
      "id": id,
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.deleteContract, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Post Data', Colors.red);
        }
      } catch (e) {
        ToastShowClass.toastShow(null, 'Failed to Post Data', Colors.red);
      }
      getContract();
      ToastShowClass.coolToastShow(
          context, data['message'], CoolAlertType.success);
    } else {}
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty || text == '') {
      getContract();
    } else {
      getContract(search: text);
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
          Navigator.pushNamed(context, NewContractScreen.id)
              .then((value) => getContract());
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
                      Container(
                        height: height * 0.1,
                        width: width * 0.16,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/contracts.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Text(KeyValues.contracts,
                          style: ColorCollection.screenTitleStyle),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          size: 30,
                          color: Colors.white54,
                        ),
                      ),
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
                SizedBox(
                  height: height * 0.03,
                ),
                Padding(
                    padding:
                        EdgeInsets.only(top: height * 0.16, left: width * 0.03),
                    child: Container(
                      height: height * 0.11,
                      child: ListView.builder(
                        itemCount: contractItems.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) => contractContainer(
                            width: width,
                            height: height,
                            title: contractItems[i].title,
                            value: headerList == null
                                ? '0'
                                : headerList[i].toString(),
                            color: contractItems[i].color),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: height * 0.03,
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
                              hintText: 'Search Announcement',
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
                        getContract();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Container(
              height: height * 0.61,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
              ),
              decoration:
                  kContaierDeco.copyWith(color: ColorCollection.containerC),
              child: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.03,
                  ),
                  width: width,
                  child: isfetched
                      ? Contractnew.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.only(
                                  left: width * 0.01,
                                  right: width * 0.01,
                                  bottom: height * 0.07),
                              itemCount: Contractnew.length,
                              itemBuilder: (context, i) => Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (DismissDirection direction) {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      setState(() {
                                        SendData.clear();
                                        SendData.add(Contractnew[i]);
                                        Navigator.pushNamed(
                                                context, NewContractScreen.id,
                                                arguments: SendData)
                                            .then((value) => getContract());
                                      });
                                    } else if (direction ==
                                        DismissDirection.endToStart) {
                                      setState(() {
                                        deleteContract(Contractnew[i]['id']);
                                      });
                                    }
                                  },
                                  background: slideRightBackground(),
                                  secondaryBackground: slideLeftBackground(),
                                  child: contractTile(height, width, i)))
                          : Center(
                              child: Text('No Data'),
                            )
                      : Center(
                          child: CircularProgressIndicator(),
                        )),
            ),
          ],
        ),
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: ColorCollection.green,
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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget contractTile(double height, double width, int i) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.01),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.01, vertical: height * 0.01),
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
                  children: [
                    Icon(
                      Icons.contact_page_outlined,
                      color: ColorCollection.green,
                    ),
                    SizedBox(
                      width: width * 0.007,
                    ),
                    SizedBox(
                      width: width * 0.4,
                      child: Text(
                        Contractnew[i]['subject'] == null
                            ? ""
                            : Contractnew[i]['subject'],
                        overflow: TextOverflow.ellipsis,
                        style: ColorCollection.titleStyle2,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${KeyValues.startDate} : ' +
                          (Contractnew[i]["datestart"] == null
                              ? ""
                              : Contractnew[i]["datestart"]),
                      style: ColorCollection.subTitleStyle2,
                    ),
                    SizedBox(
                      height: height * 0.002,
                    ),
                    Text(
                      '${KeyValues.endDate} : ' +
                          (Contractnew[i]["dateend"] == null
                              ? ""
                              : Contractnew[i]["dateend"]),
                      style: ColorCollection.subTitleStyle2,
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: Contractnew[i]['customer_name'] == null
                      ? ""
                      : Contractnew[i]['customer_name'],
                  child: SizedBox(
                    width: width * 0.4,
                    child: Text(
                      '${KeyValues.Customer} - ' +
                          (Contractnew[i]['customer_name'] == null
                              ? ""
                              : Contractnew[i]['customer_name']),
                      overflow: TextOverflow.ellipsis,
                      style: ColorCollection.subTitleStyle2,
                    ),
                  ),
                ),
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: Contractnew[i]['project_name'] == null
                      ? ""
                      : Contractnew[i]['project_name'],
                  child: SizedBox(
                    width: width * 0.4,
                    child: Text(
                      '${KeyValues.project} - ' +
                          (Contractnew[i]['project_name'] == null
                              ? ""
                              : Contractnew[i]['project_name']),
                      overflow: TextOverflow.ellipsis,
                      style: ColorCollection.subTitleStyle2,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: Contractnew[i]['contract_value'] == null
                      ? ""
                      : Contractnew[i]['contract_value'],
                  child: Text(
                    '${KeyValues.contractValue} - ' +
                        (Contractnew[i]['contract_value'] == null
                            ? ""
                            : Contractnew[i]['contract_value']),
                    overflow: TextOverflow.ellipsis,
                    style: ColorCollection.subTitleStyle2,
                  ),
                ),
                Text(
                  '${KeyValues.signature} : ' +
                      (Contractnew[i]["signed"] == '0'
                          ? "Not Signed"
                          : "Signed"),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            )
          ],
        ));
  }

  Widget contractContainer(
      {required double width,
      required double height,
      required String title,
      Color? color,
      required String value}) {
    return Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.02,
          vertical: height * 0.005,
        ),
        width: width * 0.28,
        height: height * 0.08,
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 7, color: Colors.grey)],
            color: Colors.white,
            borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                textAlign: TextAlign.center,
                style: ColorCollection.titleStyle2
                    .copyWith(color: color, fontWeight: FontWeight.normal)),
            SizedBox(
              height: height * 0.01,
            ),
            Text(value, style: ColorCollection.titleStyle2)
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
  String value;
  final Color color;
}

List<Contracts> contractItems = <Contracts>[
  Contracts(title: 'Active', value: '10', color: ColorCollection.green),
  Contracts(title: 'Expired', value: '0', color: Colors.blue),
  Contracts(title: 'About To Expire', value: '3', color: Colors.red),
  Contracts(title: 'Recently Added', value: '5', color: ColorCollection.black),
  Contracts(title: 'Trash', value: '7', color: Colors.orange),
];
