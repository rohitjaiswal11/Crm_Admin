// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, avoid_print, import_of_legacy_library_into_null_safe, prefer_if_null_operators, must_be_immutable, prefer_is_empty, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Customer/customers_screen.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';

import '../Plugin/lbmplugin.dart';

//controller initialization
final usernamecontroller = TextEditingController();
final fullnamecontroller = TextEditingController();
final companynamecontroller = TextEditingController();
final gstinnumbercontroller = TextEditingController();
final phonenumbercontroller = TextEditingController();
final websitecontroller = TextEditingController();
final groupcontroller = TextEditingController();
final currencycontroller = TextEditingController();
final addressdetailcontroller = TextEditingController();
final citydetailcontroller = TextEditingController();
final statedetailcontroller = TextEditingController();
final zipcodedetailcontroller = TextEditingController();
final countryDetailFieldcontroller = TextEditingController();

final streetBillingFieldcontroller = TextEditingController();
final cityBillingFieldcontroller = TextEditingController();
final stateBillingFieldcontroller = TextEditingController();
final zipcodeBillingFieldcontroller = TextEditingController();
final countryBillingFieldcontroller = TextEditingController();

final sameasFieldcontroller = TextEditingController();

final streetShippingFieldcontroller = TextEditingController();
final cityShippingFieldcontroller = TextEditingController();
final stateShippingFieldcontroller = TextEditingController();
final zipcodeShippingFieldcontroller = TextEditingController();
final countryShippingFieldcontroller = TextEditingController();

String saveupdate = 'Save';
String Staffid = '';
String UserID = '';
final _formKeyAddress = GlobalKey<FormState>();
final _formKeyAddressShipping = GlobalKey<FormState>();
String CustomerID = '';

class NewCustomer extends StatefulWidget {
  static const id = '/newcustomer';
  List CustomerProfile = [];
  NewCustomer({required this.CustomerProfile});
  @override
  NewCustomerState createState() => NewCustomerState();
}

