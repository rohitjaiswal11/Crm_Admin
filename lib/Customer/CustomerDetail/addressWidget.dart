// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_if_null_operators, file_names

import 'package:flutter/material.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:marquee_widget/marquee_widget.dart';

class AddressWidget extends StatefulWidget {
  List CustomerData = [];
  AddressWidget({required this.CustomerData});
  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  final deco = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: Colors.grey.shade300, width: 1),
    color: Color(0xFFF8F8F8),
  );
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SelectionArea(
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.05),
          decoration: kContaierDeco.copyWith(color: ColorCollection.containerC),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Billing Address -',
                  style: ColorCollection.titleStyleGreen,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                detailContainer(
                    width,
                    height,
                    'Street',
                    (widget.CustomerData[0]['billing_street'] == null
                        ? ''
                        : widget.CustomerData[0]['billing_street'].toString()),
                    'City',
                    (widget.CustomerData[0]['billing_city'] == null
                        ? ''
                        : widget.CustomerData[0]['billing_city'].toString()),
                    Icons.location_on,
                    Icons.location_city),
                detailContainer(
                    width,
                    height,
                    'State',
                    (widget.CustomerData[0]['billing_state'] == null
                        ? ''
                        : widget.CustomerData[0]['billing_state'].toString()),
                    'Zip Code',
                    (widget.CustomerData[0]['billing_zip'] == null
                        ? ''
                        : widget.CustomerData[0]['billing_zip'].toString()),
                    Icons.edit_location,
                    Icons.my_location),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    decoration: deco,
                    height: height * 0.08,
                    // width: width * 0.42,
                    child: Row(
                      children: [
                        Icon(
                          Icons.language,
                          color: ColorCollection.backColor,
                          size: 30,
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width * 0.21,
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text('Country',
                                      style: ColorCollection.titleStyle)),
                            ),
                            SizedBox(height: height * 0.005),
                            SizedBox(
                              width: width * 0.6,
                              child: Marquee(
                                  child: Text(
                                (widget.CustomerData[0]['billing_country_name'] ==
                                        null
                                    ? ''
                                    : widget.CustomerData[0]
                                            ['billing_country_name']
                                        .toString()),
                                style: ColorCollection.subTitleStyle.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              )),
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(
                          Icons.done_all,
                          color: Colors.grey,
                        )
                      ],
                    )),
                SizedBox(
                  height: height * 0.04,
                ),
                Text(
                  'Shipping Address -',
                  style: ColorCollection.titleStyleGreen,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                detailContainer(
                    width,
                    height,
                    'Street',
                    (widget.CustomerData[0]['shipping_street'] == null
                        ? ''
                        : widget.CustomerData[0]['shipping_street'].toString()),
                    'City',
                    (widget.CustomerData[0]['shipping_city'] == null
                        ? ''
                        : widget.CustomerData[0]['shipping_city'].toString()),
                    Icons.location_on,
                    Icons.location_city),
                detailContainer(
                    width,
                    height,
                    'State',
                    (widget.CustomerData[0]['shipping_state'] == null
                        ? ''
                        : widget.CustomerData[0]['shipping_state'].toString()),
                    'Zip Code',
                    (widget.CustomerData[0]['shipping_zip'] == null
                        ? ''
                        : widget.CustomerData[0]['shipping_zip'].toString()),
                    Icons.edit_location,
                    Icons.my_location),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    decoration: deco,
                    height: height * 0.08,
                    // width: width * 0.42,
                    child: Row(
                      children: [
                        Icon(
                          Icons.language,
                          color: ColorCollection.backColor,
                          size: 30,
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width * 0.21,
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text('Country',
                                      style: ColorCollection.titleStyle)),
                            ),
                            SizedBox(height: height * 0.005),
                            SizedBox(
                              width: width * 0.6,
                              child: Marquee(
                                  child: Text(
                                (widget.CustomerData[0]
                                            ['shipping_country_name'] ==
                                        null
                                    ? ''
                                    : widget.CustomerData[0]
                                            ['shipping_country_name']
                                        .toString()),
                                style: ColorCollection.subTitleStyle.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              )),
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(
                          Icons.done_all,
                          color: Colors.grey,
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailContainer(
      double width,
      double height,
      String title,
      String value,
      String title2,
      String value2,
      IconData? icon1,
      IconData? icon2) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              decoration: deco,
              height: height * 0.08,
              // width: width * 0.42,
              child: Row(
                children: [
                  Icon(
                    icon1,
                    color: ColorCollection.backColor,
                    size: 30,
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.21,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child:
                                Text(title, style: ColorCollection.titleStyle)),
                      ),
                      SizedBox(height: height * 0.005),
                      SizedBox(
                          width: width * 0.6,
                          child: Marquee(
                            child: Text(
                              value,
                              style: ColorCollection.subTitleStyle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.done_all,
                    color: Colors.grey,
                  )
                ],
              )),
          SizedBox(
            height: height * 0.02,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            decoration: deco,
            height: height * 0.08,
            // width: width * 0.42,
            child: Row(
              children: [
                Icon(
                  icon2,
                  color: ColorCollection.backColor,
                  size: 30,
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: width * 0.21,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child:
                              Text(title2, style: ColorCollection.titleStyle),
                        )),
                    SizedBox(height: height * 0.005),
                    SizedBox(
                      width: width * 0.6,
                      child: Marquee(
                        child: Text(
                          value2,
                          overflow: TextOverflow.ellipsis,
                          style: ColorCollection.subTitleStyle.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.done_all,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
