// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, avoid_print, import_of_legacy_library_into_null_safe, prefer_if_null_operators, unnecessary_null_comparison, deprecated_member_use, must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:lbm_crm/Customer/add_new_customers.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';

import '../Invoice/invoiceView.dart';
import '../util/routesArguments.dart';

class AddNewProposalScreen extends StatefulWidget {
  static const id = '/AddNewProposals';
  var data;
  AddNewProposalScreen({this.data});

  @override
  State<AddNewProposalScreen> createState() => _AddNewProposalScrenState();
}

class _AddNewProposalScrenState extends State<AddNewProposalScreen> {
  List currencyList = [];

  List<Discount> _discountList = Discount.getDiscount();

  final statuscontroller = TextEditingController();

  String status = "";

  TextEditingController customercontroller = TextEditingController();

  TextEditingController reccontroller = TextEditingController();

  TextEditingController referencecontroller = TextEditingController();

  final List<DropdownMenuItem> assigned = [];
  final List<DropdownMenuItem> country = [];
  List<DropdownMenuItem> _relation = [];
  // final List<DropdownMenuItem> _Customer_relation = [];

  List Propsal_Status = [];
  List Propsal_Assigned = [];
  List Propsal_Relation = [];
  List Propsal_Country = [];
  // String selectedValue;

  String? selectAssigned;
  String? selectRelation;
  // String selectCustomerRelation;

  final _formKey = GlobalKey<FormState>();

  List payment = [];

  List sale_agent = [];

  Discount? _selectDiscount;

  bool valuefirst = false;

  bool valuesecond = false;

  // List<Language> _selectedLanguages;

  String tags = "";

  Future? myFuture;

  final AddItemcontroller = TextEditingController();

  TextEditingController qtycontroller = TextEditingController(text: "1");

  TextEditingController taxcontroller = TextEditingController();

  TextEditingController discontroller = TextEditingController();

  TextEditingController adjustcontroler = TextEditingController();

  TextEditingController ADDNew_description = TextEditingController();

  TextEditingController ADDNewlongdes = TextEditingController();

  TextEditingController AddNewRate = TextEditingController();

  TextEditingController Subject = TextEditingController();

  final addresscontroller = TextEditingController();
  final citycontroller = TextEditingController();
  final zipscontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  final countrycontroller = TextEditingController();
  final statecontroller = TextEditingController();
  final To = TextEditingController();

  final relatedcontroller = TextEditingController();

  List<Related> _relatedList = Related.getRelated();

  String? id;

  ItemsProduct? Selecteditems;

  List ProductItem = [];

  List<ItemsProduct> _productList = [];

  String? Selectitems;

  List<ItemsProduct> orderedList = [];

  List<ItemsProduct> neworderedList = [];
  bool loading = false;
  bool Selected = false;
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  List<ItemsProduct> jsonlist = [];