class NewCustomerState extends State<NewCustomer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();

    if (widget.CustomerProfile == null) {
      setState(() {
        //new data clear all the controller
        saveupdate = "Save";

        usernamecontroller.text = '';
        fullnamecontroller.text = '';
        companynamecontroller.text = '';
        gstinnumbercontroller.text = '';
        phonenumbercontroller.text = '';
        websitecontroller.text = '';
        groupcontroller.text = '';
        currencycontroller.text = '';
        addressdetailcontroller.text = '';
        citydetailcontroller.text = '';
        statedetailcontroller.text = '';
        zipcodedetailcontroller.text = '';
        countryDetailFieldcontroller.text = '';

        streetBillingFieldcontroller.text = '';
        cityBillingFieldcontroller.text = '';
        stateBillingFieldcontroller.text = '';
        zipcodeBillingFieldcontroller.text = '';
        countryBillingFieldcontroller.text = '';

        sameasFieldcontroller.text = '';

        streetShippingFieldcontroller.text = '';
        cityShippingFieldcontroller.text = '';
        stateShippingFieldcontroller.text = '';
        zipcodeShippingFieldcontroller.text = '';
        countryShippingFieldcontroller.text = '';
      });
    } else {
      //update data fill automatic
      setState(() {
        print(widget.CustomerProfile);
        saveupdate = "Update";

        CustomerID = widget.CustomerProfile[0]['userid'].toString();
        UserID = widget.CustomerProfile[0]['userid'].toString();
        usernamecontroller.text = '';
        fullnamecontroller.text = '';
        companynamecontroller.text =
            widget.CustomerProfile[0]['company'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['company'].toString();
        gstinnumbercontroller.text =
            widget.CustomerProfile[0]['vat'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['vat'].toString();
        phonenumbercontroller.text =
            widget.CustomerProfile[0]['phonenumber'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['phonenumber'].toString();
        websitecontroller.text =
            widget.CustomerProfile[0]['website'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['website'].toString();
        groupcontroller.text =
            widget.CustomerProfile[0]['website'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['website'].toString();
        currencycontroller.text =
            widget.CustomerProfile[0]['default_currency'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['default_currency'].toString();
        addressdetailcontroller.text =
            widget.CustomerProfile[0]['address'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['address'].toString();
        citydetailcontroller.text =
            widget.CustomerProfile[0]['city'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['city'].toString();
        statedetailcontroller.text =
            widget.CustomerProfile[0]['state'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['state'].toString();
        zipcodedetailcontroller.text =
            widget.CustomerProfile[0]['zip'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['zip'].toString();
        countryDetailFieldcontroller.text =
            widget.CustomerProfile[0]['country'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['country'].toString();

        streetBillingFieldcontroller.text =
            widget.CustomerProfile[0]['billing_street'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['billing_street'].toString();
        cityBillingFieldcontroller.text =
            widget.CustomerProfile[0]['billing_city'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['billing_city'].toString();
        stateBillingFieldcontroller.text =
            widget.CustomerProfile[0]['billing_state'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['billing_state'].toString();
        zipcodeBillingFieldcontroller.text =
            widget.CustomerProfile[0]['billing_zip'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['billing_zip'].toString();
        countryBillingFieldcontroller.text =
            widget.CustomerProfile[0]['billing_country'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['billing_country'].toString();

        sameasFieldcontroller.text = '';

        streetShippingFieldcontroller.text =
            widget.CustomerProfile[0]['shipping_street'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['shipping_street'].toString();
        cityShippingFieldcontroller.text =
            widget.CustomerProfile[0]['shipping_city'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['shipping_city'].toString();
        stateShippingFieldcontroller.text =
            widget.CustomerProfile[0]['shipping_state'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['shipping_state'].toString();
        zipcodeShippingFieldcontroller.text =
            widget.CustomerProfile[0]['shipping_zip'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['shipping_zip'].toString();
        countryShippingFieldcontroller.text =
            widget.CustomerProfile[0]['shipping_country'].toString() == null
                ? ''
                : widget.CustomerProfile[0]['shipping_country'].toString();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    streetBillingFieldcontroller.clear();
    cityBillingFieldcontroller.clear();
    stateBillingFieldcontroller.clear();
    zipcodeBillingFieldcontroller.clear();
    countryBillingFieldcontroller.clear();
    streetShippingFieldcontroller.clear();
    cityShippingFieldcontroller.clear();
    stateShippingFieldcontroller.clear();
    zipcodeShippingFieldcontroller.clear();
    countryShippingFieldcontroller.clear();
    saveupdate = 'Save';
    Staffid = '';
    UserID = '';
    CustomerID = '';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorCollection.grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: height * 0.23,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  decoration: BoxDecoration(
                    color: ColorCollection.backColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/robo.png'),
                              fit: BoxFit.fill),
                        ),
                        height: height * 0.12,
                        width: width * 0.17,
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      FittedBox(
                        child: Text(KeyValues.addNewCustomer,
                            softWrap: true,
                            style: ColorCollection.screenTitleStyle),
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
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.21,
                    left: width * 0.025,
                    right: width * 0.025,
                  ),
                  child: Container(
                    height: height * 0.04,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 5)
                        ]),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: ColorCollection.backColor,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      labelStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 12,
                      ),
                      unselectedLabelColor: Colors.grey.shade600,
                      onTap: (_) {
                        setState(() {
                          _tabController.index;
                        });
                      },
                      tabs: [
                        Text(
                          "${KeyValues.detail}s",
                          softWrap: true,
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          KeyValues.fields,
                          softWrap: true,
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          KeyValues.address,
                          softWrap: true,
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              decoration:
                  kContaierDeco.copyWith(color: ColorCollection.containerC),
              height: height * 1.02,
              width: width,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Details Tab
                  AddNewCustomersDetails(),
                  //Fields Tab
                  FieldScreen(),

                  // Address Tab
                  AddNewCustomerAddress(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add New Customer Details Tab
class AddNewCustomersDetails extends StatefulWidget {
  const AddNewCustomersDetails({Key? key}) : super(key: key);

  @override
  _AddNewCustomersDetailsState createState() => _AddNewCustomersDetailsState();
}

class _AddNewCustomersDetailsState extends State<AddNewCustomersDetails> {
  CountryField? _selectCountry;
  List countryfield = [];
  List<CountryField> _Country = [];
  Groups? _selectgroup;
  List groupfield = [];
  List<Groups> _group = [];

  Currency? _selectCurrency;
  List currencyfield = [];
  List<Currency> _currencyList = [];

  Future<void> getCountries() async {
    final paramDic = {
      "type": "country",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    // log(response.body.toString());
    countryfield.clear();
    _Country.clear();
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Load Data', Colors.red);
        }
      } catch (e) {
        ToastShowClass.toastShow(null, 'Failed to Load Data', Colors.red);
      }
      countryfield.add(data['data']);

      for (int i = 0; i < countryfield[0].length; i++) {
        if (mounted) {
          setState(() {
            _Country.add(
              CountryField(
                countryfield[0][i]['country_id'].toString(),
                countryfield[0][i]['short_name'].toString(),
              ),
            );
          });
        }
      }
    } else {}
  }

  Future<void> getGroups() async {
    final paramDic = {
      "type": "group",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    log('Gropus -- > ' + response.body.toString());
    groupfield.clear();
    _group.clear();
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Load Data', Colors.red);
        }
        groupfield.add(data['data']);
      } catch (e) {
        ToastShowClass.toastShow(null, 'Failed to Load Data', Colors.red);
      }
      ;

      for (int i = 0; i < groupfield[0].length; i++) {
        if (mounted) {
          setState(() {
            _group.add(
              Groups(
                groupfield[0][i]['id'].toString(),
                groupfield[0][i]['name'].toString(),
              ),
            );
          });
        }
      }
    } else {}
  }

  Future<void> getCurrency() async {
    final paramDic = {
      "type": "currency",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    currencyfield.clear();
    _currencyList.clear();
    if (response.statusCode == 200) {
      currencyfield = data['data'];

      for (int i = 0; i < currencyfield[0].length - 1; i++) {
        if (mounted) {
          setState(() {
            _currencyList.add(Currency(currencyfield[i]['id'].toString(),
                currencyfield[i]['name'].toString()));
          });
        }
      }
    } else {}
  }

  @override
  void initState() {
    getCountries();
    getCurrency();
    getGroups();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _currencyList.clear();
    currencyfield.clear();
    _Country.clear();
    countryfield.clear();
    companynamecontroller.clear();
    gstinnumbercontroller.clear();
    phonenumbercontroller.clear();
    websitecontroller.clear();
    currencycontroller.clear();

    addressdetailcontroller.clear();
    citydetailcontroller.clear();
    statedetailcontroller.clear();
    zipcodedetailcontroller.clear();
    countryDetailFieldcontroller.clear();
  }

  final _formKeyDetail = GlobalKey<FormState>();
  int _state = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final contentPadding = EdgeInsets.only(
      left: width * 0.005,
      right: width * 0.005,
    );
    return Form(
      key: _formKeyDetail,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.05),
        decoration: kContaierDeco.copyWith(color: ColorCollection.containerC),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              KeyValues.enterDetails,
              style: ColorCollection.titleStyle2,
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the company name';
                      }
                      return null;
                    },
                    controller: companynamecontroller,
                    style: kTextformStyle,
                    decoration: InputDecoration(
                      contentPadding: contentPadding,
                      hintText: KeyValues.companyName,
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
                    controller: websitecontroller,
                    decoration: InputDecoration(
                      contentPadding: contentPadding,
                      hintText: KeyValues.website,
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
                    controller: gstinnumbercontroller,
                    style: kTextformStyle,
                    decoration: InputDecoration(
                      contentPadding: contentPadding,
                      hintText: KeyValues.gstnumber,
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the phone number';
                      }
                      return null;
                    },
                    controller: phonenumbercontroller,
                    maxLength: 10,
                    style: kTextformStyle,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: width * 0.01, bottom: height * 0.005),
                      hintText: KeyValues.phoneNumber,
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
            Text(
              '${KeyValues.groups}-',
              style: ColorCollection.titleStyleGreen,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              decoration: kDropdownContainerDeco,
              child: DropdownButtonFormField(
                hint: Text('System Default'),
                style: ColorCollection.titleStyle,
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
                value: _selectgroup,
                onChanged: (Groups? newValue) {
                  setState(() {
                    _selectgroup = newValue;
                    groupcontroller.text = _selectgroup!.id;
                  });
                },
                items: _group.map((item) {
                  return DropdownMenuItem(
                    child: Text(item.name),
                    value: item,
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Text('${KeyValues.currency}-',
                style: ColorCollection.titleStyleGreen),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              decoration: kDropdownContainerDeco,
              child: DropdownButtonFormField<Currency>(
                hint: Text(KeyValues.systemDefault),
                style: ColorCollection.titleStyle,
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
                value: _selectCurrency,
                onChanged: (Currency? Value) {
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _selectCurrency = Value;
                    currencycontroller.text = _selectCurrency!.id;
                  });
                },
                items: _currencyList.map((Currency user) {
                  return DropdownMenuItem<Currency>(
                    value: user,
                    child: Text(
                      user.name,
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              height: height * 0.06,
              width: width * 0.9,
              decoration: kDropdownContainerDeco,
              child: TextFormField(
                controller: addressdetailcontroller,
                style: kTextformStyle,
                decoration: InputDecoration(
                  contentPadding: contentPadding,
                  hintText: KeyValues.address,
                  hintStyle: kTextformHintStyle,
                  border: InputBorder.none,
                ),
              ),
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
                    controller: citydetailcontroller,
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
                  height: height * 0.06,
                  width: width * 0.42,
                  decoration: kDropdownContainerDeco,
                  child: TextFormField(
                    controller: statedetailcontroller,
                    style: kTextformStyle,
                    decoration: InputDecoration(
                      contentPadding: contentPadding,
                      hintText: KeyValues.state,
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
              width: width * 0.9,
              decoration: kDropdownContainerDeco,
              child: TextFormField(
                controller: zipcodedetailcontroller,
                style: kTextformStyle,
                maxLength: 6,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: width * 0.01, bottom: height * 0.005),
                  hintText: KeyValues.zipCode,
                  hintStyle: kTextformHintStyle,
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Text('${KeyValues.country}-',
                style: ColorCollection.titleStyleGreen),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              decoration: kDropdownContainerDeco,
              child: DropdownButtonFormField<CountryField>(
                hint: Text(KeyValues.systemDefault),
                style: ColorCollection.titleStyle,
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
                value: _selectCountry,
                onChanged: (CountryField? Value) {
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _selectCountry = Value;
                    countryDetailFieldcontroller.text = _selectCountry!.id;
                  });
                },
                items: _Country.map((CountryField user) {
                  return DropdownMenuItem<CountryField>(
                    value: user,
                    child: Text(
                      user.name,
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
                    backgroundColor:
                        MaterialStateProperty.all(ColorCollection.green)),
                onPressed: () {
                  setState(() {
                    if (_formKeyDetail.currentState!.validate()) {
                      if (_state == 0) {
                        setState(() {
                          _state = 1;

                          SubmitDetailAPI(
                              saveupdate == "Update" ? 'true' : "false",
                              'profile',
                              companynamecontroller.text,
                              gstinnumbercontroller.text,
                              phonenumbercontroller.text,
                              websitecontroller.text,
                              currencycontroller.text,
                              "",
                              addressdetailcontroller.text,
                              citydetailcontroller.text,
                              statedetailcontroller.text,
                              zipcodedetailcontroller.text,
                              countryDetailFieldcontroller.text,
                              Staffid);
                          companynamecontroller.clear();
                          gstinnumbercontroller.clear();
                          phonenumbercontroller.clear();
                          websitecontroller.clear();
                          currencycontroller.clear();

                          addressdetailcontroller.clear();
                          citydetailcontroller.clear();
                          statedetailcontroller.clear();
                          zipcodedetailcontroller.clear();
                          countryDetailFieldcontroller.clear();
                        });
                      }
                    } else {
                      return;
                    }
                  });
                },
                child: Text(
                  KeyValues.save,
                  style: ColorCollection.buttonTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> SubmitDetailAPI(
      String isupdate,
      String inputtype,
      String company,
      String vat,
      String phonenumber,
      String website,
      String default_currency,
      String default_language,
      String address,
      String city,
      String state,
      String zip,
      String country,
      String addedfrom) async {
    final paramDic = {
      "isupdate": isupdate.toString(),
      if (UserID != '') "userid": UserID.toString(),
      "inputtype": inputtype.toString(),
      "company": company.toString(),
      "vat": vat.toString(),
      "phonenumber": phonenumber.toString(),
      "website": website.toString(),
      "default_currency": default_currency.toString(),
      "default_language": default_language.toString(),
      "address": address.toString(),
      "city": city.toString(),
      "state": state.toString(),
      "zip": zip.toString(),
      "country": country.toString(),
      "group": groupcontroller.text,
      "addedfrom": addedfrom.toString(),
    };

    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDashboard, paramDic, "Post", Api_Key_by_Admin);
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
      setState(() {
        _state = 2;

        UserID = data['id'].toString();
        print(UserID);
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.success);
      });
    } else {
      setState(() {
        _state = 0;
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.error);
      });
    }
  }
}

// Field Tab

class FieldScreen extends StatefulWidget {
  @override
  createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldScreen> {
  final leadlanguagecontroller = TextEditingController();

  List<TextEditingController> _controllerCustom = [
    for (int i = 0; i < CommanClass.CustomFieldData.length; i++)
      TextEditingController()
  ];
  final _formKeyCustomShipping = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKeyCustomShipping,
        child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                for (int i = 0; i < CommanClass.CustomFieldData.length; i++)
                  Column(
                    children: [
                      Divider(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            CommanClass.CustomFieldData[i]['name'] == null
                                ? ''
                                : CommanClass.CustomFieldData[i]['name'],
                            style: ColorCollection.titleStyleGreen2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            decoration: kDropdownContainerDeco,
                            child: TextFormField(
                              controller: _controllerCustom[i],
                              style: kTextformStyle,
                              decoration: InputDecoration(
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ColorCollection.backColor)),
                        child: Text(
                          'Save',
                          style: ColorCollection.buttonTextStyle,
                        ),
                        onPressed: () {
                          setState(() {
                            List cfd = [];
                            String str = '';
                            for (int i = 0;
                                i < CommanClass.CustomFieldData.length;
                                i++) {
                              // List<CustomFieldData> finaldata=[];
                              // CustomFieldData cfd=new CustomFieldData(UserID, CommanClass.CustomFieldData[i]['id'], 'customer', _controllerCustom[i].text.toString());
                              // CustomFieldData.fromJson(json)
                              // String json = jsonEncode(user);
                              // finaldata.add(new );
                              // cfd.addAll(finaldata);
                              var resBody = {};
                              resBody["relid"] = UserID.toString();
                              resBody["fieldid"] = CommanClass
                                  .CustomFieldData[i]['id']
                                  .toString();
                              resBody["fieldto"] = 'customer';
                              resBody["value"] =
                                  _controllerCustom[i].text.toString();
                              cfd.add(resBody);
                              str = json.encode(cfd);
                            }
                            sendDataCustom(
                                saveupdate == "Update" ? 'true' : "false",
                                "fielddata",
                                str);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ))));
  }

  Future<void> sendDataCustom(
      String isupdate, String inputtype, String customData) async {
    final paramDic = {
      "isupdate": isupdate.toString(),
      "userid": UserID.toString(),
      "inputtype": inputtype.toString(),
      "customData": customData.toString(),
    };
    log(paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDashboard, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);
    print(data['data']);
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
      setState(() {
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.success);
      });
    } else {
      setState(() {
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.error);
      });
    }
  }
}

// Add new Customer Address Tab
class AddNewCustomerAddress extends StatefulWidget {
  const AddNewCustomerAddress({Key? key}) : super(key: key);

  @override
  _AddNewCustomerAddressState createState() => _AddNewCustomerAddressState();
}

class _AddNewCustomerAddressState extends State<AddNewCustomerAddress> {
  bool sameAs = false;
  int _state = 0;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: height * 0.05),
      decoration: kContaierDeco.copyWith(color: ColorCollection.containerC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddressBillingField(),
          SizedBox(
            height: height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${KeyValues.shippingAddress}-',
                  style: ColorCollection.titleStyleGreen),
              Row(
                children: [
                  Checkbox(
                      activeColor: ColorCollection.titleColor,
                      value: sameAs,
                      onChanged: (newVal) {
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          sameAs = newVal!;
                          sameasFieldcontroller.text = sameAs.toString();
                          if (sameasFieldcontroller.text == "true") {
                            setState(() {
                              streetShippingFieldcontroller.text =
                                  streetBillingFieldcontroller.text;
                              cityShippingFieldcontroller.text =
                                  cityBillingFieldcontroller.text;
                              stateShippingFieldcontroller.text =
                                  stateBillingFieldcontroller.text;
                              zipcodeShippingFieldcontroller.text =
                                  zipcodeBillingFieldcontroller.text;
                              countryShippingFieldcontroller.text =
                                  countryBillingFieldcontroller.text;
                            });
                          } else {
                            setState(() {
                              streetShippingFieldcontroller.text = '';
                              cityShippingFieldcontroller.text = '';
                              stateShippingFieldcontroller.text = '';
                              zipcodeShippingFieldcontroller.text = '';
                              countryShippingFieldcontroller.text = '';
                            });
                          }
                        });
                      }),
                  Text(
                    KeyValues.sameAs,
                    style: ColorCollection.subTitleStyle2,
                  )
                ],
              ),
            ],
          ),
          AddressShippingField(),
          SizedBox(
            height: height * 0.01,
          ),
          SizedBox(
            height: height * 0.03,
          ),
          SizedBox(
            height: height * 0.045,
            width: width,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ColorCollection.green)),
              onPressed: () {
                setState(() {
                  if (_formKeyAddress.currentState!.validate() ||
                      _formKeyAddressShipping.currentState!.validate()) {
                    if (_state == 0) {
                      setState(() {
                        _state = 1;
                        SubmitAddressAPI(
                          UserID,
                          'address',
                          streetBillingFieldcontroller.text,
                          cityBillingFieldcontroller.text,
                          stateBillingFieldcontroller.text,
                          zipcodeBillingFieldcontroller.text,
                          countryBillingFieldcontroller.text,
                          streetShippingFieldcontroller.text,
                          cityShippingFieldcontroller.text,
                          stateShippingFieldcontroller.text,
                          zipcodeShippingFieldcontroller.text,
                          countryShippingFieldcontroller.text,
                        );
                        streetBillingFieldcontroller.clear();
                        cityBillingFieldcontroller.clear();
                        stateBillingFieldcontroller.clear();
                        zipcodeBillingFieldcontroller.clear();
                        countryBillingFieldcontroller.clear();
                        streetShippingFieldcontroller.clear();
                        cityShippingFieldcontroller.clear();
                        stateShippingFieldcontroller.clear();
                        zipcodeShippingFieldcontroller.clear();
                        countryShippingFieldcontroller.clear();
                      });
                    }
                  }
                });
              },
              child: Text(
                KeyValues.save,
                style: ColorCollection.buttonTextStyle,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
        ],
      ),
    );
  }

  Future<void> SubmitAddressAPI(
      String userid,
      String address,
      String billing_street,
      String billing_city,
      String billing_state,
      String billing_zip,
      String billing_country,
      String shipping_street,
      String shipping_city,
      String shipping_state,
      String shipping_zip,
      String shipping_country) async {
    final paramDic = {
      "isupdate": saveupdate == "Update" ? 'true' : "false",
      "userid": userid.toString(),
      "inputtype": address.toString(),
      "billing_street": billing_street.toString(),
      "billing_city": billing_city.toString(),
      "billing_state": billing_state.toString(),
      "billing_zip": billing_zip.toString(),
      "billing_country": billing_country.toString(),
      "shipping_street": shipping_street.toString(),
      "shipping_city": shipping_city.toString(),
      "shipping_state": shipping_state.toString(),
      "shipping_zip": shipping_zip.toString(),
      "shipping_country": shipping_country.toString(),
    };

    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDashboard, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);
    log(data.toString());
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
      setState(() {
        _state = 2;

       ToastShowClass.coolToastShow(context, data['message'], CoolAlertType.success);
        Navigator.of(context).pushNamed(CustomerScreen.id);
      });
    } else {
      setState(() {
        _state = 0;
       ToastShowClass.coolToastShow(context, data['message'], CoolAlertType.error);
      });
    }
  }
}

//  Address Tab's Billing Field
class AddressBillingField extends StatefulWidget {
  const AddressBillingField({Key? key}) : super(key: key);

  @override
  _AddressBillingFieldState createState() => _AddressBillingFieldState();
}

class _AddressBillingFieldState extends State<AddressBillingField> {
  CountryField? _selectCountry;
  List countryfield = [];
  List<CountryField> _Country = [];

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
        if (mounted) {
          setState(() {
            _Country.add(
              CountryField(
                countryfield[0][i]['country_id'].toString(),
                countryfield[0][i]['short_name'].toString(),
              ),
            );
          });
        }
      }
    } else {}
  }

  @override
  void initState() {
    getCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final contentPadding =
        EdgeInsets.only(left: width * 0.04, right: width * 0.04);
    return Form(
      key: _formKeyAddress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${KeyValues.enterDetails}-',
            style: ColorCollection.titleStyle2,
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Text('${KeyValues.billingAddress}-',
              style: ColorCollection.titleStyleGreen),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: height * 0.06,
                width: width * 0.42,
                decoration: kDropdownContainerDeco,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Billing Street address';
                    }
                    return null;
                  },
                  controller: streetBillingFieldcontroller,
                  style: kTextformStyle,
                  decoration: InputDecoration(
                    contentPadding: contentPadding,
                    hintText: KeyValues.street,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Billing Zip ';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: zipcodeBillingFieldcontroller,
                  style: kTextformStyle,
                  maxLength: 6,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: width * 0.01,
                    ),
                    hintText: KeyValues.zipCode,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Billing City ';
                    }
                    return null;
                  },
                  controller: cityBillingFieldcontroller,
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
                height: height * 0.06,
                width: width * 0.42,
                decoration: kDropdownContainerDeco,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Billing State ';
                    }
                    return null;
                  },
                  controller: stateBillingFieldcontroller,
                  style: kTextformStyle,
                  decoration: InputDecoration(
                    contentPadding: contentPadding,
                    hintText: KeyValues.state,
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
          Text(
            '${KeyValues.country}-',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 15,
                color: ColorCollection.backColor),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            decoration: kDropdownContainerDeco,
            child: DropdownButtonFormField<CountryField>(
              hint: Text(KeyValues.systemDefault),
              style: ColorCollection.titleStyle,
              elevation: 8,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: width * 0.04),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              dropdownColor: ColorCollection.lightgreen,
              value: _selectCountry,
              onChanged: (CountryField? Value) {
                setState(() {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectCountry = Value;
                  countryBillingFieldcontroller.text = _selectCountry!.id;
                });
              },
              items: _Country.map((CountryField user) {
                return DropdownMenuItem<CountryField>(
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
        ],
      ),
    );
  }
}

// Address Tab's Shipping Field
class AddressShippingField extends StatefulWidget {
  const AddressShippingField({Key? key}) : super(key: key);

  @override
  _AddressShippingFieldState createState() => _AddressShippingFieldState();
}

class _AddressShippingFieldState extends State<AddressShippingField> {
  CountryField? _selectCountry;
  List countryfield = [];
  List<CountryField> _Country = [];

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

  @override
  void initState() {
    getCountries();
    super.initState();
    if (sameasFieldcontroller.text == "true") {
      setState(() {
        streetShippingFieldcontroller.text = streetBillingFieldcontroller.text;
        cityShippingFieldcontroller.text = cityBillingFieldcontroller.text;
        stateShippingFieldcontroller.text = stateBillingFieldcontroller.text;
        zipcodeShippingFieldcontroller.text =
            zipcodeBillingFieldcontroller.text;
        countryShippingFieldcontroller.text =
            countryBillingFieldcontroller.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final contentPadding =
        EdgeInsets.only(left: width * 0.04, right: width * 0.04);
    return Form(
      key: _formKeyAddressShipping,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: height * 0.06,
                width: width * 0.42,
                decoration: kDropdownContainerDeco,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Shipping Street Address ';
                    }
                    return null;
                  },
                  controller: streetShippingFieldcontroller,
                  style: kTextformStyle,
                  decoration: InputDecoration(
                    contentPadding: contentPadding,
                    hintText: KeyValues.street,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Billing Zip ';
                    }
                    return null;
                  },
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  controller: zipcodeShippingFieldcontroller,
                  style: kTextformStyle,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: width * 0.01,
                    ),
                    hintText: KeyValues.zipCode,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Billing City ';
                    }
                    return null;
                  },
                  controller: cityShippingFieldcontroller,
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
                height: height * 0.06,
                width: width * 0.42,
                decoration: kDropdownContainerDeco,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Billing State ';
                    }
                    return null;
                  },
                  controller: stateShippingFieldcontroller,
                  style: kTextformStyle,
                  decoration: InputDecoration(
                    contentPadding: contentPadding,
                    hintText: KeyValues.state,
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
          Text(
            '${KeyValues.country}-',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 15,
                color: ColorCollection.backColor),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            decoration: kDropdownContainerDeco,
            child: DropdownButtonFormField<CountryField>(
              hint: Text(KeyValues.systemDefault),
              style: ColorCollection.titleStyle,
              elevation: 8,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: width * 0.04),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              dropdownColor: ColorCollection.lightgreen,
              value: _selectCountry,
              onChanged: (CountryField? Value) {
                setState(() {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectCountry = Value;
                  countryShippingFieldcontroller.text = _selectCountry!.id;
                });
              },
              items: _Country.map((CountryField user) {
                return DropdownMenuItem<CountryField>(
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
        ],
      ),
    );
  }
}

//
//
class Groups {
  String id;
  String name;

  Groups(this.id, this.name);
}

class Currency {
  String id;
  String name;

  Currency(this.id, this.name);
}

class City {
  int id;
  String name;

  City(this.id, this.name);

  static List<City> getCity() {
    return <City>[
      City(1, 'Left'),
      City(2, 'Right'),
      City(3, 'Center'),
    ];
  }
}

class StateField {
  int id;
  String name;

  StateField(this.id, this.name);

  static List<StateField> getState() {
    return <StateField>[
      StateField(1, 'Left'),
      StateField(2, 'Right'),
      StateField(3, 'Center'),
    ];
  }
}

class CountryField {
  String id;
  String name;

  CountryField(this.id, this.name);
}

class WorkType {
  int id;
  String name;

  WorkType(this.id, this.name);

  static List<WorkType> getWorkType() {
    return <WorkType>[
      WorkType(1, 'Left'),
      WorkType(2, 'Right'),
      WorkType(3, 'Center'),
    ];
  }
}

class CustomFieldData {
  String? relid;
  String? fieldid;
  String? fieldto;
  String? value;
  CustomFieldData({this.relid, this.fieldid, this.fieldto, this.value});
  factory CustomFieldData.fromJson(Map<String, dynamic> json) =>
      CustomFieldData(
        relid: json["relid"],
        fieldid: json["fieldid"],
        fieldto: json["fieldto"],
        value: json["value"],
      );
  Map<String, dynamic> toJson() => {
        "relid": relid,
        "fieldid": fieldid,
        "fieldto": fieldto,
        "value": value,
      };
}
