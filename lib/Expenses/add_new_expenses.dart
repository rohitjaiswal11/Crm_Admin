// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, must_be_immutable, prefer_if_null_operators, avoid_print, import_of_legacy_library_into_null_safe, unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Tasks/task_detail_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';

class AddNewExpenses extends StatefulWidget {
  static const id = '/addnewExpenses';
  List EditExpense = [];
  AddNewExpenses({required this.EditExpense});
  @override
  State<AddNewExpenses> createState() => _AddNewExpensesState();
}

class _AddNewExpensesState extends State<AddNewExpenses> {
  TextEditingController nameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController refController = TextEditingController();
  TextEditingController expdateController = TextEditingController();
  var id;
  File? UploadFile;
  String? UploadFileName;
  List Estimate_Status = [];
  String dateCurrent = "";
  List categories = [];
  Repeat? _repeat;
  List<Repeat> _priorityList = Repeat.getRepeat();
  List customer = [];
  List category = [];
  List payment = [];
  List<Projects> Project = [];
  List<Customer> _customerList = [];
  List<Category> _categoryList = [];
  List<Payments> _paymentmodeList = [];
  Customer? selectcustomer;
  Category? selectcategory;
  Projects? selectproject;
  Payments? selectedpayment;
  bool haveproj = false;
  String? Category_id;
  String? Customer_id;
  final _formKey = GlobalKey<FormState>();

  List currencyList = [];

  @override
  void initState() {
    CommanClass.UploadFile = null;
    getdata();
    getCustomer();
    super.initState();
  }

  getdata() async {
    setState(() {
      getExpenses();
    });
    if (widget.EditExpense != null) {
      nameController.text = widget.EditExpense[0]['expense_name'] == null
          ? ""
          : widget.EditExpense[0]['expense_name'];
      amountController.text = widget.EditExpense[0]['amount'] == null
          ? ""
          : widget.EditExpense[0]['amount'];
      expdateController.text = widget.EditExpense[0]['date'] == null
          ? ""
          : widget.EditExpense[0]['date'];
      refController.text = widget.EditExpense[0]['reference_no'] == null
          ? ""
          : widget.EditExpense[0]['reference_no'];
    }
  }

