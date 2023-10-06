// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, must_be_immutable, import_of_legacy_library_into_null_safe, unnecessary_null_comparison, prefer_if_null_operators, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/constants.dart';

import '../util/storage_manger.dart';

class NewContractScreen extends StatefulWidget {
  static const id = '/newContracts';
  List EditData = [];
  NewContractScreen({required this.EditData});

  @override
  State<NewContractScreen> createState() => _NewContractScrenState();
}

class _NewContractScrenState extends State<NewContractScreen> {
  Object? _radioValue = 1;
  int contractValue = 0;
  int calendarNum = 0;
  String _startDate = '';
  String _endDate = '';
  DateTime currentDate = DateTime.now();
  Customer? _customer;
  List<Customer> _customerlist = [];
  Projects? _project;
  List<Projects> _projectlist = [];
  List customerist = [];

  List Project = [];
  Contract? _contract;
  List<Contract> _Contractlist = [];
  List Contractlist = [];
  TextEditingController contractvaluecontroller = TextEditingController();
  TextEditingController subjectcontroller = TextEditingController();
  TextEditingController descontroller = TextEditingController();
  String loginid = CommanClass.StaffId;
  String? contractid;
  String? customerid;
  String? projectid;
  final _formKeyDetail = GlobalKey<FormState>();

  //Date picker
  final DateFormat formatter = DateFormat('MM/dd/yyyy');

