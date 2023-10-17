// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, must_be_immutable, import_of_legacy_library_into_null_safe, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/storage_manger.dart';

import '../../Plugin/lbmplugin.dart';



List notes = [];
List notesnew = [];
List notessearch = [];

class CustomerNotes extends StatefulWidget {
  String CustomerID = '';

  CustomerNotes({required this.CustomerID});

  @override
  _CustomerNotesState createState() => _CustomerNotesState();
}

class _CustomerNotesState extends State<CustomerNotes> {
  List Passnotes = [];

  List datanotes = [];
  List dataHeader = [];
  int limit = 20;
  int start = 1;
  var isDataFetched = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print(widget.CustomerID);
    getnotesDashboard();
  }

  @override
  void dispose() {
    super.dispose();
    datanotes = [];
    dataHeader = [];
    limit = 20;
    start = 1;
    isDataFetched = false;
    notes.clear();
    notesnew.clear();
    notessearch.clear();
  }

  Future<void> getnotesDashboard() async {
    final paramDic = {
      "type": "notes",
      "lead_id": widget.CustomerID.toString(),
      "typeby": "customer",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetLeadReminderNotes, paramDic, "Get", Api_Key_by_Admin);
    log(response.body.toString());
    var data = json.decode(response.body);
    notes.clear();
    notesnew.clear();
    notessearch.clear();
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
        notes = data['data'];
        // dataHeader.add(data['data']);
        notesnew.addAll(notes);
        notessearch.addAll(notes);
        isDataFetched = true;
      });
    } else {
      setState(() {
        isDataFetched = true;
        notes.clear();
        notesnew.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorCollection.backColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          bottomsheetAddNote();
        },
      ),
      body: SelectionArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                height: height * 0.06,
                width: width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: height * 0.06,
                      width: width * 0.75,
                      child: TextFormField(
                        onChanged: onSearchTextChanged,
                        decoration: InputDecoration(
                          hintText: 'Search Notes',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.01),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.06,
                      width: width * 0.11,
                      decoration: BoxDecoration(
                          color: ColorCollection.darkGreen,
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        onPressed: () {},
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
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              height: height * 0.632,
              decoration:
                  kContaierDeco.copyWith(color: ColorCollection.containerC),
              child: _getBodyWidget(),
            )
          ],
        ),
      ),
    );
  }

  Future<void> bottomsheetAddNote({var note}) async {
    Future<void> future = showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: NoteAddWidget(
          Customerid: widget.CustomerID.toString(),
          note: note,
        ),
      ),
    );
    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {
    getnotesDashboard();
  }

  Widget _getBodyWidget() {
    return Container(
      child: isDataFetched == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : notesnew.isNotEmpty
              ? ListView.builder(
                  itemCount: notesnew.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
//                            return buildList(context, index);
                    return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (DismissDirection direction) {
                          if (direction == DismissDirection.startToEnd) {
                            bottomsheetAddNote(note: notesnew[index])
                                .then((value) => getnotesDashboard());
                          } else if (direction == DismissDirection.endToStart) {
                            setState(() {
                              deleteNote(notesnew[index]['id'].toString())
                                  .then((value) => getnotesDashboard());
                            });
                          }
                        },
                        background: slideRightBackground(),
                        secondaryBackground: slideLeftBackground(),
                        child: NoteViewList(context, index));
                  })
              : Center(
                  child: Text('no data'),
                ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: ColorCollection.green,
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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
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

  Widget NoteViewList(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      notesnew[index]['addedfrom_name'].toString() == " "
                          ? '...'
                          : notesnew[index]['addedfrom_name'].toString(),
                      style: ColorCollection.titleStyle,
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      notesnew[index]['dateadded'].toString(),
                      style: TextStyle(
                        color: ColorCollection.titleColor,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Html(
                  data: notesnew[index]['description'],
                  shrinkWrap: true,
                ),
                // Text(
                //   notesnew[index]['description'].toString(),
                //   textAlign: TextAlign.justify,
                //   style: TextStyle(
                //     //color: Colors.black,
                //     fontSize: 10.0,
                //   ),
                // ),
                Divider(
                  color: ColorCollection.backColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteNote(
    String id,
  ) async {
    final paramDic = {
      "type": 'notes',
      "note_id": id,
      "lead_id": widget.CustomerID,
      "staff_id": CommanClass.StaffId,
      "typeby": "customer",
    };

    print(paramDic);
    var response = await LbmPlugin.APIMainClass(
        Base_Url_For_App,
        APIClasses.AddLeadReminderNotes + '/deletenote',
        paramDic,
        "Post",
        Api_Key_by_Admin);
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
      });
    } else {
      setState(() {
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.error);
      });
    }
  }

  onSearchTextChanged(String text) async {
    notesnew.clear();
    if (text.isEmpty) {
      setState(() {
        notesnew = List.from(notessearch);
      });
      return;
    }

    setState(() {
      notesnew = notessearch
          .where((item) => item['addedfrom_name']
              .toString()
              .toLowerCase()
              .contains(text.toString().toLowerCase()))
          .toList();
    });
  }
}

