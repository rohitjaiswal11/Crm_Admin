// ignore_for_file: import_of_legacy_library_into_null_safe, must_be_immutable, deprecated_member_use, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:lbm_plugin/lbm_plugin.dart';

import '../../util/APIClasses.dart';
import '../../util/LicenceKey.dart';
import '../../util/ToastClass.dart';
import '../../util/commonClass.dart';

List LeadSingleData = [];

class AddNewContact extends StatefulWidget {
  static const id = 'addContacts';
  String customerID = '';
  String? contactID = '';
  AddNewContact({required this.customerID, this.contactID});
  @override
  State<StatefulWidget> createState() {
    return _AddContactsScreen();
  }
}

class _AddContactsScreen extends State<AddNewContact> {
  List<Direction> _direction = Direction.getDirection();
  Direction? _selectDirection;
  String dateCurrent = "";

  List tags = [];
  List sources = [];
  List status = [];
  List staff = [];
  List language = [];

  //initialization controller
  final _formKey = GlobalKey<FormState>();
  final firstnamecontroller = TextEditingController();
  final lastnamecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final phonenumbercontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  final invoice_emailscontroller = TextEditingController();
  final estimate_emailscontroller = TextEditingController();
  final credit_note_emailscontroller = TextEditingController();
  final contract_emailscontroller = TextEditingController();
  final task_emailscontroller = TextEditingController();
  final project_emailscontroller = TextEditingController();
  final ticket_emailscontroller = TextEditingController();

  final invoicepermission_controller = TextEditingController();
  final supportpermission_controller = TextEditingController();
  final proposalpermission_controller = TextEditingController();
  final estimatepermission_controller = TextEditingController();
  final contractspermission_controller = TextEditingController();
  final projectpermission_controller = TextEditingController();

  final primarycontact_controller = TextEditingController();
  final donotsendwelcome_controller = TextEditingController();
  final sendsetpasswordemail_controller = TextEditingController();

  final positioncontroller = TextEditingController();
  final directioncontroller = TextEditingController();
  final dateofbirthcontroller = TextEditingController();
  bool passwordemail = true;
  bool _obscureText = true;
  bool checkvalueprimary = false;
  bool checkvaluemail = false;
  bool checkvaluesetpassword = false;
  bool invoicebool = false;
  bool estimatesbool = false;
  bool contractsbool = false;
  bool proposalsbool = false;
  bool supportsbool = false;
  bool projectsbool = false;

  bool proformainvoicebool = false;
  bool creditbool = false;
  bool ticketsbool = false;
  bool taskbool = false;
  bool estimatebool = false;
  bool projectbool = false;
  bool contractbool = false;

  void getData() async {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate =
        "${dateParse.year}-${dateParse.month}-${dateParse.day} 00:00:00";
    setState(() {
      dateCurrent = formattedDate.toString();
    });
  }

