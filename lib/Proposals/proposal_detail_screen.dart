// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/constants.dart';

class ProposalDetailScreen extends StatefulWidget {
  static const id = '/ProposalDetail';

  @override
  State<ProposalDetailScreen> createState() => _ProposalDetailScrenState();
}

class _ProposalDetailScrenState extends State<ProposalDetailScreen> {
  //Date picker
  final DateFormat formatter = DateFormat('MM/dd/yyyy');
  int calendarNum = 0;
  String _startDate = '';
  String _endDate = '';
  DateTime currentDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        _pickedDate(pickedDate);
      });
    }
  }

  _pickedDate(DateTime currentDate) {
    setState(() {
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

      if (calendarNum == 1) {
        _startDate = formattedDate;
      } else {
        _endDate = formattedDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorCollection.grey,
      body: SingleChildScrollView(
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
                      height: height * 0.07,
                      width: width * 0.13,
                      child: Image.asset(
                        'assets/third.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Text(KeyValues.proposals,
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
                                fit: BoxFit.fill, errorBuilder: (_, __, ___) {
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
              height: height * 0.02,
            ),
            Container(
              width: width,
              margin: EdgeInsets.symmetric(horizontal: width * 0.03),
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.02),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black38, width: 0.1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#Pro-000001 Android Application',
                    style: ColorCollection.titleStyle,
                  ),
                  SizedBox(height: height * 0.04),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: height * 0.015),
                    color: ColorCollection.backColor,
                    child: Center(
                      child: Text(
                        KeyValues.expired,
                        style: ColorCollection.titleStyleWhite,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    decoration: kDropdownContainerDeco.copyWith(
                      color: ColorCollection.white,
                    ),
                    padding: EdgeInsets.symmetric(vertical: height * 0.015),
                    child: Center(
                      child: Text(
                        KeyValues.download,
                        style: ColorCollection.titleStyle
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.06,
              ),
              width: width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.05),
                  Text(
                    '# ${KeyValues.items}',
                    style: ColorCollection.titleStyle,
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    height: height * 0.25,
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: 3,
                        itemBuilder: (c, i) =>
                            itemsContainer(width, height, i + 1)),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.025, vertical: height * 0.015),
                    decoration: kDropdownContainerDeco,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${KeyValues.subTotal} :',
                              style: ColorCollection.titleStyle,
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Text(
                              '${KeyValues.total} :',
                              style: ColorCollection.titleStyle,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$40,0000.00',
                              style: ColorCollection.subTitleStyle2,
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Text(
                              '\$40,0000.00',
                              style: ColorCollection.subTitleStyle2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02, vertical: height * 0.015),
                    decoration: kDropdownContainerDeco,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/letter.png',
                                  fit: BoxFit.fill,
                                  height: height * 0.03,
                                  width: width * 0.05,
                                ),
                                SizedBox(width: width * 0.02),
                                Text(
                                  KeyValues.summary,
                                  style: ColorCollection.titleStyleGreen2,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/messages.png',
                                  fit: BoxFit.fill,
                                  height: height * 0.03,
                                  width: width * 0.05,
                                ),
                                SizedBox(width: width * 0.02),
                                Text(
                                  KeyValues.discussion,
                                  style: ColorCollection.titleStyle2,
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Text(
                          KeyValues.personalInfo,
                          style: ColorCollection.titleStyle2,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          'In LLP',
                          style: ColorCollection.titleStyle,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          '689-1917 Donc Street',
                          style: ColorCollection.subTitleStyle,
                        ),
                        Text(
                          'Buner Khyber',
                          style: ColorCollection.subTitleStyle,
                        ),
                        Text(
                          'PakhtoonKhwa 07586',
                          style: ColorCollection.subTitleStyle,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          '165004136551',
                          style: ColorCollection.subTitleStyle
                              .copyWith(color: ColorCollection.lightgreen),
                        ),
                        Text(
                          'Volupat.Nulla@Mattis.Edu',
                          style: ColorCollection.subTitleStyle
                              .copyWith(color: ColorCollection.lightgreen),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          children: [
                            Text(
                              '${KeyValues.total}:',
                              style: ColorCollection.titleStyle2,
                            ),
                            SizedBox(width: width * 0.1),
                            Text(
                              '\$40,000.00',
                              style: ColorCollection.titleStyle2,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        Text(
                          KeyValues.status,
                          style: ColorCollection.titleStyle2,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                          ),
                          decoration: kDropdownContainerDeco,
                          child: TextFormField(
                            autofocus: false,
                            style: kTextformStyle,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Select Status',
                                hintStyle: kTextformHintStyle,
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(height: height * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                calendarNum = 1;
                                _selectDate(context);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.grey.shade400,
                                        size: 25,
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Text('*${KeyValues.date}',
                                          style: ColorCollection.titleStyle),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.01),
                                    height: height * 0.04,
                                    width: width * 0.4,
                                    decoration: kDropdownContainerDeco,
                                    child: Center(
                                      child: Text(
                                          _startDate == '' ? '' : _startDate,
                                          style: ColorCollection.subTitleStyle),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                calendarNum = 2;
                                _selectDate(context);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.grey.shade400,
                                        size: 25,
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Text('*${KeyValues.openTill}',
                                          style: ColorCollection.titleStyle),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.01),
                                    height: height * 0.04,
                                    width: width * 0.4,
                                    decoration: kDropdownContainerDeco,
                                    child: Center(
                                      child: Text(
                                          _endDate == '' ? '' : _endDate,
                                          style: ColorCollection.subTitleStyle),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemsContainer(double width, double height, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.01, top: height * 0.005),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.015, vertical: height * 0.01),
      decoration: kDropdownContainerDeco,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$index.',
            style: ColorCollection.titleStyle2,
          ),
          SizedBox(
            width: width * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Business Plan Development',
                  style: ColorCollection.titleStyle2),
              SizedBox(height: height * 0.005),
              Text('Business Plan Development For MLM',
                  style: ColorCollection.subTitleStyle),
            ],
          )
        ],
      ),
    );
  }
}
