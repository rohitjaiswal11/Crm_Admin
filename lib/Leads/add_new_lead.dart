// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, avoid_print, non_constant_identifier_names, unused_field, unnecessary_null_comparison, prefer_if_null_operators, import_of_legacy_library_into_null_safe, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';

import '../Plugin/lbmplugin.dart';

class AddNewLead extends StatefulWidget {
  static const id = '/AddNewLead';
  String LeadID;
  AddNewLead({required this.LeadID});

  @override
  AddNewLeadState createState() => AddNewLeadState();
}

class AddNewLeadState extends State<AddNewLead> {
  List<Tags> _tags = [];
  List<Language> _languages = Language.getLanguage();
  String dateCurrent = "";

  List<Staff> _staff = [];
  List tags = [];

  List staff = [];
  List language = [];
  late List<DropdownMenuItem<Country>> _dropdownMenuItems;
  late List<DropdownMenuItem<Tags>> _dropdownMenuItemstags;
  late List<DropdownMenuItem<Sources>> _dropdownMenuItemssource;
  late List<DropdownMenuItem<Status>> _dropdownMenuItemsstatus;
  late List<DropdownMenuItem<Staff>> _dropdownMenuItemsstaff;
  late List<DropdownMenuItem<Language>> _dropdownMenuItemslanguage;
  Country? _selectedCountry;
  List<Country> _countries = Country.getCountries();
  Tags? _selectTags;
  Sources? _selectSource;
  List<Sources> _sources = [];
  List sources = [];
  Status? _selectStatus;
  List status = [];
  List<Status> _status = [];
  Staff? _selectStaff;
  Language? _selectLanguage;
  //Initializing the controller
  final _formKey = GlobalKey<FormState>();
  final leadnamecontroller = TextEditingController();
  final leadtitlecontroller = TextEditingController();
  final leadcompanynamecontroller = TextEditingController();
  final leadwebsitenamecontroller = TextEditingController();
  final leademailcontroller = TextEditingController();
  final leadphonecontroller = TextEditingController();
  final leadaddresscontroller = TextEditingController();
  final leadcitycontroller = TextEditingController();
  final leadstatecontroller = TextEditingController();
  final leadzipcodecontroller = TextEditingController();
  final leadtagscontroller = TextEditingController();
  final leadlanguagecontroller = TextEditingController();
  final leadassignedcontroller = TextEditingController();
  final leadstatuscontroller = TextEditingController();
  final leadsourcecontroller = TextEditingController();
  final leaddescriptioncontroller = TextEditingController();
  final leadcontactDatecontroller = TextEditingController();
  final leadcontactTodaycontroller = TextEditingController();
  final leadispubliccontroller = TextEditingController();
  String oldStaff_ID = '';
  String Staff_ID = '';
  bool invoicebool = false;

