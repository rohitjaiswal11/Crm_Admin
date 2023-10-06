// ignore_for_file: file_names, prefer_const_constructors, prefer_adjacent_string_concatenation, prefer_if_null_operators, use_key_in_widget_constructors, must_be_immutable, avoid_print
import 'package:flutter/material.dart';
import 'package:lbm_crm/util/colors.dart';

class DiscussionScreen extends StatefulWidget {
  static const id = 'DiscussionView';
//Fetch the discussion comment on Discussion View
  List data = [];
  DiscussionScreen({required this.data});

  @override
  State<StatefulWidget> createState() {
    return _DiscussionScreen();
  }
}

class _DiscussionScreen extends State<DiscussionScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print("data" + " " + widget.data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Discussion",
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300)),
        ),
        //Show the data in list view
        body: Padding(
          padding: EdgeInsets.only(top: 20),
          child: ListView.builder(
              itemCount: widget.data.length,
              itemBuilder: (BuildContext context, int index) {
                return listViewData(context, index);
              }),
        ));
  }

  Widget listViewData(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              widget.data[index]['content'] == null
                  ? ''
                  : widget.data[index]['content'],
              style: ColorCollection.titleStyleGreen2),
          SizedBox(
            height: 5,
          ),
          Text(
            widget.data[index]['file_name'] == null
                ? 'Not Specified'
                : widget.data[index]['file_name'],
            style: ColorCollection.subTitleStyle,
          ),
          Text(
            widget.data[index]['file_mime_type'] == null
                ? ''
                : widget.data[index]['file_mime_type'],
            style: ColorCollection.subTitleStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Discussion Type: ', style: ColorCollection.subTitleStyle),
              Text(
                widget.data[index]['discussion_type'] == null
                    ? ''
                    : widget.data[index]['discussion_type']
                        .toString()
                        .toUpperCase(),
                style: ColorCollection.subTitleStyle2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Date: ',
                style: ColorCollection.subTitleStyle,
              ),
              Text(
                widget.data[index]['created'] == null
                    ? ''
                    : widget.data[index]['created'],
                style: ColorCollection.subTitleStyle2,
              ),
            ],
          ),
          Divider(color: ColorCollection.backColor)
        ],
      ),
    );
  }
}
