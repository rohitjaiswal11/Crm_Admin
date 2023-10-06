// ignore_for_file: prefer_const_constructors, file_names, avoid_print, unused_field, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Support/support_detail_screen.dart';
import 'package:lbm_crm/loginSignup/login_screen.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/storage_manger.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String staff_firstname = '',
      staff_lastname = '',
      staff_email = '',
      staff_ID = '',
      phone_Number = '',
      profile_image = '';

  void _findStaffDetail() async {
    //Get Staff Detail by login data
    staff_ID = await SharedPreferenceClass.GetSharedData("staff_id");
    staff_email = await SharedPreferenceClass.GetSharedData("email");
    staff_firstname = await SharedPreferenceClass.GetSharedData("firstname");
    staff_lastname = await SharedPreferenceClass.GetSharedData("lastname");
    profile_image = await SharedPreferenceClass.GetSharedData("profile_image");
    phone_Number = await SharedPreferenceClass.GetSharedData("phonenumber");

    setState(() {
      new_staff_ID = staff_ID;
      CommanClass.StaffId = staff_ID;
      print('$new_staff_ID,${CommanClass.StaffId}');
      new_staff_firstname = staff_firstname;
      new_staff_lastname = staff_lastname;
      new_staff_email = staff_email;

      // port.listen(
      //       (dynamic data) async {
      //     await updateUI(data);
      //   },
      // );
      // initPlatformState();
    });
  }

  @override
  void initState() {
    _findStaffDetail();
    super.initState();
  }

  @override
  void dispose() {
    CommanClass.FileURL = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.25,
              decoration: BoxDecoration(
                color: ColorCollection.backColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    width: width * 0.17,
                    height: width * 0.17,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: profile_image == ''
                          ? Text(
                              staff_firstname == '' ? '' : staff_firstname[0])
                          // : Image.asset(
                          //     'assets/profileimage.png',
                          //     fit: BoxFit.fill,
                          //   )
                          : InkWell(
                              onTap: () async {
                                CommanClass.FileURL = 'http://' +
                                    Base_Url_For_App +
                                    '/crm/uploads/staff_profile_images/' +
                                    staff_ID +
                                    '/thumb_' +
                                    profile_image;

                                showGeneralDialog(
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    transitionBuilder:
                                        (context, a1, a2, widget) {
                                      return Transform.scale(
                                        scale: a1.value,
                                        child: Opacity(
                                          opacity: a1.value,
                                          child: PreviewDialogBox(),
                                        ),
                                      );
                                    },
                                    transitionDuration:
                                        Duration(milliseconds: 100),
                                    barrierDismissible: false,
                                    barrierLabel: '',
                                    context: context,
                                    pageBuilder:
                                        (context, animation1, animation2) {
                                      return SizedBox();
                                    });
                              },
                              child: Image.network(
                                'http://' +
                                    Base_Url_For_App +
                                    '/crm/uploads/staff_profile_images/' +
                                    staff_ID +
                                    '/thumb_' +
                                    profile_image,
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
                  ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff_firstname + ' ' + staff_lastname,
                        style: ColorCollection.buttonTextStyle,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        staff_email,
                        style: ColorCollection.titleStyleWhite
                            .copyWith(fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  Tooltip(
                    message: 'LogOut',
                    child: GestureDetector(
                      onTap: () async {
                        final cleared =
                            await SharedPreferenceClass.clearAllData();
                        if (cleared) {
                          Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.id);
                        }
                      },
                      child: Icon(
                        Icons.logout,
                        color: ColorCollection.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06, vertical: height * 0.03),
              height: height * 0.68,
              width: width,
              decoration:
                  kContaierDeco.copyWith(color: ColorCollection.containerC),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Information',
                    style: ColorCollection.titleStyleGreen,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Text('First Name'),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    height: height * 0.06,
                    width: width,
                    decoration: kDropdownContainerDeco,
                    child: TextFormField(
                      enabled: false,
                      style: kTextformStyle.copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: width * 0.02, right: width * 0.02),
                        hintText: staff_firstname,
                        hintStyle: kTextformStyle.copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Text('Last Name'),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    height: height * 0.06,
                    width: width,
                    decoration: kDropdownContainerDeco,
                    child: TextFormField(
                      enabled: false,
                      style: kTextformStyle.copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: width * 0.02, right: width * 0.02),
                        hintText: staff_lastname,
                        hintStyle: kTextformStyle.copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Text('Email'),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    height: height * 0.06,
                    width: width,
                    decoration: kDropdownContainerDeco,
                    child: TextFormField(
                      enabled: false,
                      style: kTextformStyle.copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: width * 0.02, right: width * 0.02),
                        hintText: staff_email,
                        hintStyle: kTextformStyle.copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Text('Phone Number'),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    height: height * 0.06,
                    width: width,
                    decoration: kDropdownContainerDeco,
                    child: TextFormField(
                      enabled: false,
                      style: kTextformStyle.copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: width * 0.02, right: width * 0.02),
                        hintText: phone_Number,
                        hintStyle: kTextformStyle.copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: height * 0.1,
              color: ColorCollection.containerC,
            )
          ],
        ),
      ),
    );
  }

  Widget profileontainer({
    required double width,
    required double height,
    required String number,
    required String title,
  }) {
    return Container(
        width: width * 0.4,
        height: height * 0.06,
        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(blurRadius: 7, color: Colors.grey),
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            )
          ],
        ));
  }
}
