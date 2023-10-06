// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, import_of_legacy_library_into_null_safe, avoid_print, prefer_if_null_operators, body_might_complete_normally_nullable

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Expenses/add_new_expenses.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

import '../util/commonClass.dart';

class ExpensesScreen extends StatefulWidget {
  static const id = '/expenses';

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List Expense = [];
  List ExpenseNew = [];
  List ExpenseSearch = [];
  List SendData = [];
  bool isfetched = false;
  late String limit;

  @override
  void initState() {
    setState(() {
      limit = CommanClass.limitList[2];
    });
    getExpenses();
    super.initState();
  }

  Future<void> getExpenses({String? search}) async {
    setState(() {
      isfetched = false;
    });
    final paramDic = {
      'order_by': 'desc',
      if (limit != 'All') 'limit': '$limit',
      if (search != null && search.isNotEmpty) 'search': '$search',
    };
    print(paramDic);
    try {
      var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.getExpense, paramDic, "Get", Api_Key_by_Admin);
      log(response.body);

      Expense.clear();
      ExpenseNew.clear();
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
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
          isfetched = true;
        });
        Expense = data['data'];

        setState(() {
          ExpenseNew.addAll(Expense);
          ExpenseSearch.addAll(ExpenseNew);
        });
      } else {
        log('Error === > ${response.statusCode}');
        setState(() {
          isfetched = true;
        });
      }
    } catch (e) {
      log('Error $e');
      setState(() {
        isfetched = true;
      });
    }
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty || text == '') {
      getExpenses();
    } else {
      getExpenses(search: text);
    }
  }

  Future<void> deleteExpense(String id) async {
    final paramDic = {
      "id": id,
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.delExpense, paramDic, "Post", Api_Key_by_Admin);
    print(response.body.toString());

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      ToastShowClass.coolToastShow(
          context, data['message'], CoolAlertType.success);
    } else {
      ToastShowClass.coolToastShow(
          context, data['message'], CoolAlertType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print('Expense New ==' + ExpenseNew.toString());
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorCollection.backColor,
          child: Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            Navigator.pushNamed(context, AddNewExpenses.id)
                .then((value) => getExpenses());
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
                        width: width * 0.15,
                        child: Image.asset(
                          'assets/newexpense.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Text(KeyValues.expenses,
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
                                hintText: 'Search Expenses',
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
                        hint: Text(KeyValues.nothingSelected),
                        style: ColorCollection.titleStyle,
                       
                       isExpanded: true,
                       // isDense: false,
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
                          getExpenses();
                        },
                      ),
                    ),
                  ],
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
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.06,
                    ),
                    SizedBox(
                      height: height * 0.6,
                      child: isfetched == false
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ExpenseNew.isNotEmpty
                              ? ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: ExpenseNew.length,
                                  itemBuilder: (c, i) {
                                    return Dismissible(
                                        key: UniqueKey(),
                                        // confirmDismiss: (direction) async {
                                        //   if (direction ==
                                        //       DismissDirection.endToStart) {
                                        //     showDialog(
                                        //         context: context,
                                        //         builder: (context) => AlertDialog(
                                        //               title:
                                        //                   Text('Are you Sure ? '),content: Text('You want to delete this ?'),
                                        //               actions: [
                                        //                 ElevatedButton(
                                        //                   onPressed: () {
                                        //                     Navigator.pop(
                                        //                         context, false);
                                        //                   },
                                        //                   child: Text('No'),
                                        //                 ),
                                        //                 ElevatedButton(
                                        //                   onPressed: () {
                                        //                     Navigator.pop(
                                        //                         context, true);
                                        //                   },
                                        //                   child: Text('Yes'),
                                        //                 )
                                        //               ],
                                        //             ));
                                        //   } else {
                                        //     return true;
                                        //   }
                                        // },
                                        onDismissed:
                                            (DismissDirection direction) {
                                          if (direction ==
                                              DismissDirection.startToEnd) {
                                            setState(() {
                                              SendData.clear();
                                              SendData.add(ExpenseNew[i]);
                                              Navigator.pushNamed(
                                                      context, AddNewExpenses.id,
                                                      arguments: SendData)
                                                  .then((value) => getExpenses());
                                            });
                                          } else if (direction ==
                                              DismissDirection.endToStart) {
                                            setState(() {
                                              deleteExpense(ExpenseNew[i]['id'])
                                                  .then((value) => getExpenses());
                                            });
                                          }
                                        },
                                        background: slideRightBackground(),
                                        secondaryBackground:
                                            slideLeftBackground(),
                                        child:
                                            expensesContainer(width, height, i));
                                  })
                              : Center(
                                  child: Text('No Data'),
                                ),
                    ),
                    SizedBox(height: height * 0.01)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget expensesContainer(double width, double height, int i) {
    print(ExpenseNew[i]);
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${KeyValues.date} : ' +
                    (ExpenseNew[i]['date'] == null
                        ? ""
                        : ExpenseNew[i]['date']),
                style: ColorCollection.titleStyle,
              ),
            ],
          ),
          Text(
              '${KeyValues.category} : ' +
                  (ExpenseNew[i]['category_name'] == null
                      ? ""
                      : ExpenseNew[i]['category_name']),
              style: ColorCollection.titleStyle2),
          SizedBox(
            height: height * 0.015,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${KeyValues.name}    : ' +
                      (ExpenseNew[i]['expense_name'] == null
                          ? ""
                          : ExpenseNew[i]['expense_name']),
                  style: ColorCollection.subTitleStyle),
              Text(
                  '${KeyValues.reference} : ' +
                      (ExpenseNew[i]['reference_no'] == null
                          ? ""
                          : ExpenseNew[i]['reference_no']),
                  style: ColorCollection.subTitleStyle),
            ],
          ),
          SizedBox(
            height: height * 0.005,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${KeyValues.amount} :' +
                      (ExpenseNew[i]['amount'] == null
                          ? ""
                          : ExpenseNew[i]['amount']),
                  style: ColorCollection.subTitleStyle),
              Text(
                  '${KeyValues.paymentMode} : ' +
                      (ExpenseNew[i]['paymentmode_name'] == null
                          ? ""
                          : ExpenseNew[i]['paymentmode_name']),
                  style: ColorCollection.subTitleStyle),
            ],
          ),
        ],
      ),
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
              style: ColorCollection.titleStyleWhite2,
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
}
