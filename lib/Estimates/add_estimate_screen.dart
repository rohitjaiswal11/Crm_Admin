// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unnecessary_null_comparison, prefer_if_null_operators, non_constant_identifier_names, import_of_legacy_library_into_null_safe, avoid_print, deprecated_member_use, must_be_immutable

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';

class AddEstimateScreen extends StatefulWidget {
  static const id = '/addesimate';
  var estimateData;
  AddEstimateScreen({this.estimateData});

  @override
  State<AddEstimateScreen> createState() => _AddEstimateScreenState();
}

class _AddEstimateScreenState extends State<AddEstimateScreen> {
  var _customer;

  Future<void> getEstiamteData() async {
    if (widget.estimateData != null) {
      if (widget.estimateData.containsKey('customerID') == true) {
        _customer = customer.firstWhere(
          (element) =>
              element['userid'].toString() ==
              widget.estimateData['customerID'].toString(),
          orElse: () => -1,
        );
        log(_customer.toString());
        if (_customer != -1) {
          setState(() {
            selectedValue = _customer.toString();
            CommanClass.Customername = _customer['company'] ?? '';
            CommanClass.Customerid = _customer['userid'] ?? '';
            CommanClass.Billing_street = _customer['billing_street'] ?? '';
            CommanClass.Billing_city = _customer['billing_city'] ?? '';
            CommanClass.Billing_state = _customer['billing_state'] ?? '';
            CommanClass.Billing_zip = _customer['billing_zip'] ?? '';
            CommanClass.Billing_country =
                _customer['billing_countryname'] ?? '';
            CommanClass.Shipping_street = _customer['shipping_street'] ?? '';
            CommanClass.Shipping_city = _customer['shipping_city'] ?? '';
            CommanClass.Shipping_state = _customer['shipping_state'] ?? '';
            CommanClass.Shipping_zip = _customer['shipping_zip'] ?? '';
            CommanClass.Shipping_country =
                _customer['shipping_countryname'] ?? '';
          });
        }
      }
    } else {
      print('failed---');
    }
    print('Customer Data == => $_customer');
  }

