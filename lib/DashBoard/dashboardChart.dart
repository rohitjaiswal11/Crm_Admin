// ignore_for_file: file_names, prefer_const_constructors, unused_local_variable, must_be_immutable, use_key_in_widget_constructors, avoid_print, unnecessary_null_comparison, prefer_if_null_operators
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Leads/lead_screen.dart';
import 'package:lbm_crm/util/colors.dart';

class DashBoardChart extends StatefulWidget {
  Map<String, double> dataMap = {};

  List<Color> colorList = [];
  var isdatafetched = false;
  int index;
  DashBoardChart(
      {required this.dataMap,
      required this.colorList,
      required this.isdatafetched,
      required this.index});
  @override
  _DashBoardChartState createState() => _DashBoardChartState();
}

class _DashBoardChartState extends State<DashBoardChart> {
  List<Color> colorListempty = [Colors.grey];
  Map<String, double> dataMapempty = {};

  @override
  Widget build(BuildContext context) {
    final names = widget.dataMap.keys.toList();
    log(widget.dataMap.toString());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: ColorCollection.containerC,
      child: names.isEmpty
          ? Center(
              child: Text('No Data'),
            )
          : ListView.builder(
              // reverse: true,
              padding: EdgeInsets.symmetric(vertical: height * 0.015,horizontal: 15),
              itemCount: names.length >= 10 ? items.length : names.length,
              itemBuilder: (context, i) {
                print(widget.colorList[i]);
                return InkWell(
                  onTap: () {
                    if (widget.index == 0) {
                      Navigator.pushNamed(context, LeadScreen.id,
                          arguments: names[i].toString());
                    }
                  },
                  child: chartDetails(
                    // yaxis: items[i].yaxis,
                    color: widget.colorList[i] == null
                        ? ColorCollection.backColor
                        : widget.colorList[i],
                    title: names[i] == null ? '' : names[i],
                    height: height,
                    width: width,
                    // xaxis: items[i].xaxis
                  ),
                );
              }),
    );
  }

  Widget chartDetails({
    // required double xaxis,
    // required double yaxis,
    required Color color,
    required String title,
   required double height,
    required double width,
  }) {
    return SizedBox(
      height: height*0.06,
      width: width*0.5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 5.0,
            ),
          ],
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Center(
          child: FittedBox(
            child: Text('$title ',
                softWrap: true,
                style: ColorCollection.titleStyleWhite
                    .copyWith(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final double xaxis;
  final double yaxis;
  final Color color;
  final String title;
  final String value;
  final double? height;
  final double? width;
  ChartData({
    required this.yaxis,
    required this.color,
    required this.title,
    required this.value,
    required this.xaxis,
    required this.height,
    required this.width,
  });
}

List<ChartData> items = [
  ChartData(
      xaxis: 0.0,
      yaxis: 0.6,
      height: 50,
      width: 50,
      value: '10',
      color: Colors.pink,
      title: 'Name'),
  ChartData(
      xaxis: 0.0,
      yaxis: 0.35,
      height: 50,
      width: 100,
      value: '10',
      color: Colors.blue,
      title: 'Name'),
  ChartData(
      xaxis: 0.0,
      yaxis: 0.20,
      height: 50,
      width: 150,
      value: '1',
      color: Colors.purple,
      title: 'Hot'),
  ChartData(
      xaxis: 0.0,
      yaxis: 0.05,
      height: 50,
      width: 200,
      value: '2',
      color: Colors.green,
      title: 'Follow Up'),
  ChartData(
      xaxis: 0.0,
      yaxis: -0.1,
      height: 50,
      width: 250,
      value: '0',
      color: Colors.orange,
      title: 'Lead Lost'),
  ChartData(
      xaxis: 0.0,
      yaxis: -0.25,
      height: 50,
      width: 300,
      value: '10',
      color: Colors.red,
      title: 'Proposal Sent'),
  ChartData(
      xaxis: 0.0,
      yaxis: -0.40,
      height: 50,
      width: 350,
      value: '10',
      color: Colors.black,
      title: 'Client'),
  ChartData(
      xaxis: 0.0,
      yaxis: -0.55,
      height: 50,
      width: 400,
      value: '4',
      color: Colors.lightBlueAccent,
      title: 'Contacted'),
  ChartData(
      xaxis: 0.0,
      yaxis: -0.70,
      height: 50,
      width: 450,
      value: '10',
      color: Colors.deepOrangeAccent,
      title: 'Calling'),
  ChartData(
      xaxis: 0.0,
      yaxis: -0.85,
      height: 50,
      width: 500,
      value: '60',
      color: Colors.grey,
      title: 'New Lead'),
];