  void _datTimePickerDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1947),
            lastDate: DateTime(5050))
        .then((date) {
      if (date != null) {
        setState(() {
          CommanClass.currentDate = DateFormat("yyyy-MM-dd").format(date);
          //Date = new DateFormat("dd-MM-yyyy").format(date);
          print(CommanClass.currentDate);
          // print(new DateFormat("dd-MM-yyyy").format(date));
          // initState();
        });
      }
    });
  }

  void _duedatTimePickerDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1947),
            lastDate: DateTime(5050))
        .then((date) {
      if (date != null) {
        setState(() {
          CommanClass.dueDate = DateFormat("yyyy-MM-dd").format(date);
          //Date = new DateFormat("dd-MM-yyyy").format(date);
          print(CommanClass.dueDate);
          // print(new DateFormat("dd-MM-yyyy").format(date));
          // initState();
        });
      }
    });
  }

  getinfo() {
    if (widget.data != null) {
      final data = widget.data;
      Subject.text = data['subject'] ?? '';
      To.text = data['proposal_to'] ?? '';
      addresscontroller.text = data['address'] ?? '';
      citycontroller.text = data['city'] ?? '';
      statecontroller.text = data['state'] ?? '';
      countrycontroller.text = data['country'] ?? '';
      zipscontroller.text = data['zip'] ?? '';
      phonecontroller.text = data['phone'] ?? '';
      emailcontroller.text = data['email'] ?? '';
      CommanClass.currentDate = data['date'] ?? '';
      CommanClass.dueDate = data['open_till'] ?? '';
      isSwitched = data['allow_comments'] == '1' ? true : false;
    }
  }

  @override
  void initState() {
    myFuture = getProposal();
    CommanClass.currentDate = DateTime.now().toString().split(" ")[0];
    CommanClass.dueDate =
        DateTime.now().add(Duration(days: 7)).toString().split(" ")[0];
    Propsal_Relation.clear();
    sale_agent.clear();
    getItems();
    getCountries();
    orderedList.clear();
    CommanClass.Discount = 'null';
    CommanClass.Adjustment = 'null';
    getinfo();
    super.initState();
  }

  final List<String> chooseDiscountitems = <String>['Percent', 'Fixed Amount'];

  String? selectedItem;
  CountryField? _selectCountry;
  List countryfield = [];
  List<CountryField> _Country = [];

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
      CommanClass.Discount = discontroller.text;
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

  Future<void> getProposal() async {
    final paramDic = {
      "type": '',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.New_Proposal, paramDic, "Get", Api_Key_by_Admin);
    log(response.body);
    var data = json.decode(response.body);
    print('Start' + data.toString());
    if (response.statusCode == 200) {
      currencyList = data['data']['currencies'];
      Propsal_Status = data['data']['status'];
      Propsal_Assigned = data['data']['Assigned'];
      setState(() {
        for (int i = 0; i < Propsal_Assigned.length; i++) {
          assigned.add(DropdownMenuItem(
            child: Text(Propsal_Assigned[i]['sale_agent']),
            value: i.toString() +
                "/" +
                Propsal_Assigned[i]['sale_agent'] +
                "/" +
                Propsal_Assigned[i]['sale_agent'],
          ));
        }
        print(assigned.toString() + "sales");
      });
    } else {}
  }

  Future<void> getCountries() async {
    final paramDic = {
      "type": "country",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    countryfield.clear();
    _Country.clear();
    if (response.statusCode == 200) {
      countryfield.add(data['data']);

      for (int i = 0; i < countryfield[0].length; i++) {
        setState(() {
          _Country.add(
            CountryField(
              countryfield[0][i]['country_id'].toString(),
              countryfield[0][i]['short_name'].toString(),
            ),
          );
        });
      }
    } else {}
  }

  Future<void> getRelation(String relation) async {
    final paramDic = {
      "type": relation.toString(),
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.Relation_Data, paramDic, "Post", Api_Key_by_Admin);
    Propsal_Relation = [];
    _relation = [];
    selectRelation = "";
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          Propsal_Relation = data['data'];
          for (int i = 0; i < Propsal_Relation.length; i++) {
            _relation.add(DropdownMenuItem(
              child: Text(Propsal_Relation[i]['company']),
              value: i.toString() +
                  "/" +
                  Propsal_Relation[i]['id'] +
                  "/" +
                  Propsal_Relation[i]['name'],
            ));
          }
        });
      }
    } else {
      print(response.statusCode);
    }
  }

  void getItems() async {
    final paramDic = {
      "type": '',
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.New_Proposal, paramDic, "Get", Api_Key_by_Admin);
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
      });
    } else {
      throw Exception('Failed to load invoice');
    }
  }

  Related? _selectRelated;

  Future<void> ProposalSaveData() async {
    final paramDic = {
      "subject": Subject.text.toString(),
      "rel_type": CommanClass.Related.toString(),
      "rel_id": CommanClass.userid.toString(),
      "date": CommanClass.currentDate.toString(),
      "open_till": CommanClass.dueDate.toString(),
      "currency": CommanClass.selectedInvoiceCurrency.toString(),
      "discount_type": CommanClass.discountType.toString(),
      "tags": '',
      "allow_comments": isSwitched ? '1' : '0',
      "status": CommanClass.selectedEstimateStatus.toString(),
      "assigned": CommanClass.selectsaleagent.toString(),
      "proposal_to": To.text.toString(),
      "address": addresscontroller.text.toString(),
      "city": citycontroller.text.toString(),
      "state": statecontroller.text.toString(),
      "country": countrycontroller.text.toString(),
      "zip": zipscontroller.text.toString(),
      "email": emailcontroller.text.toString(),
      "phone": phonecontroller.text.toString(),
      "item_select": "",
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
    };
    print("Proposal Param" + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(
        Base_Url_For_App,
        APIClasses.Create_Proposal +
            (widget.data != null ? '/${widget.data['id']}' : ''),
        paramDic,
        "Post",
        Api_Key_by_Admin);
    var data = json.decode(response.body);
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
        loading = true;
       ToastShowClass.coolToastShow(context, data['message'], CoolAlertType.success);
        Navigator.pop(context);
      });
    } else {
      setState(() {
       ToastShowClass.coolToastShow(context, data['message'], CoolAlertType.error);
      });
    }
  }

  _selectOne() {
    if (_selectRelated!.id == 1) {
      selectRelation = "";
      getRelation("lead");
      return Lead();
    } else if (_selectRelated!.id == 2) {
      selectRelation = "";
      getRelation("customer");
      return Lead();
    }
    return Container(
      height: 5,
    );
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  @override
  void dispose() {
    CommanClassClear();
    _Country.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final contentPadding =
        EdgeInsets.only(left: width * 0.01, right: width * 0.01);
    return Scaffold(
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
                    Row(
                      children: [
                        SizedBox(
                          height: height * 0.07,
                          width: width * 0.13,
                          child: Image.asset(
                            'assets/third.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Text(
                            widget.data != null
                                ? 'Edit Proposal'.toUpperCase()
                                : KeyValues.addNewProposal,
                            style: ColorCollection.screenTitleStyle),
                      ],
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
            FutureBuilder(builder: (context, snapshot) {
              return Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06,
                  ),
                  width: width,
                  decoration:
                      kContaierDeco.copyWith(color: ColorCollection.containerC),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: widget.data != null
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.end,
                        children: [
                          if (widget.data != null)
                            SizedBox(
                              height: height * 0.04,
                              // width: width,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        ColorCollection.green)),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      InvoiceView.id,
                                      arguments: Proposalinvoice(
                                          url: 'https://' +
                                              APIClasses.BaseURL +
                                              '/crm/proposal/' +
                                              widget.data['id'].toString() +
                                              '/' +
                                              widget.data['hash'].toString(),
                                          Title: 'Proposal View'));
                                },
                                child: Text(
                                  'View PDF',
                                  style: ColorCollection.buttonTextStyle,
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Switch(
                                  activeColor: ColorCollection.green,
                                  value: isSwitched,
                                  onChanged: toggleSwitch),
                              Text(KeyValues.allowComment,
                                  style: ColorCollection.subTitleStyle2)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      Text(KeyValues.subject,
                          style: ColorCollection.titleStyle2),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                        height: height * 0.06,
                        decoration: kDropdownContainerDeco,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty || value == '0') {
                              return 'This field is reqiured';
                            }
                            return null;
                          },
                          controller: Subject,
                          style: kTextformStyle,
                          decoration: InputDecoration(
                            contentPadding: contentPadding,
                            hintText: KeyValues.enterSubject,
                            hintStyle: kTextformHintStyle,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text('*${KeyValues.related}',
                          style: ColorCollection.titleStyle2),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        decoration: kDropdownContainerDeco,
                        child: DropdownButtonFormField<Related>(
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
                          value: _selectRelated,
                          onChanged: (Value) {
                            setState(() {
                              _selectRelated = Value;
                              relatedcontroller.text =
                                  _selectRelated!.id.toString();
                              CommanClass.Related =
                                  _selectRelated!.name.toString();
                            });
                          },
                          validator: (value) =>
                              value == null ? 'This field is required' : null,
                          items: _relatedList.map((Related user) {
                            return DropdownMenuItem<Related>(
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
                      SizedBox(height: height * 0.02),
                      _selectRelated != null
                          ? Text(
                              _selectRelated!.id == 1 ? "* Lead" : "* Customer",
                              style: ColorCollection.titleStyle2,
                            )
                          : SizedBox(),
                      _selectRelated != null
                          ? SizedBox(height: height * 0.02)
                          : SizedBox(),
                      Container(
                          decoration: kDropdownContainerDeco,
                          child: _selectRelated != null
                              ? _selectOne()
                              : SizedBox(
                                  height: 1,
                                )),
                      SizedBox(height: height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _datTimePickerDialog();
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: ColorCollection.backColor,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    Text('*${KeyValues.date}',
                                        style: ColorCollection.titleStyle),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.01),
                                  height: height * 0.06,
                                  width: width * 0.4,
                                  decoration: kDropdownContainerDeco,
                                  child: Center(
                                    child: Text(CommanClass.currentDate,
                                        style: ColorCollection.subTitleStyle),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _duedatTimePickerDialog();
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: ColorCollection.backColor,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    Text('*${KeyValues.openTill}',
                                        style: ColorCollection.titleStyle),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.01),
                                  height: height * 0.06,
                                  width: width * 0.4,
                                  decoration: kDropdownContainerDeco,
                                  child: Center(
                                    child: Text(CommanClass.dueDate,
                                        style: ColorCollection.subTitleStyle),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                      Text(
                        KeyValues.currency,
                        style: ColorCollection.titleStyle2,
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
                          validator: (value) =>
                              value == null ? 'Please select currency' : null,
                          // value: CommanClass.selectedInvoiceCurrency,
                          items: currencyList.map((item) {
                            return DropdownMenuItem(
                              child: Text(item['name']),
                              value: item['id'],
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            if (newVal != null) {
                              setState(() {
                                CommanClass.selectedInvoiceCurrency =
                                    newVal.toString();
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                KeyValues.discountType,
                                style: ColorCollection.titleStyle2,
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                decoration: kDropdownContainerDeco,
                                width: width * 0.4,
                                child: DropdownButtonFormField<Discount>(
                                  hint: Text(KeyValues.select),
                                  style: ColorCollection.titleStyle,
                                  elevation: 8,
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
                                  value: _selectDiscount,
                                  onChanged: (Value) {
                                    setState(() {
                                      _selectDiscount = Value;
                                      // discountcontroller =
                                      //     _selectDiscount.id.toString();
                                      CommanClass.discountType =
                                          _selectDiscount!.name.toString();
                                      // print("getposition :" +
                                      //     CommanClass.discount);
                                    });
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
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                KeyValues.status,
                                style: ColorCollection.titleStyle2,
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                decoration: kDropdownContainerDeco,
                                width: width * 0.4,
                                child: DropdownButtonFormField(
                                  hint: Text(KeyValues.selectStatus),
                                  style: ColorCollection.titleStyle,
                                  elevation: 8,
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
                                  validator: (value) => value == null
                                      ? 'Please select status'
                                      : null,
                                  // value: CommanClass.selectedEstimateStatus,
                                  items: Propsal_Status.map((item) {
                                    return DropdownMenuItem(
                                        child: Text(item['status_name']),
                                        value: item['status_id']);
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      CommanClass.selectedEstimateStatus =
                                          newVal as int;
                                      // print("check status  ? "+CommanClass.selectedEstimateStatus);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        KeyValues.assigned,
                        style: ColorCollection.titleStyle2,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                        decoration: kDropdownContainerDeco,
                        child: SearchableDropdown.single(
                          underline: '',
                          items: assigned,
                          value: selectAssigned,
                          hint: "Select",
                          searchHint: "Select",
                          onChanged: (value) {
                            setState(() {
                              selectAssigned = value;
                              CommanClass
                                  .selectsaleagent = Propsal_Assigned[int.parse(
                                      selectAssigned.toString().split('/')[0])]
                                  ['sale_agent'];
                            });
                          },
                          isExpanded: true,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: height * 0.06,
                            width: width * 0.42,
                            decoration: kDropdownContainerDeco,
                            child: TextFormField(
                              controller: To,
                              style: kTextformStyle,
                              decoration: InputDecoration(
                                contentPadding: contentPadding,
                                hintText: KeyValues.To,
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            height: height * 0.06,
                            width: width * 0.42,
                            decoration: kDropdownContainerDeco,
                            child: TextFormField(
                              controller: addresscontroller,
                              style: kTextformStyle,
                              decoration: InputDecoration(
                                contentPadding: contentPadding,
                                hintText: KeyValues.address,
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: height * 0.06,
                            width: width * 0.42,
                            decoration: kDropdownContainerDeco,
                            child: TextFormField(
                              controller: citycontroller,
                              style: kTextformStyle,
                              decoration: InputDecoration(
                                contentPadding: contentPadding,
                                hintText: KeyValues.city,
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            width: width * 0.42,
                            decoration: kDropdownContainerDeco,
                            child: DropdownButtonFormField<CountryField>(
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
                              value: _selectCountry,
                              onChanged: (CountryField? Value) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _selectCountry = Value;
                                  CommanClass.country_id = _selectCountry!.id;
                                });
                              },
                              items: _Country.map((CountryField user) {
                                return DropdownMenuItem<CountryField>(
                                  value: user,
                                  child: SizedBox(
                                    width: width * 0.25,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        user.name,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: height * 0.06,
                            width: width * 0.42,
                            decoration: kDropdownContainerDeco,
                            child: TextFormField(
                              style: kTextformStyle,
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              controller: zipscontroller,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: width * 0.01, bottom: height * 0.005),
                                hintText: KeyValues.zipCode,
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            height: height * 0.06,
                            width: width * 0.42,
                            decoration: kDropdownContainerDeco,
                            child: TextFormField(
                              style: kTextformStyle,
                              controller: emailcontroller,
                              decoration: InputDecoration(
                                contentPadding: contentPadding,
                                hintText: KeyValues.Email,
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        height: height * 0.06,
                        width: width,
                        decoration: kDropdownContainerDeco,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: phonecontroller,
                          style: kTextformStyle,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: width * 0.01, right: width * 0.01),
                            hintText: KeyValues.Phone,
                            hintStyle: kTextformHintStyle,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.06,
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
                          style: ColorCollection.titleStyle
                              .copyWith(fontWeight: FontWeight.w700),
                        )),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '*${KeyValues.chooseItem}',
                            style: ColorCollection.titleStyle2
                                .copyWith(color: ColorCollection.green),
                          ),
                          Text(
                            '*${KeyValues.addItem}',
                            style: ColorCollection.titleStyle2
                                .copyWith(color: ColorCollection.green),
                          ),
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
                            width: width * 0.7,
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
                              onChanged: (Value) {
                                setState(() {
                                  Selecteditems = Value;

                                  id = Value!.id;
                                  ADDNew_description.text = Value.description!;
                                  ADDNewlongdes.text = Value.longDescription!;
                                  AddNewRate.text = Value.rate!;
                                  CommanClass.tax = Value.tax!;
                                  CommanClass.TotalPrice =
                                      double.parse(Value.rate!).toInt();
                                  open_dialog();
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'Please select one' : null,
                              items: _productList.map((ItemsProduct user) {
                                return DropdownMenuItem<ItemsProduct>(
                                  value: user,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        user.description!,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
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
                      SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height *
                              neworderedList.length /
                              4.8,
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
                            setState(() {
                              if (_formKey.currentState!.validate()) {
                                loading = false;
                                ProposalSaveData();
                              } else {
                                loading = true;
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
                        height: height * 0.06,
                      ),
                    ],
                  ),
                ),
              );
            })
          ],
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
                          decoration: InputDecoration(border: InputBorder.none),
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
                          decoration: InputDecoration(border: InputBorder.none),
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
                            widgetContainerDecoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorCollection.backColor)),
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
                  SizedBox(height: 5.0),
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
                              qty: qtycontroller.text, amount: AddNewRate.text),
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
                    print("Total Price" + CommanClass.TotalPrice.toString());
                    Selected = true;
                    Navigator.of(ctx).pop();
                    setState(() {
                      CommanClass.qty = qtycontroller.text;
                      CommanClass.TotalPrice = (double.parse(AddNewRate.text) *
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
                            (orderedList[i].Total! + CommanClass.sum);
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
            ));
          });
        }).then((value) => setState(() {
          neworderedList.clear();
          neworderedList.addAll(orderedList);
        }));
  }

  Widget Lead() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchableDropdown.single(
            items: _relation,
            value: selectRelation,
            hint: "Select",
            style: ColorCollection.titleStyle,
            underline: '',
            validator: (value) {
              if (value == null) {
                return 'This field is required';
              }
              return null;
            },
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectRelation = value;
                  CommanClass.userid = Propsal_Relation[
                      int.parse(selectRelation.toString().split('/')[0])]['id'];
                  CommanClass.itemselect = Propsal_Relation[
                          int.parse(selectRelation.toString().split('/')[0])]
                      ['company'];
                  To.text = Propsal_Relation[
                          int.parse(selectRelation.toString().split('/')[0])]
                      ['name'];
                  addresscontroller.text = Propsal_Relation[
                          int.parse(selectRelation.toString().split('/')[0])]
                      ['address'];
                  emailcontroller.text = Propsal_Relation[
                          int.parse(selectRelation.toString().split('/')[0])]
                      ['email'];
                  zipscontroller.text = Propsal_Relation[
                          int.parse(selectRelation.toString().split('/')[0])]
                      ['zip'];
                  countrycontroller.text = _selectCountry!.name.toString();
                  statecontroller.text = Propsal_Relation[
                          int.parse(selectRelation.toString().split('/')[0])]
                      ['state'];
                  citycontroller.text = Propsal_Relation[
                          int.parse(selectRelation.toString().split('/')[0])]
                      ['city'];
                  phonecontroller.text = Propsal_Relation[
                          int.parse(selectRelation.toString().split('/')[0])]
                      ['phone'];
                });
              }
            },
            isExpanded: true,
          )
        ]);
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

class Related {
  int id;
  String name;

  Related(this.id, this.name);

  static List<Related> getRelated() {
    return <Related>[
      Related(1, 'Lead'),
      Related(2, 'Customer'),
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