  @override
  void initState() {
    super.initState();
    getTagsData();
    getSourcesData();
    getStatusData();
    getStaffData();
    //new Lead then start if case otherwise for update old lead
    if (CommanClass.LeadUpdateNew == "New") {
      getData();

      _dropdownMenuItems = buildDropdownMenuItems(_countries);
      _dropdownMenuItemstags = buildDropdownMenuItemstags(_tags);
      _dropdownMenuItemssource = buildDropdownMenuItemssource(_sources);
      _dropdownMenuItemsstatus = buildDropdownMenuItemsstatus(_status);
      _dropdownMenuItemsstaff = buildDropdownMenuItemsstaff(_staff);
      _dropdownMenuItemslanguage = buildDropdownMenuItemslanguage(_languages);
    } else {
      setState(() {
//initialization the data in field
        print("update lead : " + CommanClass.LeadData.toString());
        leadnamecontroller.text =
            CommanClass.LeadData[0]['name'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['name'].toString();
        leadtitlecontroller.text =
            CommanClass.LeadData[0]['title'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['title'].toString();
        leadcompanynamecontroller.text =
            CommanClass.LeadData[0]['company'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['company'].toString();
        leaddescriptioncontroller.text =
            CommanClass.LeadData[0]['description'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['description'].toString();
        leadzipcodecontroller.text =
            CommanClass.LeadData[0]['zip'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['zip'].toString();
        leadsourcecontroller.text =
            CommanClass.LeadData[0]['source'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['source'].toString();
        leadstatuscontroller.text =
            CommanClass.LeadData[0]['status'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['status'].toString();
        leadassignedcontroller.text =
            CommanClass.LeadData[0]['assigned'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['assigned'].toString();
        leadtagscontroller.text =
            CommanClass.LeadData[0]['tags'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['tags'].toString();
        leademailcontroller.text =
            CommanClass.LeadData[0]['email'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['email'].toString();
        leadwebsitenamecontroller.text =
            CommanClass.LeadData[0]['website'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['website'].toString();
        leadphonecontroller.text =
            CommanClass.LeadData[0]['phonenumber'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['phonenumber'].toString();
        leadaddresscontroller.text =
            CommanClass.LeadData[0]['address'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['address'].toString();
        leadcitycontroller.text =
            CommanClass.LeadData[0]['city'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['city'].toString();
        leadstatecontroller.text =
            CommanClass.LeadData[0]['state'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['state'].toString();
        leadlanguagecontroller.text =
            CommanClass.LeadData[0]['default_language'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['default_language'].toString();
        leadcontactDatecontroller.text =
            CommanClass.LeadData[0]['lastcontact'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['lastcontact'].toString();
        leadispubliccontroller.text =
            CommanClass.LeadData[0]['is_public'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['is_public'].toString();
        leadcontactTodaycontroller.text =
            CommanClass.LeadData[0]['contacted_today'].toString() == null
                ? ""
                : CommanClass.LeadData[0]['contacted_today'].toString();
      });
    }
//    _selectTags =_dropdownMenuItemstags[0].value;
//    _selectSource = _dropdownMenuItemssource[0].value;
//    _selectStatus = _dropdownMenuItemsstatus[0].value;
  }

  void getData() async {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    //2020-01-01 00:00:00
    var formattedDate =
        "${dateParse.year}-${dateParse.month}-${dateParse.day} 00:00:00";
    oldStaff_ID = CommanClass.StaffId;
    setState(() {
      dateCurrent = formattedDate.toString();
      Staff_ID = oldStaff_ID;
    });
  }

//Tags List Show by API
  void getTagsData() async {
    final paramDic = {
      "type": "tag",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetLeadStatus, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      tags = data['data'];

      for (int i = 0; i < tags.length; i++) {
        setState(() {
          _tags.add(Tags(tags[i]['id'], tags[i]['name']));
        });
      }
      print(_tags[0].id);
    } else {
      _tags.clear();
    }
  }

  //get Staff List By API
  void getStaffData() async {
    final paramDic = {
      "type": "staff",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetLeadStatus, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      staff = data['data'];

      for (int i = 0; i < staff.length; i++) {
        setState(() {
          _staff.add(Staff(staff[i]['staffid'],
              staff[i]['firstname'] + ' ' + staff[i]['lastname']));
        });
      }
      print(_staff[0].name);
    } else {
      _staff.clear();
    }
  }

  //get Sources Data by API
  void getSourcesData() async {
    final paramDic = {
      "type": "sources",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetLeadStatus, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      sources = data['data'];

      for (int i = 0; i < sources.length; i++) {
        _sources.add(Sources(sources[i]['id'], sources[i]['name']));
      }
    } else {
      _sources.clear();
    }
  }

  //Get Status Data by API
  void getStatusData() async {
    final paramDic = {
      "type": "status",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetLeadStatus, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      status = data['data'];

      for (int i = 0; i < status.length; i++) {
        _status.add(Status(status[i]['id'], status[i]['name']));
      }
    } else {
      _status.clear();
    }
  }

  List<DropdownMenuItem<Language>> buildDropdownMenuItemslanguage(
      List<Language> language) {
    List<DropdownMenuItem<Language>> items = [];
    for (Language lg in language) {
      items.add(
        DropdownMenuItem(
          value: lg,
          child: Text(lg.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Staff>> buildDropdownMenuItemsstaff(List<Staff> staff) {
    List<DropdownMenuItem<Staff>> items = [];
    for (Staff country in staff) {
      items.add(
        DropdownMenuItem(
          value: country,
          child: Text(country.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Country>> buildDropdownMenuItems(List countries) {
    List<DropdownMenuItem<Country>> items = [];
    for (Country country in countries) {
      items.add(
        DropdownMenuItem(
          value: country,
          child: Text(country.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Tags>> buildDropdownMenuItemstags(List<Tags> tags) {
    List<DropdownMenuItem<Tags>> items = [];
    for (Tags t in tags) {
      items.add(
        DropdownMenuItem(
          value: t,
          child: Text(t.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Sources>> buildDropdownMenuItemssource(
      List<Sources> sources) {
    List<DropdownMenuItem<Sources>> items = [];
    for (Sources s in sources) {
      items.add(
        DropdownMenuItem(
          value: s,
          child: Text(s.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Status>> buildDropdownMenuItemsstatus(
      List<Status> status) {
    List<DropdownMenuItem<Status>> items = [];
    for (Status t in status) {
      items.add(
        DropdownMenuItem(
          value: t,
          child: Text(t.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownTags(Tags selectTags) {
    setState(() {
      _selectTags = selectTags;
    });
  }

  onChangeDropdownSource(Sources selectSource) {
    setState(() {
      _selectSource = selectSource;
    });
  }

  onChangeDropdownStatus(Status selectStatus) {
    setState(() {
      _selectStatus = selectStatus;
    });
  }

  final deco = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: Colors.grey.shade300, width: 1),
    color: Color(0xFFF8F8F8),
  );
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: ColorCollection.grey,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height * 0.23,
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
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/first.png'),
                            fit: BoxFit.fill),
                      ),
                      height: height * 0.1,
                      width: width * 0.2,
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    FittedBox(
                      child: Text(KeyValues.leads,
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
                    SizedBox(
                      width: width * 0.05,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                width: width,
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.04),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    leadRow(
                        height,
                        width,
                        KeyValues.name,
                        KeyValues.phoneNumber,
                        Icons.person,
                        leadnamecontroller,
                        leadphonecontroller,
                        Icons.phone),
                    leadRow(
                        height,
                        width,
                        KeyValues.title,
                        KeyValues.address,
                        Icons.wifi,
                        leadtitlecontroller,
                        leadaddresscontroller,
                        Icons.sports_basketball),
                    leadRow(
                        height,
                        width,
                        KeyValues.companyName,
                        KeyValues.cityName,
                        Icons.location_city,
                        leadcompanynamecontroller,
                        leadcitycontroller,
                        Icons.gps_fixed),
                    leadRow(
                        height,
                        width,
                        KeyValues.language,
                        KeyValues.stateName,
                        Icons.pin_drop,
                        leadlanguagecontroller,
                        leadstatecontroller,
                        Icons.saved_search_sharp),
                    leadRow(
                        height,
                        width,
                        KeyValues.Email,
                        KeyValues.zipCode,
                        Icons.gps_fixed,
                        leademailcontroller,
                        leadzipcodecontroller,
                        Icons.add_location_outlined),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width * 0.42,
                          decoration: deco,
                          child: DropdownButtonFormField<Tags>(
                            hint: Text(
                              KeyValues.selectTags,
                              softWrap: true,
                              style: ColorCollection.subTitleStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: ColorCollection.titleStyle,
                            elevation: 8,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.pin_drop,
                                color: ColorCollection.backColor,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.005),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 2),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 2),
                              ),
                            ),
                            dropdownColor: Colors.grey.shade100,
                            value: _selectTags,
                            onChanged: (Tags? newValue) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _selectTags = newValue!;
                                leadtagscontroller.text = _selectTags!.id;
                                print(_selectTags!.name);
                                print(_selectTags!.id);
                              });
                            },
                            items: _tags.map((Tags user) {
                              return DropdownMenuItem<Tags>(
                                value: user,
                                child: SizedBox(
                                  width: width * 0.2,
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
                        Container(
                          width: width * 0.42,
                          decoration: deco,
                          child: DropdownButtonFormField<Staff>(
                            hint: Text(
                              KeyValues.selectAssigned,
                              softWrap: true,
                              style: ColorCollection.subTitleStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: ColorCollection.titleStyle,
                            elevation: 8,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.saved_search_outlined,
                                color: ColorCollection.backColor,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.005),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 2),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 2),
                              ),
                            ),
                            dropdownColor: Colors.grey.shade100,
                            value: _selectStaff,
                            onChanged: (Staff? Value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _selectStaff = Value;
                                leadassignedcontroller.text = _selectStaff!.id;
                              });
                            },
                            items: _staff.map((Staff user) {
                              return DropdownMenuItem<Staff>(
                                value: user,
                                child: SizedBox(
                                  width: width * 0.22,
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
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width * 0.42,
                          decoration: deco,
                          child: DropdownButtonFormField<Language>(
                            hint: SizedBox(
                              width: width * 0.2,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  KeyValues.selectLanguage,
                                  softWrap: true,
                                  style: ColorCollection.subTitleStyle,
                                ),
                              ),
                            ),
                            style: ColorCollection.titleStyle,
                            elevation: 8,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.gps_fixed,
                                color: ColorCollection.backColor,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.005),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 2),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 2),
                              ),
                            ),
                            dropdownColor: Colors.grey.shade100,
                            value: _selectLanguage,
                            onChanged: (Language? Value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _selectLanguage = Value;
                                leadlanguagecontroller.text =
                                    _selectLanguage!.name;
                              });
                            },
                            items: _languages.map((Language user) {
                              return DropdownMenuItem<Language>(
                                value: user,
                                child: SizedBox(
                                  width: width * 0.2,
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
                        Container(
                          width: width * 0.42,
                          decoration: deco,
                          child: DropdownButtonFormField<Status>(
                            hint: SizedBox(
                                width: width * 0.2,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    KeyValues.selectStatus,
                                    softWrap: true,
                                    style: ColorCollection.subTitleStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                            style: ColorCollection.titleStyle,
                            elevation: 8,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.add_location_sharp,
                                color: ColorCollection.backColor,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.005),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 2),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 2),
                              ),
                            ),
                            dropdownColor: Colors.grey.shade100,
                            value: _selectStatus,
                            onChanged: (Status? Value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _selectStatus = Value;
                                leadstatuscontroller.text = _selectStatus!.id;
                              });
                              print(leadstatuscontroller.text);
                            },
                            items: _status.map((Status? user) {
                              return DropdownMenuItem<Status>(
                                  value: user,
                                  child: SizedBox(
                                      width: width * 0.2,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          user!.name,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )));
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
                          width: width * 0.42,
                          decoration: deco,
                          child: DropdownButtonFormField<Sources>(
                            hint: SizedBox(
                                width: width * 0.2,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    KeyValues.selectSource,
                                    softWrap: true,
                                    style: ColorCollection.subTitleStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                            style: ColorCollection.titleStyle,
                            elevation: 8,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.gps_fixed,
                                color: ColorCollection.backColor,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.005),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 2),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade100, width: 2),
                              ),
                            ),
                            dropdownColor: Colors.grey.shade100,
                            value: _selectSource,
                            onChanged: (Sources? Value) {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _selectSource = Value;
                                leadsourcecontroller.text = _selectSource!.id;
                              });
                            },
                            items: _sources.map((Sources? user) {
                              return DropdownMenuItem<Sources>(
                                value: user,
                                child: SizedBox(
                                  width: width * 0.2,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      user!.name,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            CheckDate(1);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03,
                                  vertical: height * 0.015),
                              width: width * 0.42,
                              decoration: deco,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: ColorCollection.titleColor,
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  leadcontactDatecontroller.text.isEmpty
                                      ? Text(
                                          KeyValues.selectContactDate,
                                          style: ColorCollection.subTitleStyle,
                                        )
                                      : Text(
                                          leadcontactDatecontroller.text
                                              .substring(0, 10),
                                          style: ColorCollection.titleStyle,
                                        ),
                                ],
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            CheckDate(2);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03,
                                  vertical: height * 0.015),
                              width: width * 0.42,
                              decoration: deco,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: ColorCollection.titleColor,
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  leadcontactTodaycontroller.text.isEmpty
                                      ? Text(
                                          KeyValues.selectContactToday,
                                          style: ColorCollection.subTitleStyle,
                                        )
                                      : Text(
                                          leadcontactTodaycontroller.text
                                              .substring(0, 10),
                                          style: ColorCollection.titleStyle,
                                        ),
                                ],
                              )),
                        ),
                        Container(
                          width: width * 0.42,
                          decoration: deco,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * 0.01,
                              ),
                              Icon(
                                Icons.sort,
                                color: ColorCollection.titleColor,
                              ),
                              Text(
                                KeyValues.private,
                                style: ColorCollection.subTitleStyle2,
                              ),
                              Switch(
                                activeColor: ColorCollection.backColor,
                                value: invoicebool,
                                onChanged: (newVal) {
                                  setState(
                                    () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      invoicebool = newVal;
                                      leadispubliccontroller.text =
                                          invoicebool == false ? '1' : '0';
                                      print(leadispubliccontroller.text);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                        decoration: deco,
                        height: height * 0.08,
                        child: Center(
                          child: TextFormField(
                            controller: leaddescriptioncontroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the Description';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.edit_location_alt_rounded,
                                color: ColorCollection.titleColor,
                                size: 28,
                              ),
                              hintText: KeyValues.description,
                              hintStyle: ColorCollection.subTitleStyle2,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.01,
                                  vertical: height * 0.018),
                              border: InputBorder.none,
                            ),
                          ),
                        )),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    SizedBox(
                      width: width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ColorCollection.backColor)),
                        onPressed: () {
                          if (CommanClass.LeadUpdateNew == "New") {
                            final _isValid = _formKey.currentState!.validate();
                            if (!_isValid) {
                              return;
                            } else if (_isValid) {
                              LeadSaveData();
                            }
                          }
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
            ],
          ),
        ),
      ),
    );
  }

  Widget leadRow(
      double height,
      double width,
      String firstItemHint,
      String secondItemHint,
      IconData? firstItemIcon,
      TextEditingController? controllerfirst,
      TextEditingController? controllersecond,
      IconData? secondItemIcon) {
    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              decoration: deco,
              height: height * 0.08,
              width: width * 0.42,
              child: Center(
                child: TextFormField(
                  controller: controllerfirst,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      firstItemIcon,
                      color: ColorCollection.titleColor,
                      size: 28,
                    ),
                    hintText: firstItemHint,
                    hintStyle: ColorCollection.subTitleStyle2,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: width * 0.01, vertical: height * 0.018),
                    border: InputBorder.none,
                  ),
                ),
              )),
          Container(
            decoration: deco,
            height: height * 0.08,
            width: width * 0.42,
            child: Center(
              child: TextFormField(
                controller: controllersecond,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    secondItemIcon,
                    color: ColorCollection.backColor,
                    size: 28,
                  ),
                  hintText: secondItemHint,
                  hintStyle: ColorCollection.subTitleStyle2,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: width * 0.01, vertical: height * 0.018),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// API

  void CheckDate(int choose) {
    if (choose == 1) {
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2001),
              lastDate: DateTime(5050))
          .then((date) {
        setState(() {
          leadcontactDatecontroller.text = DateFormat("yyyy-MM-dd 00:00:00")
              .format(date == null ? DateTime.now() : date);
        });
      });
    }
    if (choose == 2) {
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2001),
              lastDate: DateTime(5050))
          .then((date) {
        setState(() {
          leadcontactTodaycontroller.text = DateFormat("yyyy-MM-dd 00:00:00")
              .format(date == null ? DateTime.now() : date);
        });
      });
    }
    if (choose == 3) {
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2001),
              lastDate: DateTime(5050))
          .then((date) {
        setState(() {
          dateCurrent = DateFormat("yyyy-MM-dd 00:00:00")
              .format(date == null ? DateTime.now() : date);
          leadcontactTodaycontroller.text = dateCurrent.toString();
          leadcontactDatecontroller.text = dateCurrent.toString();
        });
      });
    }
  }

  //Save Lead API Hit
  Future<void> LeadSaveData() async {
    final paramDic = {
      "name": leadnamecontroller.text,
      "source": leadsourcecontroller.text,
      "status": leadstatuscontroller.text,
      "assigned": leadassignedcontroller.text,
      "tags": leadtagscontroller.text,
      "title": leadtitlecontroller.text,
      "email": leademailcontroller.text,
      "website": leadwebsitenamecontroller.text,
      "phonenumber": leadphonecontroller.text,
      "company": leadcompanynamecontroller.text,
      "address": leadaddresscontroller.text,
      "city": leadcitycontroller.text,
      "zip": leadzipcodecontroller.text,
      "state": leadstatecontroller.text,
      "default_language": leadlanguagecontroller.text,
      "description": leaddescriptioncontroller.text,
      "custom_contact_date": leadcontactDatecontroller.text,
      "is_public": leadispubliccontroller.text,
      "contacted_today": leadcontactTodaycontroller.text
    };
    print("Note Param" + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.CreateLead, paramDic, "Post", Api_Key_by_Admin);
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

  //Update Lead API Hit
  Future<void> LeadUpdateData() async {
    print("update lead");
    final paramDic = {
      "leadid": widget.LeadID,
      "name": leadnamecontroller.text,
      "source": leadsourcecontroller.text,
      "status": leadstatuscontroller.text,
      "assigned": leadassignedcontroller.text,
      "tags": leadtagscontroller.text,
      "title": leadtitlecontroller.text,
      "email": leademailcontroller.text,
      "website": leadwebsitenamecontroller.text,
      "phonenumber": leadphonecontroller.text,
      "company": leadcompanynamecontroller.text,
      "address": leadaddresscontroller.text,
      "city": leadcitycontroller.text,
      "zip": leadzipcodecontroller.text,
      "state": leadstatecontroller.text,
      "default_language": leadlanguagecontroller.text,
      "description": leaddescriptioncontroller.text,
      "lastcontact": leadcontactDatecontroller.text,
      "is_public": leadispubliccontroller.text,
//      "contacted_today":leadcontactTodaycontroller.text
    };
    print("Note Param" + paramDic.toString());
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.UpdateLead, paramDic, "Post", Api_Key_by_Admin);
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

//Model class for Tags
class Tags {
  String id;
  String name;

  Tags(this.id, this.name);
}

//Model class for Sources
class Sources {
  String id;
  String name;

  Sources(this.id, this.name);
}

//Model class for status
class Status {
  String id;
  String name;

  Status(this.id, this.name);
}

//Model class For Staff
class Staff {
  String id;
  String name;

  Staff(this.id, this.name);
}

//Model Class for Priorities
class Priorities {
  String id;
  String name;

  Priorities(this.id, this.name);
}

//Model Class For Language
class Language {
  int id;
  String name;

  Language(this.id, this.name);

  static List<Language> getLanguage() {
    return <Language>[
      Language(1, 'English'),
      Language(2, 'Hindi'),
      Language(3, 'Punjabi'),
    ];
  }
}