  Future<void> getContactData() async {
    final paramDic = {"id": '${widget.contactID}'};
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(
        Base_Url_For_App,
        APIClasses.GetCustomerDashboard + '/Contact',
        paramDic,
        "Get",
        Api_Key_by_Admin);

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] != true) print('here 1');
        if (data['status'].toString() != '1') {
          print('here 2');

          ToastShowClass.toastShow(
              null, data['message'] ?? 'Failed to Load Data', Colors.red);

          return;
        } else {
          print('here 3');
          final contactData = data['data'][0];
          log('$contactData');
          setState(() {
            firstnamecontroller.text = contactData['firstname'] ?? '';
            lastnamecontroller.text = contactData['lastname'] ?? '';
            emailcontroller.text = contactData['email'] ?? '';
            phonenumbercontroller.text = contactData['phonenumber'] ?? '';
            passwordcontroller.text = contactData['password'] ?? '';
            invoice_emailscontroller.text =
                contactData['invoice_emails'] ?? '0';
            proformainvoicebool =
                contactData['invoice_emails'].toString() == '1' ? true : false;
            estimate_emailscontroller.text =
                contactData['estimate_emails'] ?? '0';
            estimatebool =
                contactData['estimate_emails'].toString() == '1' ? true : false;
            credit_note_emailscontroller.text =
                contactData['credit_note_emails'] ?? '0';
            creditbool = contactData['credit_note_emails'].toString() == '1'
                ? true
                : false;
            contract_emailscontroller.text =
                contactData['contract_emails'] ?? '0';
            contractbool =
                contactData['contract_emails'].toString() == '1' ? true : false;
            task_emailscontroller.text = contactData['task_emails'] ?? '0';
            taskbool =
                contactData['task_emails'].toString() == '1' ? true : false;
            project_emailscontroller.text =
                contactData['project_emails'] ?? '0';
            projectbool =
                contactData['project_emails'].toString() == '1' ? true : false;
            ticket_emailscontroller.text = contactData['ticket_emails'] ?? '0';
            ticketsbool =
                contactData['ticket_emails'].toString() == '1' ? true : false;
          });
        }
      } catch (e) {
        print('here 4');
        log('$e');
        ToastShowClass.toastShow(null, 'Failed to Load Data', Colors.red);
        return;
      }
    }
  }

  @override
  void initState() {
    if (widget.contactID != null) {
      getContactData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(widget.contactID != null ? "Update Contact" : "Add Contact"),
          actions: <Widget>[
            IconButton(
                tooltip: 'Save Contact',
                icon: const Icon(Icons.save),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    AddContactsData();
                  }
                })
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 15),
                  Icon(Icons.person),
                  SizedBox(width: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 300,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the firstname';
                            }
                            return null;
                          },
                          controller: firstnamecontroller,
                          style: TextStyle(color: Colors.black54),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 14.0),
                            hintText: 'Enter Firstname',
                            hintStyle:
                                Theme.of(context).textTheme.bodyText1!.merge(
                                      TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 12.0),
                                    ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            //                focusedBorder: UnderlineInputBorder(
                            //                    borderSide: BorderSide(
                            //                        color: Theme.of(context).accentColor)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 15),
                  Icon(Icons.person),
                  SizedBox(width: 20),
                  Container(
                    width: 300,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the lastname';
                        }
                        return null;
                      },
                      controller: lastnamecontroller,
                      style: TextStyle(color: Colors.black54),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 14.0),
                        hintText: 'Enter Lastname',
                        hintStyle: Theme.of(context).textTheme.bodyText1!.merge(
                              TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 12.0),
                            ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2))),
                        //                focusedBorder: UnderlineInputBorder(
                        //                    borderSide: BorderSide(
                        //                        color: Theme.of(context).accentColor)),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 15),
                  Icon(Icons.business),
                  SizedBox(width: 20),
                  Container(
                    width: 300,
                    child: TextFormField(
                      // validator: (value) {
                      //   if (value.isEmpty) {
                      //     return 'Please enter the Position';
                      //   }
                      //   return null;
                      // },
                      controller: positioncontroller,
                      style: TextStyle(color: Colors.black54),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Position',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 14.0),
                        hintText: 'Enter Position',
                        hintStyle: Theme.of(context).textTheme.bodyText1!.merge(
                              TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 12.0),
                            ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2))),
                        //                focusedBorder: UnderlineInputBorder(
                        //                    borderSide: BorderSide(
                        //                        color: Theme.of(context).accentColor)),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 15),
                  Icon(Icons.email),
                  SizedBox(width: 20),
                  Container(
                    width: 300,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Email';
                        }
                        return null;
                      },
                      controller: emailcontroller,
                      style: TextStyle(color: Colors.black54),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 14.0),
                        hintText: 'Enter Email',
                        hintStyle: Theme.of(context).textTheme.bodyText1!.merge(
                              TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 12.0),
                            ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2))),
                        //                focusedBorder: UnderlineInputBorder(
                        //                    borderSide: BorderSide(
                        //                        color: Theme.of(context).accentColor)),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 15),
                  Icon(Icons.phone),
                  SizedBox(width: 20),
                  Container(
                    width: 300,
                    child: TextFormField(
                      maxLength: 10,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Phone Number';
                        }
                        return null;
                      },
                      controller: phonenumbercontroller,
                      style: TextStyle(color: Colors.black54),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 14.0),
                        hintText: 'Enter Phone Number',
                        hintStyle: Theme.of(context).textTheme.bodyText1!.merge(
                              TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 12.0),
                            ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2))),
                        //                focusedBorder: UnderlineInputBorder(
                        //                    borderSide: BorderSide(
                        //                        color: Theme.of(context).accentColor)),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 15),
                  Icon(Icons.language),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Select Direction"),
                      Container(
                        width: 300,
                        child: DropdownButton<Direction>(
                          underline: Container(
                            height: 0.5,
                            color: Colors.blue,
                          ),
                          isExpanded: true,
                          hint: Text("System  Default"),
                          value: _selectDirection,
                          onChanged: (Value) {
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _selectDirection = Value;
                              directioncontroller.text = _selectDirection!.name;
                            });
                          },
                          items: _direction.map((Direction user) {
                            return DropdownMenuItem<Direction>(
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
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      CheckDate(1);
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 15),
                        Icon(Icons.calendar_today),
                        SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Date of Birth"),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 300,
                              child: Text(dateofbirthcontroller.text),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 55.0, right: 0.0),
                child: Divider(
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                height: 0,
              ),
              Visibility(
                visible: passwordemail,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 15),
                    Icon(Icons.lock),
                    SizedBox(width: 20),
                    Container(
                      width: 300,
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the password';
                          }
                          return null;
                        },
                        controller: passwordcontroller,
                        style: TextStyle(color: Colors.black54),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 14.0),
                          hintText: 'Enter Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                          hintStyle:
                              Theme.of(context).textTheme.bodyText1!.merge(
                                    TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 12.0),
                                  ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.2))),
                          //                focusedBorder: UnderlineInputBorder(
                          //                    borderSide: BorderSide(
                          //                        color: Theme.of(context).accentColor)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey,
              ),
              Row(
                children: [
                  Checkbox(
                    value: checkvalueprimary,
                    onChanged: (value) {
                      setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());
                        checkvalueprimary = value!;
                        positioncontroller.text =
                            checkvalueprimary == true ? '1' : '0';
                      });
                    },
                  ),
                  Text('Primary Contact'),
                ],
              ),
              SizedBox(
                height: 0,
              ),
              Row(
                children: [
                  Checkbox(
                    value: checkvaluemail,
                    onChanged: (value) {
                      setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());
                        checkvaluemail = value!;
                        donotsendwelcome_controller.text =
                            checkvaluemail == true ? '1' : '0';
                      });
                    },
                  ),
                  Text('Do not send welcome email'),
                ],
              ),
              SizedBox(
                height: 0,
              ),
              Row(
                children: [
                  Checkbox(
                    value: checkvaluesetpassword,
                    onChanged: (value) {
                      setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());
                        checkvaluesetpassword = value!;
                        if (checkvaluesetpassword) {
                          passwordcontroller.text = emailcontroller.text;
                          print(passwordcontroller.text);
                        } else {
                          print(passwordcontroller.text);
                        }
                        passwordemail = !checkvaluesetpassword;
                      });
                    },
                  ),
                  Text('send SET password email'),
                ],
              ),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0, 8.0),
                child: Row(
                  children: [
                    Text('Permissions'),
                  ],
                ),
              ),
              SizedBox(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0, 8.0),
                child: Row(
                  children: [
                    Text(
                      "Make sure to set appropriate permissions" +
                          "\n" +
                          "for this contact",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Invoices",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 14.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24.0,
                          ),
                          child: PlatformSwitch(
                            value: invoicebool,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                invoicebool = value;
                                invoicepermission_controller.text =
                                    invoicebool == true ? '1' : '0';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Proposals",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: PlatformSwitch(
                            value: proposalsbool,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                proposalsbool = value;
                                proposalpermission_controller.text =
                                    proposalsbool == true ? '1' : '0';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Estimates",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: PlatformSwitch(
                            value: estimatesbool,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                estimatesbool = value;
                                estimatepermission_controller.text =
                                    estimatesbool == true ? '1' : '0';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      children: [
                        Text(
                          "Supports",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 14.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24.0,
                          ),
                          child: PlatformSwitch(
                            value: supportsbool,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                supportsbool = value;
                                supportpermission_controller.text =
                                    supportsbool == true ? '1' : '0';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "Contracts",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24.0,
                          ),
                          child: PlatformSwitch(
                            value: contractsbool,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                contractsbool = value;
                                contractspermission_controller.text =
                                    contractsbool == true ? '1' : '0';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: Row(
                      children: [
                        Text(
                          "Projects",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 22.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: PlatformSwitch(
                            value: projectsbool,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                projectsbool = value;
                                projectpermission_controller.text =
                                    projectsbool == true ? '1' : '0';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0, 8.0),
                child: Row(
                  children: [
                    Text('Email Notifications/SMS'),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Proforma Invoice",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 0.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 0.0,
                          ),
                          child: PlatformSwitch(
                            value: proformainvoicebool,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                proformainvoicebool = value;
                                invoice_emailscontroller.text =
                                    proformainvoicebool == true ? '1' : '0';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Estimate",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 48.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: PlatformSwitch(
                            value: estimatebool,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                estimatebool = value;
                                estimate_emailscontroller.text =
                                    estimatebool == true ? '1' : '0';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Credit Note",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: PlatformSwitch(
                            value: creditbool,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                creditbool = value;
                                credit_note_emailscontroller.text =
                                    creditbool == true ? '1' : '0';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: [
                        Text(
                          "Project",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 55,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: PlatformSwitch(
                            value: projectbool,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                projectbool = value;
                                project_emailscontroller.text =
                                    projectbool == true ? '1' : '0';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Tickets",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 50.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: PlatformSwitch(
                            value: ticketsbool,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                ticketsbool = value;
                                ticket_emailscontroller.text =
                                    ticketsbool == true ? '1' : '0';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Contract",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 45.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: PlatformSwitch(
                            value: contractbool,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                contractbool = value;
                                contract_emailscontroller.text =
                                    contractbool == true ? '1' : '0';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.help,
                          size: 14,
                        ),
                        Text(
                          "Task",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 48.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: PlatformSwitch(
                            value: taskbool,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                taskbool = value;
                                task_emailscontroller.text =
                                    taskbool == true ? '1' : '0';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: [
                        Text(
                          "                              ",
                          style:
                              TextStyle(fontSize: CommanClass.header_textsize),
                        ),
                        SizedBox(
                          width: 52.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          //                        child: PlatformSwitch(
                          //                          value: projectbool,
                          //                          onChanged: (value) {
                          //                            setState(() {
                          //                              projectbool = value;
                          //                            });
                          //                          },
                          //                        ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void CheckDate(int choose) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1920),
            lastDate: DateTime.now())
        .then((date) {
      if (date != null) {
        setState(() {
          dateCurrent = DateFormat("yyyy-MM-dd").format(date);
          dateofbirthcontroller.text = dateCurrent.toString();
        });
      }
    });
  }

//APi hit to save the
  Future<void> AddContactsData() async {
    final paramDic = {
      if (widget.contactID != null) 'id': widget.contactID,
      if (widget.contactID != null) 'isUpdate': 'true',
      "inputtype": 'contact',
      "customer_id": widget.customerID.toString(),
      "firstname": firstnamecontroller.text,
      "lastname": lastnamecontroller.text,
      "email": emailcontroller.text,
      "phonenumber": phonenumbercontroller.text,
      "password": passwordcontroller.text,
      "invoice_emails": invoice_emailscontroller.text,
      "estimate_emails": estimate_emailscontroller.text,
      "credit_note_emails": credit_note_emailscontroller.text,
      "contract_emails": contract_emailscontroller.text,
      "task_emails": task_emailscontroller.text,
      "project_emails": project_emailscontroller.text,
      "ticket_emails": ticket_emailscontroller.text,
    };
    log("Note Param" + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDashboard, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.success);
        Navigator.pop(context, true);
      });
    } else {
      setState(() {
        emailcontroller.text = '';
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.error);
      });
//    }
    }
  }
}

class Country {
  int id;
  String name;

  Country(this.id, this.name);

  static List<Country> getCountries() {
    return <Country>[
      Country(1, 'Australia'),
      Country(2, 'Germany'),
      Country(3, 'India'),
      Country(4, 'Mexico'),
      Country(5, 'Singapore'),
    ];
  }
}

class Tags {
  String id;
  String name;

  Tags(this.id, this.name);
}

class Sources {
  String id;
  String name;

  Sources(this.id, this.name);
}

class Status {
  String id;
  String name;

  Status(this.id, this.name);
}

class Staff {
  String id;
  String name;

  Staff(this.id, this.name);
}

class Direction {
  int id;
  String name;

  Direction(this.id, this.name);
  static List<Direction> getDirection() {
    return <Direction>[
      Direction(1, 'Left'),
      Direction(2, 'Right'),
      Direction(3, 'Center'),
    ];
  }
}

class Language {
  int id;
  String name;

  Language(this.id, this.name);

  static List<Language> getLanguage() {
    return <Language>[
      Language(1, 'Left'),
      Language(2, 'Right'),
      Language(3, 'Center'),
    ];
  }
}
