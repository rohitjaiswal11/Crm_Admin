// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';

class FilterDialogBox extends StatefulWidget {
  const FilterDialogBox({Key? key}) : super(key: key);

  @override
  _FilterDialogBoxState createState() => _FilterDialogBoxState();
}

class _FilterDialogBoxState extends State<FilterDialogBox> {
  String _DateAddedStart = 'Start Date',
      _DateAddedEnd = 'End Date',
      _DateAssignedStart = 'Start Date',
      _DateAssignedEnd = 'End Date',
      _LastStatusChangedStart = 'Start Date',
      _LastStatusChangedEnd = 'End Date',
      _LastContactDateStart = 'Start Date',
      _LastContactDateEnd = 'End Date',
      _DateConvertedStart = 'Start Date',
      _DateConvertedEnd = 'End Date';

  bool dateaddedcheck = false;
  bool dateassignedcheck = false;
  bool datelastcontactcheck = false;
  bool dateconvertedcheck = false;
  bool datelaststatuscheck = false;
  bool statuscheck = false;
  bool sourcecheck = false;
  int Filterbydateadded = 0;
  int Filterbydateassigned = 0;
  int Filterbydatelastcontact = 0;
  int Filterbydateconverted = 0;
  int Filterbydatelaststatuschanged = 0;
  int Filterbystatus = 0;
  int Filterbysource = 0;
  var FilterDateAdded = '';
  var FilterDateAssigned = '';
  var FilterDateLastContact = '';
  var FilterDateConverted = '';
  var FilterDateLastStatus = '';
  String dateCurrent = '';
  bool showClear = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          height: height * 0.75,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filter -', style: ColorCollection.titleStyle2),
                    if (_DateAddedStart != 'Start Date' ||
                        _DateAddedEnd != 'End Date' ||
                        _DateAssignedStart != 'Start Date' ||
                        _DateAssignedEnd != 'End Date' ||
                        _LastStatusChangedStart != 'Start Date' ||
                        _LastStatusChangedEnd != 'End Date' ||
                        _LastContactDateStart != 'Start Date' ||
                        _LastContactDateEnd != 'End Date' ||
                        _DateConvertedStart != 'Start Date' ||
                        _DateConvertedEnd != 'End Date' ||
                        dateaddedcheck != false ||
                        dateassignedcheck != false ||
                        datelastcontactcheck != false ||
                        dateconvertedcheck != false ||
                        datelaststatuscheck != false ||
                        statuscheck != false ||
                        sourcecheck != false ||
                        Filterbydateadded != 0 ||
                        Filterbydateassigned != 0 ||
                        Filterbydatelastcontact != 0 ||
                        Filterbydateconverted != 0 ||
                        Filterbydatelaststatuschanged != 0 ||
                        Filterbystatus != 0 ||
                        Filterbysource != 0 ||
                        FilterDateAdded != '' ||
                        FilterDateAssigned != '' ||
                        FilterDateLastContact != '' ||
                        FilterDateConverted != '' ||
                        FilterDateLastStatus != '')
                      GestureDetector(
                          onTap: () {
                            clearSelection();
                          },
                          child: Text(
                            'Clear',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          )),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Column(
                    children: [
                      ListTile(
                        title: Text('Date Added',
                            style: ColorCollection.titleStyle),
                        leading: Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                            focusColor: Colors.green,
                            value: dateaddedcheck,
                            onChanged: (value) {
                              setState(() {
                                dateaddedcheck = value!;
                                if (dateaddedcheck) {
                                  Filterbydateadded = 1;
                                } else {
                                  Filterbydateadded = 0;
                                }
                              });
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        color: Colors.grey[50],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                CheckDate(1);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: ColorCollection.darkGreen,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(_DateAddedStart.toString(),
                                      style: ColorCollection.titleStyleGreen3)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                CheckDate(2);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: ColorCollection.darkGreen,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(_DateAddedEnd.toString(),
                                      style: ColorCollection.titleStyleGreen3)
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      ListTile(
                        title: Text('Date Assigned',
                            style: ColorCollection.titleStyle),
                        leading: Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                            focusColor: Colors.green,
                            value: dateassignedcheck,
                            onChanged: (value) {
                              setState(() {
                                dateassignedcheck = value!;
                                if (dateassignedcheck) {
                                  Filterbydateassigned = 1;
                                } else {
                                  Filterbydateassigned = 0;
                                }
                              });
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        color: Colors.grey[50],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                CheckDate(3);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: ColorCollection.darkGreen,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(_DateAssignedStart.toString(),
                                      style: ColorCollection.titleStyleGreen3)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                CheckDate(4);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: ColorCollection.darkGreen,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(_DateAssignedEnd.toString(),
                                      style: ColorCollection.titleStyleGreen3)
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      ListTile(
                        title: Text('Last Contact Date',
                            style: ColorCollection.titleStyle),
                        leading: Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                            focusColor: Colors.green,
                            value: datelastcontactcheck,
                            onChanged: (value) {
                              setState(() {
                                datelastcontactcheck = value!;
                                if (datelastcontactcheck) {
                                  Filterbydatelastcontact = 1;
                                } else {
                                  Filterbydatelastcontact = 0;
                                }
                              });
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        color: Colors.grey[50],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                CheckDate(5);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: ColorCollection.darkGreen,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(_LastContactDateStart.toString(),
                                      style: ColorCollection.titleStyleGreen3)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                CheckDate(6);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: ColorCollection.darkGreen,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(_LastContactDateEnd.toString(),
                                      style: ColorCollection.titleStyleGreen3)
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      ListTile(
                        title: Text('Date Converted',
                            style: ColorCollection.titleStyle),
                        leading: Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                            focusColor: Colors.green,
                            value: dateconvertedcheck,
                            onChanged: (value) {
                              setState(() {
                                dateconvertedcheck = value!;
                                if (dateconvertedcheck) {
                                  Filterbydateconverted = 1;
                                } else {
                                  Filterbydateconverted = 0;
                                }
                              });
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        color: Colors.grey[50],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                CheckDate(7);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: ColorCollection.darkGreen,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(_DateConvertedStart,
                                      style: ColorCollection.titleStyleGreen3)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                CheckDate(8);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: ColorCollection.darkGreen,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(_DateConvertedEnd.toString(),
                                      style: ColorCollection.titleStyleGreen3)
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      ListTile(
                        title: Text('Last Status Changed Date',
                            style: ColorCollection.titleStyle),
                        leading: Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                            focusColor: Colors.green,
                            value: datelaststatuscheck,
                            onChanged: (value) {
                              setState(() {
                                datelaststatuscheck = value!;
                                if (datelaststatuscheck) {
                                  Filterbydatelaststatuschanged = 1;
                                } else {
                                  Filterbydatelaststatuschanged = 0;
                                }
                              });
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        color: Colors.grey[50],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                CheckDate(9);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: ColorCollection.darkGreen,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(_LastStatusChangedStart.toString(),
                                      style: ColorCollection.titleStyleGreen3)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                CheckDate(10);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: ColorCollection.darkGreen,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(_LastStatusChangedEnd.toString(),
                                      style: ColorCollection.titleStyleGreen3)
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (Filterbydateadded == 1) {
                    FilterDateAdded = _DateAddedStart.toString() +
                        ',' +
                        _DateAddedEnd.toString();
                  } else {
                    FilterDateAdded = '';
                  }
                  if (Filterbydateassigned == 1) {
                    FilterDateAssigned = _DateAssignedStart.toString() +
                        ',' +
                        _DateAssignedEnd.toString();
                  } else {
                    FilterDateAssigned = '';
                  }
                  if (Filterbydatelastcontact == 1) {
                    FilterDateLastContact = _LastContactDateStart.toString() +
                        ',' +
                        _LastContactDateEnd.toString();
                  } else {
                    FilterDateLastContact = '';
                  }
                  if (Filterbydateconverted == 1) {
                    FilterDateConverted = _DateConvertedStart.toString() +
                        ',' +
                        _DateConvertedEnd.toString();
                  } else {
                    FilterDateConverted = '';
                  }
                  if (Filterbydatelaststatuschanged == 1) {
                    FilterDateLastStatus = _LastStatusChangedStart.toString() +
                        ',' +
                        _LastStatusChangedEnd.toString();
                  } else {
                    FilterDateLastStatus = '';
                  }
//                        if(FilterDateAdded!='' && FilterDateAssigned!='' && FilterDateLastContact!='' && FilterDateConverted!='' && FilterDateLastStatus!=''){
                  setState(() {
                    CommanClass.DateAdded = FilterDateAdded;
                    CommanClass.DateAssigned = FilterDateAssigned;
                    CommanClass.DateLastContact = FilterDateLastContact;
                    CommanClass.DateConverted = FilterDateConverted;
                    CommanClass.DateLastStatus = FilterDateLastStatus;
                    CommanClass.isFilter = true;
                    Navigator.of(context).pop(true);
                    // Navigator.of(context).pushNamed('/LeadScreen',arguments: RouteArgument(OrderBy: 'asc',Ordername: 'ID'));
                  });

//                        }

                  print(
                      '$FilterDateAdded,$FilterDateAssigned,$FilterDateLastContact,$FilterDateConverted,$FilterDateLastStatus ');
                },
                child: Container(
                  height: height * 0.048,
                  width: width,
                  decoration: BoxDecoration(
                      color: ColorCollection.darkGreen,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text('Apply Filters',
                        style: ColorCollection.buttonTextStyle),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearSelection() {
    setState(() {
      _DateAddedStart = 'Start Date';
      _DateAddedEnd = 'End Date';
      _DateAssignedStart = 'Start Date';
      _DateAssignedEnd = 'End Date';
      _LastStatusChangedStart = 'Start Date';
      _LastStatusChangedEnd = 'End Date';
      _LastContactDateStart = 'Start Date';
      _LastContactDateEnd = 'End Date';
      _DateConvertedStart = 'Start Date';
      _DateConvertedEnd = 'End Date';

      dateaddedcheck = false;
      dateassignedcheck = false;
      datelastcontactcheck = false;
      dateconvertedcheck = false;
      datelaststatuscheck = false;
      statuscheck = false;
      sourcecheck = false;
      Filterbydateadded = 0;
      Filterbydateassigned = 0;
      Filterbydatelastcontact = 0;
      Filterbydateconverted = 0;
      Filterbydatelaststatuschanged = 0;
      Filterbystatus = 0;
      Filterbysource = 0;
      FilterDateAdded = '';
      FilterDateAssigned = '';
      FilterDateLastContact = '';
      FilterDateConverted = '';
      FilterDateLastStatus = '';
    });
  }

  void CheckDate(int columnumber) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2001),
            lastDate: DateTime(5050))
        .then((date) {
      if (date != null) {
        setState(() {
          if (columnumber == 1) {
            _DateAddedStart = DateFormat("yyyy-MM-dd").format(date);
          } else if (columnumber == 2) {
            _DateAddedEnd = DateFormat("yyyy-MM-dd").format(date);
          } else if (columnumber == 3) {
            _DateAssignedStart = DateFormat("yyyy-MM-dd").format(date);
          } else if (columnumber == 4) {
            _DateAssignedEnd = DateFormat("yyyy-MM-dd").format(date);
          } else if (columnumber == 5) {
            _LastContactDateStart = DateFormat("yyyy-MM-dd").format(date);
          } else if (columnumber == 6) {
            _LastContactDateEnd = DateFormat("yyyy-MM-dd").format(date);
          } else if (columnumber == 7) {
            _DateConvertedStart = DateFormat("yyyy-MM-dd").format(date);
          } else if (columnumber == 8) {
            _DateConvertedEnd = DateFormat("yyyy-MM-dd").format(date);
          } else if (columnumber == 9) {
            _LastStatusChangedStart = DateFormat("yyyy-MM-dd").format(date);
          } else if (columnumber == 10) {
            _LastStatusChangedEnd = DateFormat("yyyy-MM-dd").format(date);
          }

          //2020-01-01 00:00:00
        });
      }
    });
  }
}