class NoteAddWidget extends StatefulWidget {
  String Customerid = '';
  var note;
  NoteAddWidget({required this.Customerid, this.note});
  @override
  _NoteAddWidgetState createState() => _NoteAddWidgetState();
}

class _NoteAddWidgetState extends State<NoteAddWidget> {
  final TextStyle subtitle =
      TextStyle(fontSize: CommanClass.body_textsize, color: Colors.grey);
  final TextStyle label =
      TextStyle(fontSize: CommanClass.header_textsize, color: Colors.grey);
  String dateCurrent = "";
  final _formKey = GlobalKey<FormState>();
  final Description = TextEditingController();
  var CurrentDate = TextEditingController();
  int _state = 0;
  String? oldStaff_ID, oldLead_ID;
  String? Staff_ID, Lead_ID;
  String Type = 'notes';
  int notifymail = 0;
  String? noteId;
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");

  getEditData() {
    if (widget.note != null) {
      setState(() {
        noteId = widget.note['id'];
        Description.text = widget.note['description'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    getEditData();
  }

  void getData() async {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    //2020-01-01 00:00:00
    var formattedDate =
        "${dateParse.year}-${dateParse.month}-${dateParse.day} ${dateParse.hour}:${dateParse.minute}:${dateParse.second}";
    oldStaff_ID = await SharedPreferenceClass.GetSharedData("staff_id");

    oldLead_ID = widget.Customerid.toString();
    setState(() {
      CurrentDate.text = formattedDate.toString();
      Type = 'notes';
      Staff_ID = oldStaff_ID;
      Lead_ID = oldLead_ID;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: ColorCollection.backColor,
              child: Text(
                "Note description",
                style: ColorCollection.buttonTextStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Description';
                        }
                        return null;
                      },
                      controller: Description,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        // contentPadding: const EdgeInsets.symmetric(vertical: 60.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorCollection.backColor, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'Enter  Description',
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ignore: deprecated_member_use
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_formKey.currentState!.validate()) {
                                if (_state == 0) {
                                  setState(() {
                                    _state = 1;
                                    SubmitReminderAPI(
                                        Type,
                                        Lead_ID!,
                                        Staff_ID!,
                                        Description.text,
                                        CurrentDate.text,
                                        notifymail);
                                  });
                                }
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side: BorderSide(color: Colors.lightBlue)),
                            backgroundColor: ColorCollection.backColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                              widget.note != null
                                  ? 'Update ${KeyValues.note.toUpperCase()}'
                                  : KeyValues.submit.tr().toUpperCase(),
                              style: TextStyle(
                                  fontSize: CommanClass.header_textsize)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void SubmitReminderAPI(String type, String lead_id, String staff_id,
      String description, String currentDate, int notifymail) async {
    final paramDic = {
      if (widget.note != null && noteId != null) "note_id": noteId,
      "type": type.toString(),
      "lead_id": lead_id.toString(),
      "description": description.toString(),
      "staff_id": staff_id.toString(),
      "date_contacted": currentDate.toString(),
      "notify_by_email": notifymail.toString(),
      "typeby": "customer",
    };

    print(paramDic);
    var response = await LbmPlugin.APIMainClass(
        Base_Url_For_App,
        APIClasses.AddLeadReminderNotes +
            (widget.note == null ? '' : '/updatenote'),
        paramDic,
        "Post",
        Api_Key_by_Admin);
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
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.success);
        Navigator.pop(context, true);
      });
    } else {
      setState(() {
        _state = 0;
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.error);
      });
    }
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return Text(
        "SUBMIT",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void CheckDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2001),
            lastDate: DateTime(5050))
        .then((date) {
      if (date != null) {
        setState(() {
          dateCurrent = DateFormat("yyyy-MM-dd 00:00:00").format(date);
          //2020-01-01 00:00:00

          CurrentDate.text = dateCurrent;
          // print(dateTime);
        });
      }
    });
  }
}