  void _invoiceDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2050))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        CommanClass.currentDate = DateFormat("yyyy-MM-dd").format(value);
      });
    });
  }

  void _dueDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2030))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        CommanClass.dueDate = DateFormat("yyyy-MM-dd").format(value);
      });
    });
  }

  List currencyList = [];

  List<Discount> _discountList = Discount.getDiscount();

  final statuscontroller = TextEditingController();

  String status = "";

  TextEditingController customercontroller = TextEditingController();

  TextEditingController reccontroller = TextEditingController();

  TextEditingController note = TextEditingController();

  TextEditingController referencecontroller = TextEditingController();

  final List<DropdownMenuItem> items = [];

  final List<DropdownMenuItem> sales = [];

  String? selectedValue;

  String? selectsaleagent;

  final _formKey = GlobalKey<FormState>();

  List Estimate_Status = [];

  List customer = [];

  List sale_agent = [];

  Discount? _selectDiscount;

  bool valuefirst = false;

  bool valuesecond = false;

  // List<Language> _selectedLanguages;

  String tags = "";

  final AddItemcontroller = TextEditingController();

  TextEditingController qtycontroller = TextEditingController(text: "1");

  TextEditingController taxcontroller = TextEditingController();

  TextEditingController discontroller = TextEditingController();

  TextEditingController adjustcontroler = TextEditingController();

  TextEditingController ADDNew_description = TextEditingController();

  TextEditingController ADDNewlongdes = TextEditingController();

  TextEditingController AddNewRate = TextEditingController();

  String? id;

  ItemsProduct? Selecteditems;

  List ProductItem = [];

  List<ItemsProduct> _productList = [];

  String? Selectitems;

  List<ItemsProduct> orderedList = [];

  List<ItemsProduct> neworderedList = [];

  bool Selected = false;

  List<ItemsProduct> jsonlist = [];

  @override
  void initState() {
    super.initState();
    getCustomer();
    CommanClass.currentDate = DateTime.now().toString().split(" ")[0];
    CommanClass.dueDate =
        DateTime.now().add(Duration(days: 7)).toString().split(" ")[0];

    // CommanClass.selectedEstimateCurrency = currencyList[0]['id'];
    // _selectedLanguages = [];
    // ignore: unrelated_type_equality_checks
    getItems();
    orderedList.clear();
    CommanClass.Discount = "null";
    CommanClass.Adjustment = "null";
  }

  ///Get Customers
  Future<void> getCustomer() async {
    final paramDic = {
      "type": 'tag',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.New_Estimate, paramDic, "Get", Api_Key_by_Admin);
    print(response);
    customer.clear();
    sale_agent.clear();
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
      CommanClass.InvNo = data['data']['estimate_number'];
      Estimate_Status = data['data']['status'];
      customer.addAll(data['data']['customer']);
      currencyList = data['data']['currencies'];
      sale_agent = (data['data']['sale_agents']);
      log("salllles" + customer.toString());
      setState(() {
        for (int i = 0; i < customer.length; i++) {
          print(i);
          items.add(DropdownMenuItem(
            child: Text(customer[i]['company']),
            value: i.toString() +
                "/" +
                customer[i]['userid'] +
                "/" +
                customer[i]['company'],
          ));
        }
      });
      setState(() {
        for (int i = 0; i < sale_agent.length; i++) {
          sales.add(DropdownMenuItem(
            child: Text(sale_agent[i]['full_name']),
            value: i.toString() +
                "/" +
                sale_agent[i]['sale_agent'] +
                "/" +
                sale_agent[i]['full_name'],
          ));
        }
        print(items.toString() + "sales");
      });
      getEstiamteData();
    } else {}
  }

  final List<String> chooseDiscountitems = <String>['Percent', 'Fixed Amount'];

  String? selectedItem;

  _Discount() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          hint: Text(
            "Select",
            style: TextStyle(fontSize: 14.0),
          ),
          value: selectedItem,
          onChanged: (String? Value) {
            FocusManager.instance.primaryFocus?.unfocus();
            setState(() {
              selectedItem = Value!;
              print("value : " + selectedItem!);
            });
          },
          validator: (value) => value == null ? 'Select Related' : null,
          items: chooseDiscountitems.map((String user) {
            return DropdownMenuItem<String>(
              value: user,
              child: Row(
                children: <Widget>[
                  Text(
                    user,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        TextField(
          keyboardType: TextInputType.number,
          controller: discontroller,
        ),
      ],
    );
  }

  SumAdd() {
    if (Selected == true) {
      return Card(
        margin: EdgeInsets.all(5.0),
        shadowColor: Colors.black54,
        elevation: 10,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 0.5),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  children: [
                    Text("Subtotal : "),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text('\u20B9' +
                          (CommanClass.sum == 0 ? "null" : CommanClass.sum)
                              .toString()),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text("Discount"),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text("Discount"),
                                  content: SizedBox(
                                    height: 100,
                                    child: _Discount(),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Select'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        print("letme check --- " +
                                            selectedItem.toString() +
                                            "---" +
                                            discontroller.toString());
                                        setState(() {
                                          CommanClass.Discount =
                                              discontroller.text;
                                          print(CommanClass.Discount);
                                          print(CommanClass.sum);
                                          // total=(sum +int.parse(Adjustment == "null"? "0":Adjustment)-int.parse( selectedItem == "Fixed Amount"? discontroller.text :(percent.toString()))).toInt();

                                          // print("ehk"+(sum +int.parse(Adjustment == null? "0":Adjustment)-int.parse(Discount == null? "0":Discount)).toString());
                                          CommanClass.percent =
                                              (CommanClass.sum *
                                                      (int.parse(CommanClass
                                                              .Discount) /
                                                          100))
                                                  .toInt();
                                        });

                                        setState(() {
                                          CommanClass.total = (CommanClass.sum +
                                                  int.parse(
                                                      CommanClass.Adjustment ==
                                                              "null"
                                                          ? "0"
                                                          : CommanClass
                                                              .Adjustment) -
                                                  int.parse(selectedItem ==
                                                          "Fixed Amount"
                                                      ? discontroller.text
                                                      : (CommanClass.percent
                                                          .toString())))
                                              .toInt();
                                        });
                                        // String pp = percent.toString();
                                        // print("ehsh$pp");
                                      },
                                    ),
                                  ],
                                ));
                      },
                      child: Icon(Icons.expand_more)),
                  Text(selectedItem == "Fixed Amount"
                      ? ""
                      : CommanClass.Discount == 'null'
                          ? ""
                          : CommanClass.Discount + "%"),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    // child: Text((percent).toString()),
                    child: Text(selectedItem == "Fixed Amount"
                        ? '\u20B9' + discontroller.text
                        : '\u20B9' + (CommanClass.percent).toString()),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  Text("Adjustment  "),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text("Adjustment"),
                                  content: SizedBox(
                                    height: 100,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      controller: adjustcontroler,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Select'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        // print("letme check --- "+selectedItem.toString()+ "---"+discontroller.toString());
                                        setState(() {
                                          CommanClass.Adjustment =
                                              adjustcontroler.text;
                                          CommanClass.total = (CommanClass.sum +
                                                  int.parse(
                                                      CommanClass.Adjustment ==
                                                              "00"
                                                          ? "0"
                                                          : CommanClass
                                                              .Adjustment) -
                                                  int.parse(selectedItem ==
                                                          "Fixed Amount"
                                                      ? discontroller.text
                                                      : (CommanClass.percent
                                                          .toString())))
                                              .toInt();

                                          print(CommanClass.total.toString());
                                        });
                                      },
                                    ),
                                  ],
                                ));
                      },
                      child: Icon(Icons.expand_more)),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(CommanClass.Adjustment == 'null'
                        ? 'null'
                        : '\u20B9' + CommanClass.Adjustment),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Total Amount : "),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text('\u20B9' + CommanClass.total.toString()),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: 10,
      );
    }
  }

  void _Sum() {
    setState(() {
      CommanClass.sum = 0;
      for (int i = 0; i < orderedList.length; i++) {
        CommanClass.sum = orderedList[i].Total! + CommanClass.sum;
        CommanClass.total = (CommanClass.sum +
                int.parse(CommanClass.Adjustment == null
                    ? "0"
                    : CommanClass.Adjustment) -
                int.parse(selectedItem == "Fixed Amount"
                    ? discontroller.text == null
                        ? "0"
                        : discontroller.text
                    : (CommanClass.percent == null
                        ? ""
                        : CommanClass.percent.toString())))
            .toInt();
      }
    });
  }

  void _discal() {
    setState(() {
      CommanClass.Discount =
          CommanClass.Discount == null ? '0' : discontroller.text;
      print(CommanClass.Discount);
      print(CommanClass.sum);

      CommanClass.percent =
          (CommanClass.sum * (int.parse(CommanClass.Discount) / 100)).toInt();
    });
    setState(() {
      CommanClass.total = (CommanClass.sum +
              int.parse(CommanClass.Adjustment == "null"
                  ? "0"
                  : CommanClass.Adjustment) -
              int.parse(selectedItem == "Fixed Amount"
                  ? discontroller.text
                  : (CommanClass.percent.toString())))
          .toInt();
    });
  }

  void _adjcal() {
    setState(() {
      CommanClass.Adjustment = adjustcontroler.text;
      CommanClass.total = (CommanClass.sum +
              int.parse(CommanClass.Adjustment == "00"
                  ? "0"
                  : CommanClass.Adjustment) -
              int.parse(selectedItem == "Fixed Amount"
                  ? discontroller.text
                  : (CommanClass.percent.toString())))
          .toInt();

      print(CommanClass.total.toString());
    });
  }

  void getItems() async {
    final paramDic = {
      "type": 'tag',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.New_Invoice, paramDic, "Get", Api_Key_by_Admin);
    print(response);
    var data = json.decode(response.body);
    log('items Data == ${data}');
    ProductItem.clear();
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          ProductItem = data['data']['Items'];
          for (int i = 0; i < ProductItem.length; i++) {
            _productList.add(ItemsProduct(
                id: ProductItem[i]['id'],
                description: ProductItem[i]['description'],
                longDescription: ProductItem[i]['long_description'],
                rate: ProductItem[i]['rate'],
                tax: ProductItem[i]['tax'],
                unit: ProductItem[i]['unit']));
          }
          print("checkcheck" + ProductItem.toString());
        });
      }
    } else {
      throw Exception('Failed to load invoice');
    }
  }

  Future<void> EstimateSaveData() async {
    final paramDic = {
      "clientid": CommanClass.Customerid.toString(),
      "project_id": "",
      "billing_street": CommanClass.Billing_street.toString(),
      "billing_city": CommanClass.Billing_city.toString(),
      "billing_state": CommanClass.Billing_state.toString(),
      "billing_zip": CommanClass.Billing_zip.toString(),
      "show_shipping_on_estimate": "",
      "shipping_street": CommanClass.Shipping_street.toString(),
      "shipping_city": CommanClass.Shipping_city.toString(),
      "shipping_state": CommanClass.Shipping_state.toString(),
      "shipping_zip": CommanClass.Shipping_zip.toString(),
      "number": CommanClass.InvNo.toString(),
      "date": CommanClass.currentDate.toString(),
      "expirydate": CommanClass.dueDate.toString(),
      "tags": CommanClass.tags.toString(),
      "currency": CommanClass.selectedEstimateCurrency.toString(),
      "sale_agent": CommanClass.selectsaleagent.toString(),
      "discount_type": CommanClass.discountType.toString(),
      "status": CommanClass.selectedEstimateStatus.toString(),
      "reference_no": referencecontroller.text.toString(),
      "adminnote": note.text.toString(),
      "item_select": '',
      "show_quantity_as": '',
      "description": '',
      "long_description": '',
      "quantity": '',
      "unit": '',
      "rate": '',
      "newitems": CommanClass.JsonList.toString(),
      "subtotal": CommanClass.sum.toString(),
      "discount_percent": CommanClass.Discount.toString(),
      "discount_total": CommanClass.percent.toString(),
      "adjustment": CommanClass.Adjustment.toString(),
      "total": CommanClass.total.toString(),
      "clientnote": '',
      "terms": '',
    };
    print("Estimate Param" + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.Create_Estimate, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);
    print('Parameters ===' + paramDic.toString());
    print('Start Data ===' + data.toString());
    print('Response == ' + response.statusCode.toString());
    if (response.statusCode != 0) {
      try {
        final data = json.decode(response.body);
        if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Post Data', Colors.red);
        }
      } catch (e) {
        ToastShowClass.toastShow(null, 'Failed to Post Data', Colors.red);
      }
      setState(() {
        ToastShowClass.coolToastShow(
            context, data['message'].toString(), CoolAlertType.success);
        Navigator.pop(context);
      });
    } else {
      setState(() {
        ToastShowClass.coolToastShow(
            context, data['message'].toString(), CoolAlertType.error);
      });
    }
  }

  @override
  void dispose() {
    CommanClassClear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final contentPadding =
        EdgeInsets.only(left: width * 0.04, bottom: height * 0.025);
    return Scaffold(
      backgroundColor: ColorCollection.grey,
      body: SingleChildScrollView(
          child: FutureBuilder<String>(builder: (context, snapshot) {
        return Form(
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
                        height: height * 0.1,
                        width: width * 0.13,
                        child: Image.asset(
                          'assets/estimate.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Text(
                        KeyValues.addEstimate,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Text('*${KeyValues.Customer}',
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: SearchableDropdown.single(
                        underline: '',
                        items: items,
                        value: CommanClass.Customername,
                        hint: _customer != null && _customer != -1
                            ? _customer['company']
                            : "Select one",
                        searchHint: "Select one",
                        onChanged: (value) {
                          if (value != null) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              selectedValue = value;
                              CommanClass.Customername = customer[int.parse(
                                      selectedValue
                                          .toString()
                                          .split('/')[0])]['company'] ??
                                  '';
                              CommanClass.Customerid = customer[int.parse(
                                      selectedValue
                                          .toString()
                                          .split('/')[0])]['userid'] ??
                                  '';
                              CommanClass.Billing_street = customer[int.parse(
                                      selectedValue
                                          .toString()
                                          .split('/')[0])]['billing_street'] ??
                                  '';
                              CommanClass.Billing_city = customer[int.parse(
                                      selectedValue
                                          .toString()
                                          .split('/')[0])]['billing_city'] ??
                                  '';
                              CommanClass.Billing_state = customer[int.parse(
                                      selectedValue
                                          .toString()
                                          .split('/')[0])]['billing_state'] ??
                                  '';
                              CommanClass.Billing_zip = customer[int.parse(
                                      selectedValue
                                          .toString()
                                          .split('/')[0])]['billing_zip'] ??
                                  '';
                              CommanClass.Billing_country = customer[int.parse(
                                          selectedValue
                                              .toString()
                                              .split('/')[0])]
                                      ['billing_countryname'] ??
                                  '';
                              CommanClass.Shipping_street = customer[int.parse(
                                      selectedValue
                                          .toString()
                                          .split('/')[0])]['shipping_street'] ??
                                  '';
                              CommanClass.Shipping_city = customer[int.parse(
                                      selectedValue
                                          .toString()
                                          .split('/')[0])]['shipping_city'] ??
                                  '';
                              CommanClass.Shipping_state = customer[int.parse(
                                      selectedValue
                                          .toString()
                                          .split('/')[0])]['shipping_state'] ??
                                  '';
                              CommanClass.Shipping_zip = customer[int.parse(
                                      selectedValue
                                          .toString()
                                          .split('/')[0])]['shipping_zip'] ??
                                  '';
                              CommanClass.Shipping_country = customer[int.parse(
                                          selectedValue
                                              .toString()
                                              .split('/')[0])]
                                      ['shipping_countryname'] ??
                                  '';
                              print("selected" + CommanClass.Customername);
                              // print("selected"+customer[int.parse(selectedValue.toString().split('/')[0])].toString());
                            });
                          }
                        },
                        isExpanded: true,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    selectedValue != null
                        ? Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Bill To",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  Divider(color: ColorCollection.backColor),
                                  Text(
                                      "Street :" +
                                          CommanClass.Billing_street.toString(),
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(fontSize: 10)),
                                  Text(
                                      "State/City :" +
                                          (CommanClass.Billing_state
                                              .toString()) +
                                          (CommanClass.Billing_city == ""
                                              ? ""
                                              : "/ " +
                                                  CommanClass.Billing_city
                                                      .toString()),
                                      style: TextStyle(fontSize: 10)),
                                  Text(
                                      "Country :" +
                                          CommanClass.Billing_country
                                              .toString(),
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(fontSize: 10)),
                                  Text(
                                      "Zip :" +
                                          CommanClass.Billing_zip.toString(),
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(fontSize: 10)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Ship To",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  Divider(color: ColorCollection.backColor),
                                  Text(
                                      "Street : " +
                                          CommanClass.Shipping_street
                                              .toString(),
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(fontSize: 10)),
                                  Text(
                                      "State/City :" +
                                          (CommanClass.Shipping_state == ""
                                              ? ""
                                              : CommanClass.Shipping_state
                                                  .toString()) +
                                          (CommanClass.Shipping_city == ""
                                              ? ""
                                              : "/ " +
                                                  CommanClass.Shipping_city
                                                      .toString()),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 10)),
                                  Text(
                                      "Country :" +
                                          CommanClass.Shipping_country
                                              .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 10)),
                                  Text(
                                      "Zip :" +
                                          CommanClass.Shipping_zip.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 10))
                                ],
                              ),
                            ],
                          )
                        : Container(
                            height: 5,
                          ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text('*${KeyValues.InvoiceNumber}',
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Container(
                      height: height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorCollection.totalItem,
                          boxShadow: [
                            BoxShadow(
                                color: ColorCollection.green,
                                blurRadius: 5,
                                blurStyle: BlurStyle.outer)
                          ]),
                      child: Row(
                        children: [
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Text(
                            'INV-',
                            style: ColorCollection.titleStyle,
                          ),
                          VerticalDivider(
                            thickness: 1.5,
                            color: ColorCollection.backColor,
                          ),
                          SizedBox(
                            width: width * 0.7,
                            child: Text(CommanClass.InvNo.toString()),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text('*${KeyValues.estimateDate}',
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
                                CommanClass.currentDate == null
                                    ? KeyValues.selectInvoiceDate
                                    : CommanClass.currentDate,
                                style: ColorCollection.titleStyle),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text('*${KeyValues.expiryDate}',
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
                        onTap: _dueDatePicker,
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
                                CommanClass.dueDate == null
                                    ? KeyValues.selectDate
                                    : CommanClass.dueDate,
                                style: ColorCollection.titleStyle),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(KeyValues.currency,
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField(
                        hint: Text(KeyValues.selectCurrency),
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
                        // value: CommanClass.selectedEstimateCurrency,
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
                    Text(KeyValues.status,
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField(
                        hint: Text(KeyValues.selectSaleAgent),
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
                        // value: CommanClass.selectedEstimateStatus,
                        items: Estimate_Status.map((item) {
                          return DropdownMenuItem(
                              child: Text(item['status_name']),
                              value: item['status_id']);
                        }).toList(),
                        onChanged: (newVal) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            CommanClass.selectedEstimateStatus =
                                int.parse(newVal.toString());
                            // print("check status  ? "+CommanClass.selectedEstimateStatus);
                          });
                        },
                        validator: (value) => value == null
                            ? 'Please fill in select status'
                            : null,
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
                        controller: referencecontroller,
                        style: kTextformStyle,
                        autofocus: false,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintStyle: kTextformHintStyle,
                          contentPadding: contentPadding,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(KeyValues.saleAgent,
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: SearchableDropdown.single(
                        underline: '',
                        items: sales,
                        value: selectsaleagent,
                        hint: "Select Sale Agent",
                        searchHint: "Select one",
                        onChanged: (value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            selectsaleagent = value;
                            CommanClass.selectsaleagent = sale_agent[int.parse(
                                    selectsaleagent.toString().split('/')[0])]
                                ['sale_agent'];
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(KeyValues.discount,
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<Discount>(
                        hint: Text(KeyValues.select),
                        style: ColorCollection.titleStyle,
                        elevation: 8,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: width * 0.04),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
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
                        value: _selectDiscount,
                        onChanged: (newValue) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            _selectDiscount = newValue;

                            CommanClass.discountType =
                                _selectDiscount!.name.toString();
                          });
                        },
                        items: _discountList.map((item) {
                          return DropdownMenuItem(
                            child: Text(item.name),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(KeyValues.adminNote,
                        style: ColorCollection.titleStyleGreen),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      height: height * 0.1,
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        controller: note,
                        style: kTextformStyle,
                        autofocus: false,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintStyle: kTextformHintStyle,
                          contentPadding: contentPadding,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      height: height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorCollection.totalItem,
                          boxShadow: [
                            BoxShadow(
                                color: ColorCollection.green,
                                blurRadius: 5,
                                blurStyle: BlurStyle.outer)
                          ]),
                      child: Center(
                          child: Text(
                        '${KeyValues.totalItem} ' +
                            neworderedList.length.toString(),
                        style: ColorCollection.titleStyle,
                      )),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('*${KeyValues.chooseItem}',
                            style: ColorCollection.titleStyleGreen),
                        Text('*${KeyValues.addItem}',
                            style: ColorCollection.titleStyleGreen),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: kDropdownContainerDeco,
                          width: width * 0.6,
                          child: DropdownButtonFormField<ItemsProduct>(
                            hint: Text(KeyValues.select),
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
                            value: Selecteditems,
                            onChanged: (newValue) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                Selecteditems = newValue;
                                id = newValue!.id;
                                ADDNew_description.text = newValue.description!;
                                ADDNewlongdes.text = newValue.longDescription!;
                                AddNewRate.text = newValue.rate!;
                                CommanClass.tax = newValue.tax!;
                                CommanClass.TotalPrice =
                                    double.parse(newValue.rate!).toInt();
                                open_dialog();
                              });
                            },
                            items: _productList.map((item) {
                              return DropdownMenuItem(
                                child: Text(item.description!),
                                value: item,
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: width * 0.03),
                          child: InkWell(
                            onTap: () {
                              ADDNew_description.text = "";
                              ADDNewlongdes.text = "";
                              AddNewRate.text = "0.00";
                              FocusManager.instance.primaryFocus?.unfocus();
                              open_dialog();
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              color: ColorCollection.green,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: ColorCollection.backColor,
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height *
                            neworderedList.length /
                            5,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: neworderedList.length,
                          itemBuilder: (context, i) {
                            return product_list(context, i);
                          },
                        ),
                      ),
                    ),
                    SumAdd(),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    SizedBox(
                      height: height * 0.05,
                      width: width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ColorCollection.green)),
                        onPressed: () {
                          if (widget.estimateData != null) {
                            if (_customer == null || _customer == -1) {
                             ToastShowClass.coolToastShow(context,
                                  'Please Select Customer', CoolAlertType.info);
                              return;
                            }
                          }
                          setState(() {
                            if (_formKey.currentState!.validate()) {
                              EstimateSaveData();
                            }
                          });
                        },
                        child: Text(
                          KeyValues.submit,
                          style: ColorCollection.buttonTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      })),
    );
  }

  /// Orders
  product_list(BuildContext context, int i) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (direction) async {
        CommanClass.percent = 00;
        CommanClass.Discount = '';
        CommanClass.Adjustment = "00";
        CommanClass.TotalPrice = 00;
        CommanClass.total = 00;
        setState(() {
          neworderedList.removeAt(i);
          orderedList.removeAt(i);
          _Sum();
        });
        setState(() {
          _discal();
          _adjcal();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "The ${neworderedList[i].description} product is removed")));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
                neworderedList[i].description == null
                    ? ""
                    : neworderedList[i].description!,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 3.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(neworderedList[i].longDescription == null
                ? ""
                : neworderedList[i].longDescription!),
          ),
          SizedBox(
            height: 3.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("Qty"),
              ),
              //  Text((_productList[i].price==null?"":_productList[i].price).toString())
              SizedBox(
                width: 3.0,
              ),
              Text("Rate"),
              SizedBox(
                width: 3.0,
              ),
              Text("Tax"),
              SizedBox(
                width: 3.0,
              ),
              Text("Amount"),
            ],
          ),
          SizedBox(
            width: 6.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Row(
                    children: [
                      Text(neworderedList[i].unit == null
                          ? "1"
                          : neworderedList[i].unit!),
                      // SizedBox(
                      //   width: 20,
                      // ),
                      //Text("X"),
                    ],
                  ),
                ),
                Text('\u20B9' +
                    (neworderedList[i].rate == null
                            ? ""
                            : neworderedList[i].rate)
                        .toString()),
                Text(neworderedList[i].tax == null
                    ? ""
                    : neworderedList[i].tax!),
                Text('\u20B9' + neworderedList[i].Total.toString()),
              ],
            ),
          ),
          Divider(
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  void open_dialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                content: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Item",
                          style: ColorCollection.titleStyle2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            controller: ADDNew_description,
                          ),
                          decoration: kDropdownContainerDeco,
                        ),
                      ],
                    ),
                    Divider(
                      color: ColorCollection.backColor,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Descriotion",
                          style: ColorCollection.titleStyle2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            controller: ADDNewlongdes,
                          ),
                          decoration: kDropdownContainerDeco,
                        ),
                      ],
                    ),
                    Divider(
                      color: ColorCollection.backColor,
                    ),
                    ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Qty",
                            style: ColorCollection.titleStyleGreen2,
                          ),
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: SizedBox(
                            height: 55,
                            width: 100,
                            child: NumberInputWithIncrementDecrement(
                              widgetContainerDecoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorCollection.backColor)),
                              onIncrement: (num newlyIncrementedValue) {
                                setState(() {
                                  CommanClass.qty = qtycontroller.text;
                                  qtycontroller.text =
                                      newlyIncrementedValue.toString();

                                  CommanClass.TotalPrice =
                                      (double.parse(AddNewRate.text) *
                                              double.parse(qtycontroller.text))
                                          .toInt();
                                  print("PRICE" + AddNewRate.text.toString());
                                });
                              },
                              onDecrement: (num newlyDecrementedValue) {
                                setState(() {
                                  CommanClass.qty = qtycontroller.text;
                                  qtycontroller.text =
                                      newlyDecrementedValue.toString();
                                  CommanClass.TotalPrice =
                                      (double.parse(AddNewRate.text) *
                                              double.parse(qtycontroller.text))
                                          .toInt();
                                  print("PRICE" + AddNewRate.text.toString());
                                });
                              },
                              controller: qtycontroller,
                              initialValue: 1,
                            ),
                          ),
                        )),
                    Divider(
                      color: ColorCollection.backColor,
                    ),
                    ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Rate",
                            style: ColorCollection.titleStyleGreen2,
                          ),
                        ),
                        trailing: SizedBox(
                          height: 50,
                          width: 100,
                          child: TextField(
                            onChanged: Value_changeAmount(
                                qty: qtycontroller.text,
                                amount: AddNewRate.text),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Enter Rate",
                              hintStyle: TextStyle(
                                color: Colors.blue,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            controller: AddNewRate,
                          ),
                        )),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () {
                      qtycontroller.text = "1";
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: ColorCollection.buttonTextStyle,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: ColorCollection.backColor,
                    ),
                    child: Text(
                      "Done",
                      style: ColorCollection.buttonTextStyle,
                    ),
                    onPressed: () {
                      CommanClass.percent = 00;
                      CommanClass.Discount = '';
                      CommanClass.Adjustment = "00";
                      Selected = true;
                      Navigator.of(ctx).pop();
                      setState(() {
                        CommanClass.qty = qtycontroller.text;
                        CommanClass.TotalPrice =
                            (double.parse(AddNewRate.text) *
                                    double.parse(qtycontroller.text))
                                .toInt();
                        print("PRICE" + AddNewRate.text.toString());
                        orderedList.add(ItemsProduct(
                          id: id,
                          unit: qtycontroller.text,
                          rate: AddNewRate.text,
                          description: ADDNew_description.text,
                          longDescription: ADDNewlongdes.text,
                          tax: CommanClass.tax,
                          Total: CommanClass.TotalPrice,
                        ));
                        List cfd = [];
                        for (int i = 0; i < orderedList.length; i++) {
                          var resBody = {};
                          resBody["order"] = orderedList[i].id;
                          resBody["description"] = orderedList[i].description;
                          resBody["longDescription"] =
                              orderedList[i].longDescription;
                          resBody["rate"] = orderedList[i].rate;
                          resBody["qty"] = orderedList[i].unit;
                          resBody["unit"] = "";
                          // resBody["tax"] = orderedList[i].tax;
                          // resBody["Total"] = orderedList[i].Total.toString();
                          cfd.add(resBody);
                          CommanClass.JsonList = json.encode(cfd);
                        }
                        print(CommanClass.JsonList);
                      });
                      setState(() {
                        CommanClass.sum = 0;
                        for (int i = 0; i < orderedList.length; i++) {
                          CommanClass.sum =
                              orderedList[i].Total! + CommanClass.sum;
                          CommanClass.total = (CommanClass.sum +
                                  int.parse(CommanClass.Adjustment == "null"
                                      ? "0"
                                      : CommanClass.Adjustment) -
                                  int.parse(selectedItem == "Fixed Amount"
                                      ? discontroller.text == null
                                          ? "0"
                                          : discontroller.text
                                      : (CommanClass.percent == null
                                          ? ""
                                          : CommanClass.percent.toString())))
                              .toInt();
                        }
                        _discal();
                        _adjcal();
                      });
                    },
                  ),
                ],
              ),
            );
          });
        }).then((value) => setState(() {
          neworderedList.clear();
          neworderedList.addAll(orderedList);
        }));
  }

  Value_changeAmount({required String qty, required String amount}) {
    CommanClass.TotalPrice = (double.parse(amount) * int.parse(qty)).toInt();
  }
}