  _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        _pickedDate(pickedDate);
      });
    }
  }

  _pickedDate(DateTime currentDate) {
    setState(() {
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

      if (calendarNum == 1) {
        _startDate = formattedDate;
      } else {
        _endDate = formattedDate;
      }
    });
  }

  getdata() async {
    loginid = await SharedPreferenceClass.GetSharedData("staff_id");
    setState(() {
      getCustomer();
    });
    if (widget.EditData != null) {
      subjectcontroller.text = widget.EditData[0]['subject'] == null
          ? ""
          : widget.EditData[0]['subject'];
      _startDate = widget.EditData[0]['datestart'] == null
          ? ""
          : widget.EditData[0]['datestart'];
      _endDate = widget.EditData[0]['dateend'] == null
          ? ""
          : widget.EditData[0]['dateend'];
      descontroller.text = widget.EditData[0]['description'] == null
          ? ""
          : widget.EditData[0]['description'];
      contractValue = widget.EditData[0]['contract_value'] == null ||
              widget.EditData[0]['contract_value'].isEmpty
          ? 0
          : int.parse(
              widget.EditData[0]['contract_value'].toString().split('.')[0]);
    }
  }

  Future<void> getCustomer() async {
    final paramDic = {
      "": '',
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.getCustomer, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);

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
      setState(() {
        customerist.addAll(data['data'][0]['customer']);
        Contractlist.addAll(data['data'][0]['contract_type']);

        for (int i = 0; i < customerist.length; i++) {
          _customerlist.add(Customer(
              id: customerist[i]['userid'],
              name: customerist[i]['company'],
              project: customerist[i]['project']));
        }
        for (int i = 0; i < Contractlist.length; i++) {
          _Contractlist.add(Contract(
            id: Contractlist[i]['id'],
            name: Contractlist[i]['name'],
          ));
        }
      });
    } else {}
  }

  getProjects() {
    setState(() {
      for (int i = 0; i < Project.length; i++) {
        _projectlist
            .add(Projects(id: Project[i]['id'], name: Project[i]['name']));
      }
    });
  }

  Future<void> newContract(String id) async {
    final paramDic = {
      "login_id": loginid.toString(),
      "client": customerid.toString(),
      "project_id": projectid.toString(),
      "subject": subjectcontroller.text.toString(),
      "contract_value": contractValue.toString(),
      "contract_type": contractid.toString(),
      "datestart": _startDate.toString(),
      "dateend": _endDate.toString(),
      "description": descontroller.text.toString(),
      "id": id.toString(),
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.getContract, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);
    log(data.toString());
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] != true) if (data['status'].toString() != '1') {
          ToastShowClass.coolToastShow(context,
              data['message'] ?? 'Failed to Post Data', CoolAlertType.error);
        }
      } catch (e) {
        ToastShowClass.coolToastShow(
            context, 'Failed to Post Data', CoolAlertType.error);
      }
      setState(() {
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.error);
        Navigator.pop(context);
      });
    } else {
      setState(() {
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.error);
      });
    }
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final newid = _customerlist.where((element) {
    //   element.name == widget.EditData[0]['customer_name'];
    //   return ;
    // });

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorCollection.grey,
      body: SingleChildScrollView(
        child: Form(
          key: _formKeyDetail,
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
                        height: height * 0.09,
                        width: width * 0.14,
                        child: Image.asset(
                          'assets/contracts.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Text(KeyValues.newContracts.toUpperCase(),
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
                height: height * 0.02,
              ),
              Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio(
                          activeColor: ColorCollection.green,
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: (newVal) {
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _radioValue = newVal;
                            });
                          }),
                      Text(KeyValues.public, style: ColorCollection.titleStyle)
                    ],
                  ),
                  SizedBox(width: width * 0.07),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Radio(
                          activeColor: ColorCollection.green,
                          value: 2,
                          groupValue: _radioValue,
                          onChanged: (newVal) {
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _radioValue = newVal;
                            });
                          }),
                      Text(KeyValues.private, style: ColorCollection.titleStyle)
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
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
                      height: height * 0.04,
                    ),
                    Text(
                      KeyValues.Customer,
                      style: ColorCollection.titleStyle2,
                    ),
                    SizedBox(
                      height: height * 0.02,
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
                        value: _customer,
                        onChanged: (Customer? newValue) {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _customer = newValue;
                            customerid = _customer!.id.toString();
                            Project = _customer!.project;
                            getProjects();
                          });
                        },
                        items: _customerlist.map((item) {
                          return DropdownMenuItem(
                            child: Text(item.name),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                    if (Project.isNotEmpty)
                      Visibility(
                          visible: Project.isNotEmpty || widget.EditData != null
                              ? true
                              : false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height * 0.04,
                              ),
                              Text(
                                KeyValues.projects,
                                style: ColorCollection.titleStyle2,
                              ),
                              SizedBox(
                                height: height * 0.02,
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
                                  value: _project,
                                  onChanged: (Projects? newValue) {
                                    setState(() {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _project = newValue;
                                      projectid = _project!.id.toString();
                                    });
                                  },
                                  items: _projectlist.map((item) {
                                    return DropdownMenuItem(
                                      child: Text(item.name),
                                      value: item,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          )),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Text(
                      KeyValues.subject,
                      style: ColorCollection.titleStyleGreen2.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      height: height * 0.06,
                      width: width,
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the subject ';
                          }
                          return null;
                        },
                        controller: subjectcontroller,
                        style: kTextformStyle,
                        decoration: InputDecoration(
                          hintText: KeyValues.Subjecthint,
                          contentPadding: EdgeInsets.only(
                              left: width * 0.01, right: width * 0.01),
                          hintStyle: kTextformHintStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Text(
                      KeyValues.contractValue,
                      style: ColorCollection.titleStyleGreen2,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      height: height * 0.11,
                      width: width,
                      decoration: kDropdownContainerDeco,
                      child: Row(
                        children: [
                          Spacer(),
                          Text(
                            '$contractValue',
                            style: ColorCollection.titleStyle
                                .copyWith(fontSize: 15),
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      contractValue++;
                                    });
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.grey,
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (contractValue == 0) {
                                        return;
                                      } else {
                                        contractValue--;
                                      }
                                    });
                                  },
                                  child: Icon(Icons.keyboard_arrow_down,
                                      color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Text(
                      KeyValues.contractType,
                      style: ColorCollection.titleStyle2,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      decoration: kDropdownContainerDeco,
                      child: DropdownButtonFormField<Contract>(
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
                        value: _contract,
                        onChanged: (Contract? newValue) {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _contract = newValue;
                            contractid = _contract!.id;
                          });
                        },
                        items: _Contractlist.map((item) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            calendarNum = 1;
                            _selectDate(context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: ColorCollection.green,
                                size: 25,
                              ),
                              SizedBox(width: width * 0.01),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(KeyValues.startDate,
                                      style: ColorCollection.titleStyle),
                                  SizedBox(
                                    height: height * 0.004,
                                  ),
                                  Text(
                                      _startDate == '' ||
                                              _startDate.isEmpty ||
                                              _startDate == null
                                          ? '--'
                                          : _startDate,
                                      style: ColorCollection.subTitleStyle),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            calendarNum = 2;
                            _selectDate(context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: ColorCollection.green,
                                size: 25,
                              ),
                              SizedBox(width: width * 0.01),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(KeyValues.endDate,
                                      style: ColorCollection.titleStyle),
                                  SizedBox(
                                    height: height * 0.004,
                                  ),
                                  Text(
                                      _endDate == '' ||
                                              _endDate.isEmpty ||
                                              _endDate == null
                                          ? '--'
                                          : _endDate,
                                      style: ColorCollection.subTitleStyle),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: ColorCollection.green,
                          child: Icon(
                            Icons.contact_page_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Text(
                          KeyValues.description,
                          style: ColorCollection.titleStyleGreen2,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      height: height * 0.08,
                      width: width,
                      decoration: kDropdownContainerDeco,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter the description';
                          }
                          return null;
                        },
                        controller: descontroller,
                        maxLines: 4,
                        style: kTextformStyle.copyWith(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: KeyValues.deschint,
                          contentPadding: EdgeInsets.only(
                              left: width * 0.01, bottom: height * 0.023),
                          hintStyle: kTextformHintStyle.copyWith(fontSize: 12),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    SizedBox(
                      height: height * 0.045,
                      width: width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ColorCollection.green)),
                        onPressed: () {
                          if (contractid == null || customerid == null) {
                            ToastShowClass.coolToastShow(
                                context,
                                'Please Select Items from Dropdown',
                                CoolAlertType.info);
                            return;
                          }
                          if (_formKeyDetail.currentState!.validate()) {
                            widget.EditData != null
                                ? newContract(widget.EditData[0]['id'])
                                : newContract("");
                          }
                        },
                        child: Text(KeyValues.save,
                            style: ColorCollection.buttonTextStyle),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
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

class Projects {
  String id;
  String name;
  Projects({required this.id, required this.name});
}

class Contract {
  String id;
  String name;

  Contract({required this.id, required this.name});
}

class Customer {
  String id;
  String name;
  List project;

  Customer({required this.id, required this.name, required this.project});
}
