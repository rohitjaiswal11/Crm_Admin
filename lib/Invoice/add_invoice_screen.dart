// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, non_constant_identifier_names, unused_element, unnecessary_null_comparison, prefer_if_null_operators, avoid_print, unrelated_type_equality_checks, unused_import, import_of_legacy_library_into_null_safe, prefer_typing_uninitialized_variables, unused_local_variable, deprecated_member_use, must_be_immutable

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddInvoiceScreen extends StatefulWidget {
  static const id = '/addinvoice';
  var invoiceData;
  AddInvoiceScreen({this.invoiceData});
  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  List<String> _values = ['A', 'B', 'C', 'D'];
  String? _invoiceDateValue;
  String? _dueDate;
  String? _selectedValue;
  bool switchValue = false;
  String? billingCountry;
  String? shippingCountry;
  List currencyList = [];

  List<RecInvoice> _recList = RecInvoice.getCurrency();
  var _customer;
  // String discount = "";
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
  var selectsaleagent;
  final _formKey = GlobalKey<FormState>();
  int _state = 0;
  List payment = [];
  List customer = [];
  List sale_agent = [];
  Discount? _selectDiscount;
  RecInvoice? _selectRecInvoice;
  bool valuefirst = false;
  bool valuesecond = false;
  String _selectedValuesJson = 'Nothing to show';
  // List<Language> _selectedLanguages;
  String tags = "";
  late Future myFuture;
  final AddItemcontroller = TextEditingController();

  // String additem = "";
  // String longdesscription = "";
  // String rate = "";
  // String qty;
  // String tax;
  TextEditingController qtycontroller = TextEditingController(text: "1");
  TextEditingController taxcontroller = TextEditingController();
  TextEditingController discontroller = TextEditingController();
  TextEditingController adjustcontroler = TextEditingController();
  TextEditingController ADDNew_description = TextEditingController();
  TextEditingController ADDNewlongdes = TextEditingController();
  TextEditingController AddNewRate = TextEditingController();

  // String Discount = "00";
  // String Adjustment = "00";
  String id = '';

  // int sum = 0;
  // int percent = 000;
  // int total;
  late ItemsProduct Selecteditems;
  List ProductItem = [];
  List<ItemsProduct> _productList = [];
  late String Selectitems;
  List<ItemsProduct> orderedList = [];
  List<ItemsProduct> neworderedList = [];
  bool Selected = false;
  List<ItemsProduct> jsonlist = [];
  String _day = 'Select ';
  var overdue = '0';

  Future<void> getInvoiceData() async {
    if (widget.invoiceData != null) {
      if (widget.invoiceData.containsKey('customerID') == true) {
        _customer = customer.firstWhere(
          (element) =>
              element['userid'].toString() ==
              widget.invoiceData['customerID'].toString(),
          orElse: () => -1,
        );
        log(_customer.toString());
        if (_customer != -1) {
          setState(() {
            CommanClass.CustomerID = _customer['userid'] ?? '';
            selectedValue = CommanClass.CustomerName;
            CommanClass.Billing_street = _customer['billing_street'] ?? '';
            CommanClass.Billing_city = _customer['billing_city'] ?? '';
            CommanClass.Billing_state = _customer['billing_state'] ?? '';
            CommanClass.Billing_zip = _customer['billing_zip'] ?? '';
            CommanClass.Billing_country = _customer['billing_country'] ?? '';
            CommanClass.Shipping_street = _customer['shipping_street'] ?? '';
            CommanClass.Shipping_city = _customer['shipping_city'] ?? '';
            CommanClass.Shipping_state = _customer['shipping_state'] ?? '';
            CommanClass.Shipping_zip = _customer['shipping_zip'] ?? '';
            CommanClass.Shipping_country = _customer['shipping_country'] ?? '';
            billingCountry = _customer['billing_countryname'] ?? '';
            shippingCountry = _customer['shipping_countryname'] ?? '';
          });
        }
      }
    }
  }

  @override
  void initState() {
    myFuture = getCustomer();
    CommanClass.currentDate = DateTime.now().toString().split(" ")[0];
    // CommanClass.dueDate =
    //     DateTime.now().add(Duration(days: 30)).toString().split(" ")[0];
    // _selectedLanguages = [];
    // customer.clear();
    // sale_agent.clear();
    //selectedValue=CommanClass.Customername;

    print("selected" + CommanClass.Customername);
    //items
    CommanClass.TotalPrice == AddNewRate.text.toString();
    getItems();
    orderedList.clear();
    CommanClass.Discount = "null";
    CommanClass.Adjustment = "null";
    setState(() {
        CommanClass.currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
        _invoiceDateValue = CommanClass.currentDate;
      });
    super.initState();
  }

  @override
  void setState(fn) {
    CommanClass.adminNote = note.text;
    super.setState(fn);
  }

  ///Get Customers
  Future<String> getCustomer() async {
    final paramDic = {
      "type": 'tag',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.New_Invoice, paramDic, "Get", Api_Key_by_Admin);
    print(response);
    customer.clear();
    sale_agent.clear();
    var data = json.decode(response.body);
    print('Start' + data.toString());
    // all_Data.;
    // print(all_Data.toString()+"hellooowww");
    if (response.statusCode != 0) {
      CommanClass.InvNo = data['data']['invoice_number'];
      payment = data['data']['payment_modes'];
      customer = (data['data']['customer']);
      currencyList = data['data']['currencies'];
      sale_agent = (data['data']['sale_agents']);
      print("salllles" + sale_agent.toString());
      setState(() {
        for (int i = 0; i < customer.length; i++) {
          items.add(DropdownMenuItem(
            child: Text(customer[i]['company'].toString()),
            value: i.toString() +
                "/" +
                customer[i]['userid'] +
                "/" +
                customer[i]['company'],
          ));
        }
        print("COUSTOMER    " + customer.toString());
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
        print(sales.toString() + "sales");
      });
      print("Hello Payment ? " +
          payment.toString() +
          " " +
          currencyList.toString() +
          " " +
          sale_agent.toString());
      getInvoiceData();
    } else {}
    return 'null';
  }

  final List<String> chooseDiscountitems = <String>['Percent', 'Fixed Amount'];
  String? selectedItem = '';

  //Discount Dropdown
  _Discount() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          hint: Text(
            "Select",
            style: TextStyle(fontSize: 14.0),
          ),
          //   value: selectedItem,
          onChanged: (String? Value) {
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

  sumAdd() {
    if (Selected == true) {
      return Card(
        margin: EdgeInsets.all(5.0),
        shadowColor: Colors.black54,
        elevation: 10,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: ColorCollection.backColor, width: 0.5),
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
                      child: Text('\$' +
                          (CommanClass.sum == 0 ? "0" : CommanClass.sum)
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
                                      onPressed: () {
                                        qtycontroller.text = "1";
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
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
                        ? '\$' + discontroller.text
                        : '\$' + (CommanClass.percent).toString()),
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
                            barrierDismissible: false,
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
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
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
                        : '\$' + CommanClass.Adjustment),
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
                    child: Text('\$' + CommanClass.total.toString()),
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
        CommanClass.sum = (orderedList[i].Total! + CommanClass.sum);
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

  //calculate after item add or removed
  void _discal() {
    setState(() {
      CommanClass.Discount = discontroller.text;
      print(CommanClass.Discount);
      print(CommanClass.sum);

      CommanClass.percent = (CommanClass.sum *
              (int.parse(CommanClass.Discount == null ||
                          CommanClass.Discount.isEmpty ||
                          CommanClass.Discount == 0 ||
                          CommanClass.Discount == "null"
                      ? '0'
                      : CommanClass.Discount) /
                  100))
          .toInt();
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

  //calculate after item add or removed
  void _adjcal() {
    setState(() {
      CommanClass.Adjustment = adjustcontroler.text;
      CommanClass.total = (CommanClass.sum +
              (int.tryParse(CommanClass.Adjustment == "00"
                      ? "0"
                      : CommanClass.Adjustment) ??
                  0) -
              (int.tryParse(selectedItem == "Fixed Amount"
                      ? discontroller.text
                      : (CommanClass.percent.toString())) ??
                  0))
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
    ProductItem.clear();
    if (response.statusCode == 200) {
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
    } else {
      throw Exception('Failed to load invoice');
    }
  }

  Future<void> InvoiceSaveData() async {
    final paramDic = {
      "clientid": CommanClass.CustomerID.toString(),
      "project_id": "",
      "billing_street": CommanClass.Billing_street,
      "billing_city": CommanClass.Billing_city,
      "billing_state": CommanClass.Billing_state,
      "billing_zip": CommanClass.Billing_zip,
      "billing_country": CommanClass.Billing_country,
      "shipping_street": CommanClass.Shipping_street,
      "shipping_city": CommanClass.Shipping_city,
      "shipping_state": CommanClass.Shipping_state,
      "shipping_zip": CommanClass.Shipping_zip,
      "shipping_country": CommanClass.Shipping_country,
      "number": CommanClass.InvNo.toString(),
      "date": CommanClass.currentDate.toString(),
      "duedate": CommanClass.dueDate.toString(),
      // "tags": CommanClass.tags,
      "allowed_payment_modes": CommanClass.selectedInvoicepayment.toString(),
      "currency": CommanClass.selectedInvoiceCurrency.toString(),
      "sale_agent": CommanClass.selectsaleagent.toString(),
      "recurring": CommanClass.recInvoice.toString(),
      "discount_type": CommanClass.discountType.toString(),
      "repeat_every_custom": "",
      "repeat_type_custom": "",
      "cancel_overdue_reminders": overdue.toString(),
      "adminnote": CommanClass.adminNote.toString(),
      "item_select": '',
      "task_select": '',
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
      "task_id": '',
      "expense_id": '',
      "clientnote": '',
      "terms": '',
    };
    log("Invoice Parameters" + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.Create_Invoice, paramDic, "Post", Api_Key_by_Admin);
    log(response.body);
    var data = json.decode(response.body);
    // print('start'+data);
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
         ToastShowClass.coolToastShow(context, data['message'], CoolAlertType.success);
        Navigator.pop(context);
      });
    } else {
      setState(() {
         ToastShowClass.coolToastShow(context, data['message'], CoolAlertType.error);
      });
    }
  }

  @override
  void dispose() {
    CommanClassClear();
    CommanClass.navigatingData = null;
    super.dispose();
    selectedValue;
  }

  void _invoiceDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime(5050))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        CommanClass.currentDate = DateFormat("yyyy-MM-dd").format(value);
        _invoiceDateValue = CommanClass.currentDate;
      });
    });
  }

  void _dueDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime(5050))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        CommanClass.dueDate = DateFormat("yyyy-MM-dd").format(value);
        _dueDate = CommanClass.dueDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final contentPadding =
        EdgeInsets.only(left: width * 0.04, bottom: height * 0.025);
    return Scaffold(
      backgroundColor: ColorCollection.grey,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: FutureBuilder<String>(
            builder: (context, snapshot) {
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
                                'assets/second.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.03,
                            ),
                            Text(KeyValues.addinvoice,
                                style: ColorCollection.screenTitleStyle),
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
                      height: height * 0.05,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06,
                      ),
                      width: width,
                      decoration: kContaierDeco.copyWith(
                          color: ColorCollection.containerC),
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
                              items: items,
                              underline: '',

                              // value: CommanClass.Customername,
                              hint: _customer != null && _customer != -1
                                  ? _customer['company']
                                  : "Select one",
                              // validator: (value) {
                              //   if (value == null) {
                              //     return "This is required";
                              //   }
                              //   return null;
                              // },
                              onChanged: (value) {
                                print('Changed Value' + value[0].toString());
                                print('Customer Details' +
                                    customer[int.parse(value[0].toString())]
                                        .toString());

// final cust = customer.firstWhere((element) => element['userid'].toString() == value[0],orElse: () => -1,);
// print(cust);
                                setState(() {
                                  CommanClass.CustomerID =
                                      customer[int.parse(value.toString().split('/')[0].toString())]
                                              ['userid'] ??
                                          '';
                                  selectedValue = CommanClass.CustomerName;
                                  CommanClass.Billing_street =
                                      customer[int.parse(value.toString().split('/')[0].toString())]
                                              ['billing_street'] ??
                                          '';
                                  CommanClass.Billing_city =
                                      customer[int.parse(value.toString().split('/')[0].toString())]
                                              ['billing_city'] ??
                                          '';
                                  CommanClass.Billing_state =
                                      customer[int.parse(value.toString().split('/')[0].toString())]
                                              ['billing_state'] ??
                                          '';
                                  CommanClass.Billing_zip =
                                      customer[int.parse(value.toString().split('/')[0].toString())]
                                              ['billing_zip'] ??
                                          '';
                                  CommanClass.Billing_country =
                                      customer[int.parse(value.toString().split('/')[0].toString())]
                                              ['billing_country'] ??
                                          '';
                                  CommanClass.Shipping_street =
                                      customer[int.parse(value.toString().split('/')[0].toString())]
                                              ['shipping_street'] ??
                                          '';
                                  CommanClass.Shipping_city =
                                      customer[int.parse(value.toString().split('/')[0].toString())]
                                              ['shipping_city'] ??
                                          '';
                                  CommanClass.Shipping_state =
                                      customer[int.parse(value.toString().split('/')[0].toString())]
                                              ['shipping_state'] ??
                                          '';
                                  CommanClass.Shipping_zip =
                                      customer[int.parse(value.toString().split('/')[0].toString())]
                                              ['shipping_zip'] ??
                                          '';
                                  CommanClass.Shipping_country =
                                      customer[int.parse(value.toString().split('/')[0].toString())]
                                              ['shipping_country'] ??
                                          '';
                                  billingCountry =
                                      customer[int.parse(value.toString().split('/')[0].toString())]
                                              ['billing_countryname'] ??
                                          '';
                                  shippingCountry =
                                      customer[int.parse(value.toString().split('/')[0].toString())]
                                              ['shipping_countryname'] ??
                                          '';

                                  // print("selected"+customer[int.parse(selectedValue.toString().split('/')[0])].toString());
                                });
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Bill To",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Divider(
                                            color: ColorCollection.backColor),
                                        Text(
                                            "Street :" +
                                                CommanClass.Billing_street
                                                    .toString(),
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
                                                (billingCountry == null
                                                    ? ''
                                                    : billingCountry
                                                        .toString()),
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(fontSize: 10)),
                                        Text(
                                            "Zip :" +
                                                CommanClass.Billing_zip
                                                    .toString(),
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(fontSize: 10)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text("Ship To",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Divider(
                                            color: ColorCollection.backColor),
                                        Text(
                                            "Street : " +
                                                CommanClass.Shipping_street
                                                    .toString(),
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(fontSize: 10)),
                                        Text(
                                            "State/City :" +
                                                (CommanClass.Shipping_state ==
                                                        ""
                                                    ? ""
                                                    : CommanClass.Shipping_state
                                                        .toString()) +
                                                (CommanClass.Shipping_city == ""
                                                    ? ""
                                                    : "/ " +
                                                        CommanClass
                                                                .Shipping_city
                                                            .toString()),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 10)),
                                        Text(
                                            "Country :" +
                                                (shippingCountry == null
                                                    ? ''
                                                    : shippingCountry
                                                        .toString()),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 10)),
                                        Text(
                                            "Zip :" +
                                                CommanClass.Shipping_zip
                                                    .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 10))
                                      ],
                                    ),
                                  ],
                                )
                              : SizedBox(
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
                                      color: ColorCollection.backColor,
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
                                    child: Text(CommanClass.InvNo.toString())),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text('*${KeyValues.invocieDate}',
                              style: ColorCollection.titleStyleGreen),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.01),
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
                                      _invoiceDateValue == null
                                          ? KeyValues.selectInvoiceDate
                                          : '$_invoiceDateValue',
                                      style: ColorCollection.titleStyle),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Text('*${KeyValues.dueDate}',
                              style: ColorCollection.titleStyleGreen),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.01),
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
                                      _dueDate == null
                                          ? KeyValues.selectInvoiceDate
                                          : '$_dueDate',
                                      style: ColorCollection.titleStyle),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            children: [
                              Switch(
                                  activeColor: ColorCollection.green,
                                  value: valuesecond,
                                  onChanged: (newValue) {
                                    setState(() {
                                      valuesecond = newValue;
                                      if (valuesecond == true) {
                                        overdue = '1';
                                      } else {
                                        overdue = '0';
                                      }
                                    });
                                    print(overdue.toString());
                                  }),
                              SizedBox(
                                width: width * 0.7,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    KeyValues.preventSending,
                                    softWrap: true,
                                    style: ColorCollection.titleStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Text(KeyValues.allowPayment,
                              style: ColorCollection.titleStyleGreen),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            decoration: kDropdownContainerDeco,
                            child: DropdownButtonFormField(
                              hint: Text(KeyValues.selectone),
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
                              // value: CommanClass.selectedInvoicepayment,
                              items: payment.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item['name']),
                                  value: item['id'],
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  CommanClass.selectedInvoicepayment =
                                      newVal.toString();
                                });
                                print(CommanClass.selectedInvoicepayment
                                    .toString());
                              },
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
                              // value: _selectedValue,
                              onChanged: (newValue) {
                                setState(() {
                                  CommanClass.selectedInvoiceCurrency =
                                      newValue.toString();
                                });
                              },
                              items: currencyList.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item['name']),
                                  value: item['id'],
                                );
                              }).toList(),
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
                              iconSize: 20,
                              items: sales,
                              underline: SizedBox(),
                              value: selectsaleagent,
                              hint: "Select Sale Agent",
                              searchHint: "Select one",
                              onChanged: (value) {
                                if (value != null) {
                                  log(value.toString());
                                  setState(() {
                                    selectsaleagent = value;
                                    CommanClass.selectsaleagent = sale_agent[
                                        int.parse(selectsaleagent
                                            .toString()
                                            .split('/')[0])]['sale_agent'];
                                  });
                                  log('+++++' + CommanClass.selectsaleagent);
                                }
                              },
                              isExpanded: true,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(KeyValues.recuring,
                              style: ColorCollection.titleStyleGreen),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            decoration: kDropdownContainerDeco,
                            child: DropdownButtonFormField<RecInvoice>(
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
                              value: _selectRecInvoice,
                              onChanged: (Value) {
                                if (Value != null) {
                                  setState(() {
                                    _selectRecInvoice = Value;
                                    reccontroller.text =
                                        _selectRecInvoice!.id.toString();
                                    CommanClass.recInvoice =
                                        _selectRecInvoice!.num.toString();
                                    print("getposition :" +
                                        CommanClass.recInvoice);
                                  });
                                }
                              },
                              validator: (value) =>
                                  value == null ? 'Select Recrring Type' : null,
                              items: _recList.map((RecInvoice user) {
                                return DropdownMenuItem<RecInvoice>(
                                  value: user,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        user.num,
                                        style: TextStyle(fontSize: 14.0),
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
                                suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    )),
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
                              value: _selectDiscount,
                              onChanged: (Value) {
                                if (Value != null) {
                                  setState(() {
                                    _selectDiscount = Value;
                                    // discountcontroller =
                                    //     _selectDiscount.id.toString();
                                    CommanClass.discountType =
                                        _selectDiscount!.name.toString();
                                    // print("getposition :" +
                                    //     CommanClass.discount);
                                  });
                                }
                              },
                              validator: (value) =>
                                  value == null ? 'Select Discount' : null,
                              items: _discountList.map((Discount user) {
                                return DropdownMenuItem<Discount>(
                                  value: user,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        user.name,
                                        style: TextStyle(fontSize: 14.0),
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
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintStyle: kTextformHintStyle,
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
                                      blurStyle: BlurStyle.outer,
                                      blurRadius: 5)
                                ]),
                            child: Center(
                                child: Text(
                              '${KeyValues.totalItem} ' +
                                  neworderedList.length.toString(),
                              style: ColorCollection.titleStyle
                                  .copyWith(fontWeight: FontWeight.bold),
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
                                    suffixIcon: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        )),
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
                                  //  value: Selecteditems,
                                  onChanged: (Value) {
                                    if (Value != null) {
                                      setState(() {
                                        Selecteditems = Value;

                                        id = Value.id!;
                                        ADDNew_description.text =
                                            Value.description!;
                                        ADDNewlongdes.text =
                                            Value.longDescription!;
                                        AddNewRate.text = Value.rate!;
                                        CommanClass.tax = Value.tax!;
                                        CommanClass.TotalPrice =
                                            double.parse(Value.rate!).toInt();
                                        print("items   " +
                                            ADDNew_description.text.toString());
                                        open_dialog();
                                      });
                                    }
                                  },
                                  items: _productList.map((ItemsProduct user) {
                                    return DropdownMenuItem<ItemsProduct>(
                                      value: user,
                                      child: SizedBox(
                                        width: width * 0.3,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            user.description!,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  ADDNew_description.text = "";
                                  ADDNewlongdes.text = "";
                                  AddNewRate.text = "0.00";
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
                          sumAdd(),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          SizedBox(
                            height: height * 0.06,
                            width: width,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorCollection.green)),
                              onPressed: () {
                                setState(() {
                                  if (_formKey.currentState!.validate()) {
                                    InvoiceSaveData();
                                  }
                                });
                              },
                              child: Text(KeyValues.submit,
                                  style: ColorCollection.buttonTextStyle),
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
            },
          ),
        ),
      ),
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
            content: Text(neworderedList.isEmpty
                ? 'All Items Removed'
                : "The ${neworderedList[i].description} product is removed")));
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

                Text('\$' +
                    (neworderedList[i].rate == null
                            ? ""
                            : neworderedList[i].rate)
                        .toString()),
                Text(neworderedList[i].tax == null
                    ? ""
                    : neworderedList[i].tax!),
                // Container(
                //   height: 50,
                //   width: 70,
                //   child: NumberInputWithIncrementDecrement(
                //     // scaleWidth: 0.40,
                //     // scaleHeight: 0.60,
                //     controller: qtycontroller,
                //     initialValue:0,
                //   ),
                // ),
                Text('\$' + neworderedList[i].Total.toString()),
              ],
            ),
          ),
          Divider(
            color: ColorCollection.backColor,
          ),
        ],
      ),
    );
  }

  void open_dialog() {
    showDialog(
        barrierDismissible: true,
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
                          style: ColorCollection.titleStyleGreen,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: TextField(
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
                          style: ColorCollection.titleStyleGreen,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: TextField(
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
                            style: ColorCollection.titleStyleGreen,
                          ),
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: SizedBox(
                            height: 55,
                            width: 100,
                            child: NumberInputWithIncrementDecrement(
                              widgetContainerDecoration: kDropdownContainerDeco,
                              onIncrement: (num newlyIncrementedValue) {
                                setState(() {
                                  // Value_changeAmount(qty: newlyIncrementedValue.toString(),amount: AddNewRate.text);

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
                                  //   Value_changeAmount(qty:newlyDecrementedValue.toString(),amount: AddNewRate.text);
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
                            style: ColorCollection.titleStyleGreen,
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
                                color: ColorCollection.backColor,
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
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      CommanClass.percent = 00;
                      CommanClass.Discount = '';
                      CommanClass.Adjustment = "00";
                      print("Total Price" + CommanClass.TotalPrice.toString());
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

  Value_changeAmount({String? qty, String? amount}) {
    CommanClass.TotalPrice = (double.parse(amount!) * int.parse(qty!)).toInt();
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
      RecInvoice(1, 'No'),
      RecInvoice(2, 'Every 1 Month'),
      RecInvoice(3, 'Every 2 Month'),
      RecInvoice(4, 'Every 3 Month'),
      RecInvoice(5, 'Every 4 Month'),
      RecInvoice(6, 'Every 5 Month'),
      RecInvoice(7, 'Every 6 Month'),
      RecInvoice(8, 'Every 7 Month'),
      RecInvoice(9, 'Every 8 Month'),
      RecInvoice(10, 'Every 9 Month'),
      RecInvoice(11, 'Every 10 Month'),
      RecInvoice(12, 'Every 11 Month'),
      RecInvoice(13, 'Every 12 Month'),
      RecInvoice(14, 'Infinite'),
    ];
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
            decoration: widget.decoration,
            keyboardType: widget.keyboardType,
            onChanged: (value) {
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

CommanClassClear() {
  CommanClass.Customername = '';
  CommanClass.CustomerID = '';
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
  CommanClass.selectedInvoiceCurrency;
  CommanClass.selectedInvoicepayment;
  CommanClass.currentDate = '';
  CommanClass.dueDate = '';
  CommanClass.selectedValuesJson = '';
  CommanClass.selectsaleagent = "";
  CommanClass.recInvoice = "";
  CommanClass.adminNote = "";
  CommanClass.tags = "";
  CommanClass.discountType = "";
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
