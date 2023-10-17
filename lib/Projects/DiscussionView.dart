// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, prefer_if_null_operators, import_of_legacy_library_into_null_safe, must_be_immutable, use_key_in_widget_constructors, avoid_print
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Projects/DiscussionScreen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/colors.dart';

import '../Plugin/lbmplugin.dart';

class DiscussionView extends StatefulWidget {
  String projectId;
  DiscussionView({required this.projectId});

  @override
  State<StatefulWidget> createState() {
    return _DiscussionView();
  }
}

class _DiscussionView extends State<DiscussionView> {
  List discussionList = [];
  bool isDataFetched = true;
  List PassDiscussion = [];
  @override
  void initState() {
    super.initState();
    getDiscussionList();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: isDataFetched == true
            ? Center(child: CircularProgressIndicator())
            : discussionList.isNotEmpty
                ? ListView.builder(
                    itemCount: discussionList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
//                            return buildList(context, index);
                      return discussionDetailsContainer(height, width, index);
                    })
                : Center(child: Text('No data')));
  }

  Widget discussionDetailsContainer(double height, double width, int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          margin: EdgeInsets.only(bottom: height * 0.01),
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.01),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(6)),
          child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  discussionList[index]['subject'] == null
                      ? ''
                      : discussionList[index]['subject'],
                  style: ColorCollection.titleStyle2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Last Activity: ',
                            style: ColorCollection.subTitleStyle),
                        Text(
                            discussionList[index]['last_activity'] == null
                                ? ' '
                                : discussionList[index]['last_activity'],
                            style: ColorCollection.subTitleStyle2)
                      ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Total Comments: ',
                        style: ColorCollection.titleStyleGreen3),
                    Text(discussionList[index]['discussion'].length.toString(),
                        style: ColorCollection.titleStyleGreen2),
                  ],
                ),
              ],
            ),
            onTap: () {
              PassDiscussion.clear();
              PassDiscussion.add(discussionList[index]['discussion'][0]);
              print(PassDiscussion);
              discussionList[index]['discussion'].length > 0
                  ? Navigator.of(context)
                      .pushNamed(DiscussionScreen.id, arguments: PassDiscussion)
                  : '';
            },
          )),
    );
  }

  //api hit to fetch the discussion data
  Future<void> getDiscussionList() async {
    final paramDic = {
      'customer_id': widget.projectId,
      'detailtype': 'discussion'
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDetail, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    discussionList.clear();
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          isDataFetched = false;
          discussionList = data['data'];
          print(discussionList);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isDataFetched = false;
          discussionList.clear();
        });
      }
    }
  }
}