class Discount {
  int id;
  String name;
  Discount(this.id, this.name);
  static List<Discount> getDiscount() {
    return <Discount>[
      Discount(1, 'No Discount'),
      Discount(2, 'After Tax'),
      Discount(3, 'Before Tax'),
    ];
  }
}

class RecInvoice {
  int id;
  String num;
  RecInvoice(this.id, this.num);
  static List<RecInvoice> getCurrency() {
    return <RecInvoice>[
      RecInvoice(1, 'Every 1 Month'),
      RecInvoice(2, 'Every 2 Month'),
      RecInvoice(1, 'Every 3 Month'),
      RecInvoice(2, 'Every 4 Month'),
      RecInvoice(1, 'Every 5 Month'),
      RecInvoice(2, 'Every 6 Month'),
      RecInvoice(1, 'Every 7 Month'),
      RecInvoice(2, 'Every 8 Month'),
      RecInvoice(1, 'Every 9 Month'),
      RecInvoice(2, 'Every 10 Month'),
    ];
  }
}

class ChipTags extends StatefulWidget {
  ///sets the remove icon Color
  final Color iconColor;

  ///sets the chip background color
  final Color chipColor;

  ///sets the color of text inside chip
  final Color textColor;

  ///container decoration
  final InputDecoration decoration;

