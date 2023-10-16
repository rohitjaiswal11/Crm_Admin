// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, non_constant_identifier_names, file_names, prefer_const_constructors, avoid_unnecessary_containers, import_of_legacy_library_into_null_safe, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';

import '../LBM_Plugin/lbmplugin.dart';
import 'package:shimmer/shimmer.dart';

class NoteViewDialogBox extends StatefulWidget {
  static const id = 'NoteViewDialog';
  //partucular lead id show the data
  String LeadID;
  NoteViewDialogBox({required this.LeadID});
  @override
  State<StatefulWidget> createState() {
    return _NoteViewDialogBox();
  }
}

class _NoteViewDialogBox extends State<NoteViewDialogBox> {
  List ListNoteView = [];
  var isDataFetched = false;
  @override
  void initState() {
    super.initState();
    print(widget.LeadID);
    showNoteData();
  }

  //api hot to get the note data on particular leadid
  void showNoteData() async {
    final paramDic = {
      "type": "notes",
      "lead_id": widget.LeadID,
      "typeby": "lead",
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetLeadReminderNotes, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        ListNoteView = data['data'] as List;

        isDataFetched = true;
      });
    } else {
      setState(() {
        print("no data");
        isDataFetched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCollection.backColor,
        title: Text(KeyValues.notes),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, top: 8.0, bottom: 8.0),
        child: _getBodyWidget(),
      ),
    );
  }

  //check the data fetch by server or not , that time display the shimmer list
  Widget _getBodyWidget() {
    return Container(
        child: isDataFetched == false
            ? ShimmerList()
            : ListNoteView.isNotEmpty
                ? ListView.builder(
                    itemCount: ListNoteView.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
//                            return buildList(context, index);
                      return NoteViewList(context, index);
                    })
                : Center(child: Container(child: Text('no data'))));
  }

//display the data in the widget
  Widget NoteViewList(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      ListNoteView[index]['addedfrom_name'].toString() == " "
                          ? '...'
                          : ListNoteView[index]['addedfrom_name'].toString(),
                      style: ColorCollection.titleStyle2),
                  SizedBox(width: 6.0),
                  Text(ListNoteView[index]['dateadded'].toString(),
                      style: ColorCollection.titleStyleGreen3),
                ],
              ),
              SizedBox(height: 4.0),
              Text(ListNoteView[index]['description'].toString(),
                  textAlign: TextAlign.justify,
                  style: ColorCollection.titleStyle
                      .copyWith(fontWeight: FontWeight.normal)),
              Divider(
                color: Colors.grey,
              )
            ],
          ),
        ),
      ],
    );
  }
}

//shimmer effect
class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 1000;

    return SafeArea(
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;

          print(time);

          return Shimmer.fromColors(
            highlightColor: Colors.white,
            baseColor: Colors.grey.shade300,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 10,
                            width: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 6.0),
                          Container(
                            height: 10,
                            width: 100,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        height: 10,
                        width: 300,
                        color: Colors.grey,
                      ),
                      Divider(
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ],
            ),
            period: Duration(milliseconds: time),
          );
        },
      ),
    );
  }
}
