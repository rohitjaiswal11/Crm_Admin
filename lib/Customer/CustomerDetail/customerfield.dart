// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, prefer_const_constructors, prefer_if_null_operators, unnecessary_null_comparison

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/util/colors.dart';

class FieldScreen extends StatefulWidget {
  List CustomField = [];
  FieldScreen({required this.CustomField});
  @override
  createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.CustomField.toString());
    return SingleChildScrollView(
      child: UserInfoField(
        profileDetail: widget.CustomField,
      ),
    );
  }
}

class UserInfoField extends StatelessWidget {
  List profileDetail = [];

  UserInfoField({required this.profileDetail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SelectionArea(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(5),
            child: profileDetail.isEmpty
                ? Center(
                    child: Text('No Data'),
                  )
                : Column(
                    children: <Widget>[
                      for (int i = 0; i < profileDetail.length; i++)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.my_location,
                                      size: 15,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                        profileDetail[i]['name'] == null
                                            ? ''
                                            : profileDetail[i]['name'],
                                        style: ColorCollection.titleStyle),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Text(
                                  profileDetail[i]['value'] == null
                                      ? ''
                                      : profileDetail[i]['value'],
                                  style: ColorCollection.titleStyle
                                      .copyWith(fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                            Divider(
                              color: ColorCollection.backColor,
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