  ///set keyboradType
  final TextInputType keyboardType;

  ///customer symbol to seprate tags by default
  ///it is " " space.
  final String separator;

  /// list of String to display
  final List<String> list;
  const ChipTags({
    required this.iconColor,
    required this.chipColor,
    required this.textColor,
    required this.decoration,
    required this.keyboardType,
    required this.separator,
    required this.list,
  });
  @override
  _ChipTagsState createState() => _ChipTagsState();
}

class _ChipTagsState extends State<ChipTags>
    with SingleTickerProviderStateMixin {
  ///Form key for TextField
  final _formKey = GlobalKey<FormState>();
  TextEditingController _inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Form(
          key: _formKey,
          child: TextField(
            controller: _inputController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "Separate Tags with '${widget.separator}'",
            ),
            keyboardType: widget.keyboardType,
            onChanged: (value) {
              FocusManager.instance.primaryFocus?.unfocus();

              ///check if user has send " " so that it can break the line
              ///and add that word to list
              if (value.endsWith(widget.separator)) {
                ///check for ' ' and duplicate tags
                if (value != ' ' && !widget.list.contains(value.trim())) {
                  widget.list
                      .add(value.replaceFirst(widget.separator, '').trim());
                }

                ///setting the controller to empty
                _inputController.clear();

                ///resetting form
                _formKey.currentState!.reset();

                ///refersing the state to show new data
                setState(() {});
              }
            },
          ),
        ),
        Visibility(
          //if length is 0 it will not occupie any space
          visible: widget.list.isNotEmpty,
          child: Wrap(
            ///creating a list
            children: widget.list.map((text) {
              return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FilterChip(
                      backgroundColor: widget.chipColor,
                      label: Text(
                        text,
                        style: TextStyle(color: widget.textColor),
                      ),
                      avatar: Icon(Icons.remove_circle_outline,
                          color: widget.iconColor),
                      onSelected: (value) {
                        widget.list.remove(text);
                        setState(() {});
                      }));
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ItemsProduct {
  String? id;
  String? description;
  String? longDescription;
  String? rate;
  String? tax;
  String? tax2;
  String? unit;
  String? groupId;
  int? Total;

  ItemsProduct(
      {this.id,
      this.description,
      this.longDescription,
      this.rate,
      this.tax,
      this.tax2,
      this.unit,
      this.groupId,
      this.Total});
}

CommanClassClear() {
  CommanClass.Customername = '';
  CommanClass.Customerid = '';
  CommanClass.Billing_street = '';
  CommanClass.Billing_state = '';
  CommanClass.Billing_city = '';
  CommanClass.Billing_country = '';
  CommanClass.Billing_zip = '';
  CommanClass.Shipping_street = '';
  CommanClass.Shipping_city = '';
  CommanClass.Shipping_state = '';
  CommanClass.Shipping_country = '';
  CommanClass.Shipping_zip = '';
  CommanClass.InvNo = "";
  CommanClass.selectedEstimateCurrency;
  CommanClass.selectedEstimateStatus;
  CommanClass.selectedEstimatepayment = "";
  CommanClass.currentDate = '';
  CommanClass.dueDate = '';
  CommanClass.selectedValuesJson = '';
  CommanClass.selectsaleagent = "";
  CommanClass.recInvoice = "";
  CommanClass.discountType = "";
  CommanClass.adminNote = "";
  CommanClass.tags = "";

  //
  // static String additem = "";
  // static String longdesscription = "";
  // static String rate = "";
  CommanClass.qty = "";
  CommanClass.tax = "";
  CommanClass.sum = 0;
  CommanClass.percent = 000;
  CommanClass.total = 0;
  CommanClass.TotalPrice = 0;

  CommanClass.Discount = "00";
  CommanClass.Adjustment = "00";
  CommanClass.JsonList = "";
}
