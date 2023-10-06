// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, deprecated_member_use, avoid_print, must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables, import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/storage_manger.dart';

class AddNewTicket extends StatefulWidget {
  static const id = '/addnewticket';
  String CustomerID = '';
  AddNewTicket({required this.CustomerID});
  @override
  State<AddNewTicket> createState() => _AddNewTicketState();
}

class _AddNewTicketState extends State<AddNewTicket> {
  List<String> _values = ['A', 'B', 'C', 'D'];

  HtmlEditorController controller = HtmlEditorController();
  String? _selectedValue;

  File? imageFile;
  bool _loadingData = true;

  /// Get from gallery
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        UploadFileName = pickedFile.name;
        Navigator.pop(context);
      });
      print(imageFile!);
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        UploadFileName = pickedFile.name;

        Navigator.pop(context);
      });
    }
  }

  Future<void> getcontactDashboard() async {
    final paramDic = {
      "customer_id": widget.CustomerID.toString(),
      // "start": start.toString(),
      // "limit": limit.toString(),
      "detailtype": 'contact',
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDetail, paramDic, "Get", Api_Key_by_Admin);
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

      if (mounted) {
        if (data['data'] != null) {
          final singleData = data['data'][0];
          setState(() {
            _contact = Contact(
              singleData['id'].toString(),
              singleData['firstname'].toString() + '' + singleData['lastname'],
              singleData['email'].toString(),
            );
          });
        }
      }
    } else {
      setState(() {});
    }
  }

  Future<void> getNavigatingData() async {
    try {
      if (CommanClass.navigatingData != null) {
        await getcontactDashboard().whenComplete(() {
          setState(() {
            contactcontroller.text = _contact!.id;
            namecontroller.text = _contact!.name.toString();
            emailcontroller.text = _contact!.email.toString();
          });
        });
        await getProjectDetail();
        log('Project Id ==>' + '${CommanClass.navigatingData['projectID']}');
        if (CommanClass.navigatingData.containsKey('projectID') == true) {
          final val = _projectList.firstWhere(
            (element) => element.id == CommanClass.navigatingData['projectID'],
            orElse: () => Project('null', 'null'),
          );
          if (val.id != 'null' && val.name != 'null') {
            setState(() {
              _project = val;
              taskprojectcontroller.text = _project!.id;
            });
          }
        }
      } else {}
      setState(() {
        _loadingData = false;
      });
    } catch (e) {
      log('Error Occoured  == >  $e');
      setState(() {
        _loadingData = false;
      });
    }
  }

  String UploadFileName = '';
  final subjectcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final cccontroller = TextEditingController();
  final replyticketcontroller = TextEditingController();
  final _formKeyDetail = GlobalKey<FormState>();
  final tagscontroller = TextEditingController();
  Tags? _tags;
  List<Tags> _tagsList = [];
  List tagsfield = [];
  final contactcontroller = TextEditingController();
  Contact? _contact;
  List<Contact> _contactList = [];
  List contactfield = [];
  final departmentcontroller = TextEditingController();
  Department? _department;
  List<Department> _departmentList = [];
  List departmentfield = [];
  final assigntickettcontroller = TextEditingController();
  AssignTicket? _assignticket;
  List<AssignTicket> _assignticketList = [];
  List assignfield = [];
  final taskprioritycontroller = TextEditingController();
  Priority? _priority;
  List<Priority> _priorityList = [];
  List priorityfield = [];
  final servicecontroller = TextEditingController();
  Service? _service;
  List<Service> _serviceList = [];
  List servicefield = [];
  final taskprojectcontroller = TextEditingController();
  Project? _project;
  List<Project> _projectList = [];
  List projectfield = [];
  final ticketcontroller = TextEditingController();
  Ticket? _ticket;
  List<Ticket> _ticketList = [];
  List ticketfield = [];
  int state = 0;
  String Staffname = '';
  String StaffID = '';

  @override
  void initState() {
    super.initState();
    print('start');
    getContactDetail();
    getDepartmentDetail();
    getTagsDetail();
    getAssignTicketDetail();
    getPriorityDetail();
    getServiceDetail();
    getPredefinedReply();
    print('end');
    getData();
    getNavigatingData();
  }

  Future<void> getData() async {
    StaffID = await SharedPreferenceClass.GetSharedData('staff_id');
    Staffname = await SharedPreferenceClass.GetSharedData('firstname') +
        ' ' +
        await SharedPreferenceClass.GetSharedData('lastname');
    setState(() {});
  }

  //contact api hit
  Future<void> getContactDetail() async {
    print('Customer Id ===' + CommanClass.CustomerID.toString());
    final paramDic = {
      "type": "contact",
      "userid": CommanClass.CustomerID,
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    contactfield.clear();
    _contactList.clear();
    if (response.statusCode == 200) {
      contactfield = data['data'];
      print(contactfield);
      for (int i = 0; i < contactfield.length; i++) {
        setState(() {
          _contactList.add(Contact(
            contactfield[i]['id'].toString(),
            contactfield[i]['firstname'].toString() +
                '' +
                contactfield[i]['lastname'],
            contactfield[i]['email'].toString(),
          ));
        });
      }
    } else {}
  }

  //department api hit
  Future<void> getDepartmentDetail() async {
    final paramDic = {
      "type": "department",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    departmentfield.clear();
    _departmentList.clear();
    if (response.statusCode == 200) {
      departmentfield = data['data'];
      print(departmentfield);
      for (int i = 0; i < departmentfield.length; i++) {
        setState(() {
          _departmentList.add(Department(
              departmentfield[i]['departmentid'].toString(),
              departmentfield[i]['name'].toString()));
        });
      }
    } else {}
  }

  //tags api hit
  Future<void> getTagsDetail() async {
    final paramDic = {
      "type": "tags",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    tagsfield.clear();
    _tagsList.clear();
    if (response.statusCode == 200) {
      tagsfield = data['data'];

      for (int i = 0; i < tagsfield.length; i++) {
        setState(() {
          _tagsList.add(Tags(
              tagsfield[i]['id'].toString(), tagsfield[i]['name'].toString()));
        });
      }
    } else {}
  }

  //staff api hit
  Future<void> getAssignTicketDetail() async {
    final paramDic = {
      "type": "staff",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    assignfield.clear();
    _assignticketList.clear();
    if (response.statusCode == 200) {
      assignfield = data['data'];

      print(assignfield);

      for (int i = 0; i < assignfield.length; i++) {
        setState(() {
          _assignticketList.add(AssignTicket(
              assignfield[i]['staffid'].toString(),
              assignfield[i]['firstname'].toString() +
                  ' ' +
                  assignfield[i]['lastname'].toString()));
        });
      }
    } else {}
  }

  //priority api hit
  Future<void> getPriorityDetail() async {
    final paramDic = {
      "type": "priority",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    priorityfield.clear();
    _priorityList.clear();
    if (response.statusCode == 200) {
      priorityfield = data['data'];
      print(priorityfield);

      for (int i = 0; i < priorityfield.length; i++) {
        setState(() {
          _priorityList.add(Priority(priorityfield[i]['priorityid'].toString(),
              priorityfield[i]['name'].toString()));
        });
      }
    } else {}
  }

  void getServiceDetail() async {
    final paramDic = {
      "type": "service",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    log('Response == =' + response.statusCode.toString());
    var data = json.decode(response.body);
    _serviceList.clear();
    servicefield.clear();
 log("SErvice Field all Data  ===== " + response.body.toString());
    if (response.statusCode == 200) {
      servicefield = data['data'];
      log("SErvice Field Data===== " + servicefield.toString());
      for (int i = 0; i < servicefield.length; i++) {
        setState(() {
          _serviceList.add(Service(servicefield[i]['id'].toString(),
              servicefield[i]['name'].toString()));
        });
      }
    } else {
      print("SErvice Field Failed===== " + response.statusCode.toString());
    }
  }

  //project api hit
  Future<void> getProjectDetail() async {
    final paramDic = {
      "type": "project",
      "userid": contactcontroller.text.toString(),
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    projectfield.clear();
    _projectList.clear();
    print('ne failed ==' + response.statusCode.toString());
    if (response.statusCode == 200) {
      projectfield = data['data'];
      print('Project Field ==' + projectfield.toString());
      for (int i = 0; i < projectfield.length; i++) {
        setState(() {
          _projectList.add(Project(
              projectfield[i]['id'].toString(),
              "#" +
                  projectfield[i]['id'].toString() +
                  "-" +
                  projectfield[i]['name'].toString()));
        });
      }
    } else 
    {
        print('Project failed ==' + response.statusCode.toString());
    }
  
  }

  //predefined reply api hit
  Future<void> getPredefinedReply() async {
    final paramDic = {
      "type": "reply",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomField, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    ticketfield.clear();
    _ticketList.clear();
    if (response.statusCode == 200) {
      ticketfield = data['data'];

      for (int i = 0; i < ticketfield.length; i++) {
        setState(() {
          _ticketList.add(Ticket(
              ticketfield[i]['id'].toString(),
              ticketfield[i]['name'].toString(),
              ticketfield[i]['message'].toString()));
        });
      }
    } else {}
  }

  @override
  void dispose() {
    CommanClass.navigatingData = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    log(contactfield.toString());
    final contentPadding =
        EdgeInsets.only(left: width * 0.01, right: width * 0.01);
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
                        height: height * 0.06,
                        width: width * 0.12,
                        child: Image.asset(
                          'assets/newticket.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Text(KeyValues.addnewTicket,
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
                height: height * 0.06,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                ),
                width: width,
                decoration:
                    kContaierDeco.copyWith(color: ColorCollection.containerC),
                child: _loadingData
                    ? SizedBox(
                        height: height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Text(KeyValues.subject,
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
                                  return 'Please enter the Subject';
                                }
                                return null;
                              },
                              controller: subjectcontroller,
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
                          Text(KeyValues.contacts,
                              style: ColorCollection.titleStyleGreen),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            decoration: kDropdownContainerDeco,
                            child: DropdownButtonFormField(
                              hint: _contact != null
                                  ? SizedBox(
                                      width: width * 0.7,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              _contact!.name,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              ' (' + _contact!.email + ')',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Text(KeyValues.nothingSelected),
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
                              // value: _contact,
                              onChanged: (Value) async {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _contact = Value as Contact?;
                                  contactcontroller.text = _contact!.id;
                                  namecontroller.text =
                                      _contact!.name.toString();
                                  emailcontroller.text =
                                      _contact!.email.toString();
                                });
                                if (contactcontroller.text.isNotEmpty) {
                                  print(contactcontroller.text);
                                  print(namecontroller.text);
                                  print(emailcontroller.text);
                                  _project = null;
                                  getProjectDetail();
                                }
                              },
                              items: _contactList.map((Contact user) {
                                return DropdownMenuItem<Contact>(
                                  value: user,
                                  child: SizedBox(
                                    width: width * 0.7,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            user.name,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Text(
                                            ' (' + user.email + ')',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
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
                              enabled: false,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter the Name';
                                }
                                return null;
                              },
                              controller: namecontroller,
                              style: kTextformStyle,
                              decoration: InputDecoration(
                                contentPadding: contentPadding,
                                hintText: KeyValues.name,
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(KeyValues.emailAddress,
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
                                  return 'Please enter the email address';
                                }
                                return null;
                              },
                              enabled: false,
                              controller: emailcontroller,
                              style: kTextformStyle,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: KeyValues.emailAddress,
                                contentPadding: contentPadding,
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(KeyValues.department,
                              style: ColorCollection.titleStyleGreen),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            decoration: kDropdownContainerDeco,
                            child: DropdownButtonFormField<Department>(
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
                              value: _department,
                              onChanged: (Value) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _department = Value;
                                  departmentcontroller.text = _department!.id;
                                });
                              },
                              items: _departmentList.map((Department user) {
                                return DropdownMenuItem<Department>(
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
                            height: height * 0.02,
                          ),
                          Text(KeyValues.cc,
                              style: ColorCollection.titleStyleGreen),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            height: height * 0.06,
                            width: width,
                            decoration: kDropdownContainerDeco,
                            child: TextFormField(
                              controller: cccontroller,
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
                          Text(KeyValues.tags,
                              style: ColorCollection.titleStyleGreen),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            decoration: kDropdownContainerDeco,
                            child: DropdownButtonFormField<Tags>(
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
                              value: _tags,
                              onChanged: (Value) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _tags = Value;
                                  tagscontroller.text = _tags!.id;
                                });
                              },
                              items: _tagsList.map((Tags user) {
                                return DropdownMenuItem<Tags>(
                                  value: user,
                                  child: SizedBox(
                                    width: width * 0.7,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        user.name,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Text(
                            KeyValues.assignticket,
                            style: ColorCollection.titleStyleGreen,
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            decoration: kDropdownContainerDeco,
                            child: DropdownButtonFormField<AssignTicket>(
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
                              value: _assignticket,
                              onChanged: (Value) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _assignticket = Value;
                                  Staffname = '';
                                  assigntickettcontroller.text =
                                      _assignticket!.id;
                                  print(Value.toString());
                                });
                              },
                              items: _assignticketList.map((AssignTicket user) {
                                return DropdownMenuItem<AssignTicket>(
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
                            height: height * 0.02,
                          ),
                          Text(
                            KeyValues.selectPriority,
                            style: ColorCollection.titleStyleGreen,
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            decoration: kDropdownContainerDeco,
                            child: DropdownButtonFormField<Priority>(
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
                              value: _priority,
                              onChanged: (Value) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _priority = Value;
                                  taskprioritycontroller.text = _priority!.id;
                                  print(taskprioritycontroller.text);
                                });
                              },
                              items: _priorityList.map((Priority user) {
                                return DropdownMenuItem<Priority>(
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
                            height: height * 0.02,
                          ),
                          Text(
                            KeyValues.selectService,
                            style: ColorCollection.titleStyleGreen,
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            decoration: kDropdownContainerDeco,
                            child: DropdownButtonFormField<Service>(
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
                              value: _service,
                              onChanged: (Value) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _service = Value;
                                  servicecontroller.text = _service!.id;
                                });
                              },
                              items: _serviceList.map((Service user) {
                                return DropdownMenuItem<Service>(
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
                            height: height * 0.02,
                          ),
                          Text(
                            KeyValues.project,
                            style: ColorCollection.titleStyleGreen,
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            decoration: kDropdownContainerDeco,
                            child: DropdownButtonFormField<Project>(
                              hint: _project != null
                                  ? Text(
                                      _project!.name,
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : Text(KeyValues.projHint),
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
                              // value: _project,
                              onChanged: (Value) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _project = Value;
                                  taskprojectcontroller.text = _project!.id;
                                });
                              },
                              items: _projectList.map((Project user) {
                                return DropdownMenuItem<Project>(
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
                            height: height * 0.02,
                          ),
                          Text(
                            KeyValues.ticketBody,
                            style: ColorCollection.titleStyleGreen,
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            decoration: kDropdownContainerDeco,
                            child: DropdownButtonFormField<Ticket>(
                              hint: Text(KeyValues.tickethint),
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
                              value: _ticket,
                              onChanged: (Value) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _ticket = Value;
                                  taskprojectcontroller.text = _ticket!.id;
                                  replyticketcontroller.text = _ticket!.message;
                                });
                              },
                              items: _ticketList.map((user) {
                                return DropdownMenuItem(
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
                            height: height * 0.02,
                          ),
                          HtmlEditor(
                            controller: controller,
                            htmlEditorOptions: HtmlEditorOptions(
                              hint: KeyValues.yourtexthere,
                            ),
                            otherOptions: OtherOptions(
                              decoration: kDropdownContainerDeco,
                              height: height * 0.17,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Text(
                                            KeyValues.selectImage,
                                            style: ColorCollection.titleStyle,
                                            textAlign: TextAlign.center,
                                          ),
                                          Spacer(),
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.black,
                                                )),
                                          )
                                        ],
                                      ),
                                      content: Container(
                                        height: height * 0.12,
                                        width: width,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    _getFromCamera();
                                                  },
                                                  child: Icon(
                                                    Icons.camera,
                                                    size: 50,
                                                  ),
                                                ),
                                                SizedBox(height: height * 0.02),
                                                Text(KeyValues.camera),
                                              ],
                                            ),
                                            VerticalDivider(
                                              color: Colors.grey,
                                              thickness: 1,
                                            ),
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    _getFromGallery();
                                                  },
                                                  child: Icon(
                                                    Icons.image,
                                                    size: 50,
                                                  ),
                                                ),
                                                SizedBox(height: height * 0.02),
                                                Text(KeyValues.gallery),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              });
                            },
                            child: Container(
                              height: height * 0.06,
                              decoration: kDropdownContainerDeco,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  imageFile == null
                                      ? Icon(Icons.image)
                                      : SizedBox(
                                          height: height * 0.03,
                                          width: width * 0.05,
                                          child: Image.file(
                                            imageFile!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  imageFile == null
                                      ? Text(
                                          KeyValues.nofile,
                                        )
                                      : SizedBox(
                                          width: width * 0.5,
                                          child: Text(
                                            UploadFileName,
                                            overflow: TextOverflow.ellipsis,
                                            style: ColorCollection.titleStyle
                                                .copyWith(
                                                    color: ColorCollection
                                                        .titleColor),
                                          ),
                                        ),
                                  Spacer(),
                                  imageFile == null
                                      ? SizedBox()
                                      : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              imageFile = null;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                          )),
                                ],
                              ),
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
                                    ColorCollection.green),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_formKeyDetail.currentState!.validate()) {
                                    state = 1;
                                    SaveTicketData();
                                  }
                                });
                              },
                              child: state == 0
                                  ? Text(
                                      KeyValues.save,
                                      style: ColorCollection.buttonTextStyle,
                                    )
                                  : SizedBox(
                                      width: 30,
                                      height: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )),
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

  //save ticket on server by multipart api
  Future SaveTicketData() async {
    final uri = Uri.https(APIClasses.BaseURL, APIClasses.GetTicketDetail);
    MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers['authtoken'] = (APIClasses.api_key);
    request.fields['subject'] = subjectcontroller.text;
    request.fields['department'] = departmentcontroller.text;
    request.fields['email'] = emailcontroller.text;
    request.fields['name'] = namecontroller.text;
    request.fields['contactid'] = contactcontroller.text;
    request.fields['userid'] = CommanClass.CustomerID.toString();
    request.fields['cc'] = cccontroller.text;
    request.fields['tags'] = tagscontroller.text;
    request.fields['assigned'] = assigntickettcontroller.text.toString();
    request.fields['priority'] = taskprioritycontroller.text;
    request.fields['service'] = servicecontroller.text;
    request.fields['project_id'] = taskprojectcontroller.text;
    request.fields['message'] = await controller.getText();
    var file;
    print('Submitted  Fields ==' +
        ("Subject" +
            request.fields['subject']! +
            "Department" +
            request.fields['department']! +
            "Contact" +
            request.fields['contactid']! +
            request.fields['userid']! +
            "cc" +
            request.fields['cc']! +
            "tags" +
            request.fields['tags']! +
            "assigned" +
            request.fields['assigned']! +
            "priority" +
            request.fields['priority']! +
            "service" +
            request.fields['service']! +
            "project_id" +
            request.fields['project_id']! +
            "message" +
            request.fields['message']!));
    if (imageFile != null) {
      var stream =
          http.ByteStream(DelegatingStream.typed(imageFile!.openRead()));
      var length = await imageFile!.length();
      file = http.MultipartFile('attachments[]', stream, length,
          filename: UploadFileName);
      request.files.add(file);
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        setState(() {
          print(value);
          state = 0;
          ToastShowClass.coolToastShow(context, "Success", CoolAlertType.success);
          Navigator.pop(context, true);
        });
      });
    } else {
      setState(() {
        state = 0;
        ToastShowClass.coolToastShow(context, "Error", CoolAlertType.error);
      });
    }
  }
}

class Contact {
  String id;
  String name;
  String email;
  Contact(this.id, this.name, this.email);
}

class Department {
  String id;
  String name;

  Department(this.id, this.name);
}

class Tags {
  String id;
  String name;

  Tags(this.id, this.name);
}

class AssignTicket {
  String id;
  String name;
  AssignTicket(this.id, this.name);
}

class Priority {
  String id;
  String name;

  Priority(this.id, this.name);
}

class Service {
  String id;
  String name;

  Service(this.id, this.name);
}

class Project {
  String id;
  String name;

  Project(this.id, this.name);
}

class Ticket {
  String id;
  String name;
  String message;

  Ticket(this.id, this.name, this.message);
}