  ///Get Customers
  Future<void> getCustomer() async {
    final paramDic = {
      "type": 'tag',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.New_Estimate, paramDic, "Get", Api_Key_by_Admin);
    print(response);
    var data = json.decode(response.body);
    log('Start' + data.toString());
    // all_Data.;
    // print(all_Data.toString()+"hellooowww");
    if (response.statusCode != 0) {
      try {
        final data = json.decode(response.body);
        if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Load Data', Colors.red);
        }
      } catch (e) {
        ToastShowClass.toastShow(null, 'Failed to Load Data', Colors.red);
      }
      currencyList = data['data']['currencies'];
    } else {}
  }

  Future<void> getExpenses() async {
    final paramDic = {
      "": '',
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.getinfoExpense, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    category.clear();
    customer.clear();
    Project.clear();
    if (response.statusCode == 200) {
      customer.addAll(data['data'][0]['customer']);
      category.addAll(data['data'][0]['expense_category']);
      payment.addAll(data['data'][0]['paymentmode']);
      setState(() {
        for (int i = 0; i < customer.length; i++) {
          _customerList.add(Customer(
              id: customer[i]['userid'],
              name: customer[i]['company'],
              project: customer[i]['project']));
        }
      });
      setState(() {
        for (int i = 0; i < category.length; i++) {
          _categoryList.add(Category(
              id: category[i]['id'],
              name: category[i]['name'],
              discription: category[i]['description']));
        }
        print(_categoryList.toString());
      });
      setState(() {
        for (int i = 0; i < payment.length; i++) {
          _paymentmodeList.add(Payments(
            id: payment[i]['id'],
            name: payment[i]['name'],
          ));
        }
        print(_categoryList.toString());
      });
    } else {}
  }

  void AddExpense() async {
    final paramDic = {
      "expense_name": nameController.text.toString(),
      "note": noteController.text.toString(),
      "category": Category_id.toString(),
      "date": expdateController.text.toString(),
      "amount": amountController.text.toString(),
      "clientid": Customer_id.toString(),
      "project_id": CommanClass.selectedEstimateStatus.toString(),
      "currency": CommanClass.selectedEstimateCurrency.toString(),
      "tax": "0",
      "tax2": "0",
      "paymentmode": id.toString(),
      "reference_no": refController.text.toString(),
      "repeat_every": CommanClass.repeat_exp.toString(),
      if (widget.EditExpense != null)
        "id": widget.EditExpense[0]['id'] == null
            ? ""
            : widget.EditExpense[0]['id'].toString(),
    };
    print('Patameters==> ' + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.getExpense, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.success);
        Navigator.pop(context);
      });
    } else {
      setState(() {
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.error);
      });
    }
  }

  ShowUploadFile() {
    setState(() {
      UploadFile = CommanClass.UploadFile as File;
      UploadFileName = CommanClass.UploadFilename;
    });
    print('http://' + Base_Url_For_App + CommanClass.UploadFile.toString());
  }

  void _invoiceDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2001),
            lastDate: DateTime(2050))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        dateCurrent = DateFormat("yyyy-MM-dd").format(value);
        expdateController.text = dateCurrent.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final contentPadding =
        EdgeInsets.only(left: width * 0.02, right: width * 0.02);
    return Scaffold(
      backgroundColor: ColorCollection.grey,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                        height: height * 0.06,
                        width: width * 0.1,
                        child: Image.asset(
                          'assets/newexpense.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Text(
                        KeyValues.addnewexpenses.toUpperCase(),
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
              SizedBox(
                height: height * 0.06,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                ),
                width: width,
                decoration:
                    kContaierDeco.copyWith(color: ColorCollection.containerC),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    InkWell(
                      onTap: () {
                        showGeneralDialog(
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionBuilder: (context, a1, a2, widget) {
                              return Transform.scale(
                                scale: a1.value,
                                child: Opacity(
                                  opacity: a1.value,
                                  child: AttachmentAddDialogBox(),
                                ),
                              );
                            },
                            transitionDuration: Duration(milliseconds: 400),
                            barrierDismissible: false,
                            barrierLabel: '',
                            context: context,
                            pageBuilder: (context, animation1, animation2) {
                              return SizedBox();
                            }).then((value) => ShowUploadFile());
                      },
                      child: Container(
                        height: height * 0.18,
                        width: width,
                        decoration: kDropdownContainerDeco,
                        child: UploadFile != null
                            ? Image.file(UploadFile!, fit: BoxFit.contain)
                            : Center(
                                child: Text(
                                  KeyValues.attachReciept,
                                  style: ColorCollection.titleStyle,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(KeyValues.name,
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      height: height * 0.06,
                      width: width,
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter the Name ';
                          }
                          return null;
                        },
                        controller: nameController,
                        style: kTextformStyle,
                        decoration: InputDecoration(
                          contentPadding: contentPadding,
                          hintStyle: kTextformHintStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(KeyValues.note,
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      height: height * 0.06,
                      width: width,
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter the Note ';
                          }
                          return null;
                        },
                        controller: noteController,
                        style: kTextformStyle,
                        decoration: InputDecoration(
                          contentPadding: contentPadding,
                          hintStyle: kTextformHintStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text('*${KeyValues.expenseCategory}',
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<Category>(
                        hint: Text(KeyValues.nothingSelected),
                        style: ColorCollection.titleStyle,
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
                        value: selectcategory,
                        onChanged: (Value) {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            selectcategory = Value;
                            Category_id = Value!.id;
                          });
                        },
                        items: _categoryList.map((Category user) {
                          return DropdownMenuItem<Category>(
                            value: user,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  user.name!,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text('*${KeyValues.expenseDate}',
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      height: height * 0.06,
                      width: width,
                      decoration: kDropdownContainerDeco,
                      child: GestureDetector(
                        onTap: _invoiceDate,
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Text(
                              dateCurrent == ''
                                  ? KeyValues.selectExpenseDate
                                  : dateCurrent,
                              style: ColorCollection.subTitleStyle2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(KeyValues.amount,
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      height: height * 0.06,
                      width: width,
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the amount ';
                          }
                          return null;
                        },
                        controller: amountController,
                        style: kTextformStyle,
                        decoration: InputDecoration(
                          contentPadding: contentPadding,
                          hintStyle: kTextformHintStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(KeyValues.Customer,
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<Customer>(
                        hint: Text(KeyValues.nothingSelected),
                        style: ColorCollection.titleStyle,
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
                        value: selectcustomer,
                        onChanged: (newValue) {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());

                            selectcustomer = newValue!;
                            Customer_id = selectcustomer!.id;
                            Customer_id = selectcustomer!.id;
                            if (selectcustomer!.project!.isNotEmpty) {
                              setState(() {
                                haveproj = true;
                                for (int i = 0;
                                    i < selectcustomer!.project!.length;
                                    i++) {
                                  Project.add(Projects(
                                      id: selectcustomer!.project![i]['id'],
                                      name: selectcustomer!.project![i]
                                          ['name']));
                                }
                              });
                            } else {
                              setState(() {
                                haveproj = false;
                              });
                            }
                          });
                        },
                        items: _customerList.map((item) {
                          return DropdownMenuItem(
                            child: Text(item.name!),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    Visibility(
                      visible: haveproj == true ? true : false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(KeyValues.project,
                              style: ColorCollection.titleStyleGreen),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            decoration: kDropdownContainerDeco,
                            child: DropdownButtonFormField<Projects>(
                              hint: Text(KeyValues.nothingSelected),
                              style: ColorCollection.titleStyle,
                              elevation: 8,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: width * 0.04),
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
                              value: selectproject,
                              items: Project.map((user) {
                                return DropdownMenuItem<Projects>(
                                    child: Text(user.name!), value: user);
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  selectproject = newVal;
                                  CommanClass.project_exp = selectproject!.id!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Text(
                      KeyValues.advancedOptions,
                      style: ColorCollection.titleStyle2.copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Text(
                      KeyValues.currency,
                      style: ColorCollection.titleStyleGreen,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField(
                        hint: Text(KeyValues.nothingSelected),
                        style: ColorCollection.titleStyle,
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
                        items: currencyList.map((item) {
                          return DropdownMenuItem(
                            child: Text(item['name']),
                            value: item['id'],
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            CommanClass.selectedEstimateCurrency =
                                newVal.toString();
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select currency' : null,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      KeyValues.tax1,
                      style: ColorCollection.titleStyleGreen,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField(
                        hint: Text(KeyValues.nothingSelected),
                        style: ColorCollection.titleStyle,
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
                        value: CommanClass.tax_exp,
                        items: Estimate_Status.map((item) {
                          return DropdownMenuItem(
                              child: Text(item['status_name']),
                              value: item['status_id']);
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            CommanClass.tax_exp = newVal.toString();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      KeyValues.tax2,
                      style: ColorCollection.titleStyleGreen,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField(
                        hint: Text(KeyValues.nothingSelected),
                        style: ColorCollection.titleStyle,
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
                        items: Estimate_Status.map((item) {
                          return DropdownMenuItem(
                              child: Text(item['status_name']),
                              value: item['status_id']);
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      KeyValues.paymentMode,
                      style: ColorCollection.titleStyleGreen,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<Payments>(
                        hint: Text(KeyValues.nothingSelected),
                        style: ColorCollection.titleStyle,
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
                        value: selectedpayment,
                        onChanged: (newValue) {
                          log(newValue.toString());
                          setState(() {
                            selectedpayment = newValue!;
                            id = selectedpayment!.id;
                            CommanClass.payment_exp = selectedpayment!.name!;
                          });
                        },
                        items: _paymentmodeList.map((item) {
                          return DropdownMenuItem(
                            child: Text(item.name!),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text('${KeyValues.reference} #',
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      height: height * 0.07,
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        controller: refController,
                        style: kTextformStyle,
                        autofocus: false,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: width * 0.01),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      '${KeyValues.repeat} #',
                      style: ColorCollection.titleStyleGreen,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<Repeat>(
                        hint: Text(KeyValues.nothingSelected),
                        style: ColorCollection.titleStyle,
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
                        value: _repeat,
                        onChanged: (Value) {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _repeat = Value;
                            CommanClass.repeat_exp = _repeat!.id;
                          });
                        },
                        items: _priorityList.map((Repeat user) {
                          return DropdownMenuItem<Repeat>(
                            value: user,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  user.name,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    SizedBox(
                      height: height * 0.045,
                      width: width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ColorCollection.green)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            AddExpense();
                          }
                        },
                        child: Text(
                          KeyValues.save,
                          style: ColorCollection.buttonTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Repeat {
  String id;
  String name;

  Repeat(this.id, this.name);

  static List<Repeat> getRepeat() {
    return <Repeat>[
      Repeat('1', 'Week'),
      Repeat('2', '2 Week'),
      Repeat('3', '2 Months'),
      Repeat('4', '3 Months'),
      Repeat('5', '4 Months'),
      Repeat('6', '5 Months'),
      Repeat('7', '6 Months'),
      Repeat('8', 'Custom'),
    ];
  }
}

class Customer {
  String? id;
  String? name;
  List? project;
  Customer({this.id, this.name, this.project});
}

class Category {
  String? id;
  String? name;
  String? discription;
  Category({this.id, this.name, this.discription});
}

class Projects {
  String? id;
  String? name;
  Projects({this.id, this.name});
}

class Payments {
  String? id;
  String? name;
  Payments({this.id, this.name});

  @override
  String toString() => 'Payments(id: $id, name: $name)';
}
