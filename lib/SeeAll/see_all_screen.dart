// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unused_local_variable

import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:lbm_crm/Annoucement/announcement_screen.dart';
import 'package:lbm_crm/Contract/contracts_screen.dart';
import 'package:lbm_crm/Customer/customers_screen.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Estimates/estimates_screen.dart';
import 'package:lbm_crm/Expenses/expenses_screen.dart';
import 'package:lbm_crm/Invoice/invoices_screen.dart';
import 'package:lbm_crm/Leads/lead_screen.dart';
import 'package:lbm_crm/Payments/payments_screen.dart';
import 'package:lbm_crm/Projects/projects_screen.dart';
import 'package:lbm_crm/Proposals/proposals_screen.dart';
import 'package:lbm_crm/Support/support_screen.dart';
import 'package:lbm_crm/Tasks/tasks_screen.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:provider/provider.dart';

import '../Chat/chat_screen.dart';
import '../Location/locationService.dart';
import '../util/storage_manger.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({Key? key}) : super(key: key);
  static const id = '/seeall';

  @override
  _SeeAllScreenState createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  List<Choice> choices = <Choice>[
    Choice(
        title: 'Customers',
        imageData: 'assets/robo.png',
        routeName: CustomerScreen.id),
    Choice(
        title: 'Tasks',
        imageData: 'assets/newtask.png',
        routeName: TasksScreen.id),
    Choice(
        title: 'SUPPORT',
        imageData: 'assets/newticket.png',
        routeName: SupportScreen.id),
    Choice(
        title: 'Invoices',
        imageData: 'assets/second.png',
        routeName: InvoiceScreen.id),
    Choice(
        title: 'Leads',
        imageData: 'assets/first.png',
        routeName: LeadScreen.id),

    Choice(
        title: 'Announcements',
        imageData: 'assets/announcements.png',
        routeName: AnnouncementScreen.id),

    // Choice(
    // title: 'Appointment',
    // imageData: 'assets/appointment.png',
    // routeName: AppointmentScreen.id),
    Choice(
        title: 'Chat', imageData: 'assets/chat.png', routeName: ChatScreen.id),
    Choice(
        title: 'Location', imageData: 'assets/location.png', hasWidget: true),
    Choice(
        title: 'Contracts',
        imageData: 'assets/contracts.png',
        routeName: ContractsScreen.id),
    // Choice(
    //     title: 'Dashboard',
    //     imageData: 'assets/dashboard.png',
    //     routeName: BottomBar.id),
    Choice(
        title: 'PAYMENT',
        imageData: 'assets/payment.png',
        routeName: PaymentScreen.id),

    Choice(
        title: 'Projects',
        imageData: 'assets/projects.png',
        routeName: ProjectsScreen.id),
    Choice(
        title: 'Estimates',
        imageData: 'assets/estimate.png',
        routeName: EstimatesScreen.id),

    Choice(
        title: 'EXPENSES',
        imageData: 'assets/newexpense.png',
        routeName: ExpensesScreen.id),
    Choice(
      title: 'Proposal',
      imageData: 'assets/third.png',
      routeName: ProposalScreen.id,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final itemHeight = height * 0.05;
    final itemWidth = width * 0.1;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height * 0.23,
            width: width,
            decoration: BoxDecoration(
              color: ColorCollection.backColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: width * 0.02,
              top: height * 0.05,
              right: width * 0.02,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(CommanClass.HeaderLogo!,
                    // color: Colors.white,
                    height: 100,
                    width: 200,
                    errorBuilder: (context, error, stackTrace) => Row(
                          children: [
                            SizedBox(
                              width: width * 0.03,
                            ),
                            FittedBox(
                              child: Text('SECOMUSA',
                                  style: ColorCollection.screenTitleStyle
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            // FittedBox(
                            //   child: Text('LLC',
                            //       style: ColorCollection.screenTitleStyle
                            //           .copyWith(
                            //               fontWeight: FontWeight.normal)),
                            // ),
                          ],
                        )),
                Spacer(),
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
              ],
            ),
          ),
          Container(
              //height: height * 0.7,
              margin: EdgeInsets.only(
                left: width * 0.02,
                top: height * 0.174,
                right: width * 0.02,
              ),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                //physics: NeverScrollableScrollPhysics(),
                itemCount: choices.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: (itemWidth / itemHeight),
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ListItem(choice: choices[index]);
                },
              ))
        ],
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  final Choice choice;

  ListItem({required this.choice});

  @override
  State<ListItem> createState() => _ListItemState();
}

  bool isLocationOn = false;
class LocationSwitchState extends ChangeNotifier {
  bool _isLocationOn = false;

  bool get isLocationOn => _isLocationOn;

  void toggleLocation(bool newValue) {
    _isLocationOn = newValue;
    notifyListeners();
  }
}

class _ListItemState extends State<ListItem> {


  checkLocation() async {
    isLocationOn =
        await SharedPreferenceClass.GetSharedData('isLocationOn') ?? false;
    setState(() {});
  }

  @override
  void initState() {
    checkLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context) {
        Provider.of<KeyValues>(context, listen: true).changeTodefault();
        Provider.of<KeyValues>(context, listen: true).changeLang();
      },
      child: Card(
        color: darken(ColorCollection.containerC, 0.05),
        elevation: 4,
        shadowColor: Colors.grey.shade300,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: GestureDetector(
          onTap: () {
            if (widget.choice.routeName != null) {
              Navigator.pushNamed(context, widget.choice.routeName!);
            }
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(4),
            //height: height * 0.7,
            decoration: BoxDecoration(
              color: ColorCollection.containerC.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: height * 0.05,
                    child: Image.asset(widget.choice.imageData)),
                SizedBox(
                  height: 3,
                ),
                FittedBox(
                    child: Text(widget.choice.title.tr().toUpperCase(),
                        style: ColorCollection.titleStyle)),
                if (widget.choice.hasWidget == true)
                    Switch(
              value: isLocationOn,
              onChanged: (val) async {
                final service = FlutterBackgroundService();
                var isRunning = await service.isRunning();

                if (val) {
                  final isEnable = await LocationClass().handleLocationPermission();
                  if (isEnable) {
                    if (!isRunning) {print("check serrrrrvice"+isRunning.toString());
                      service.startService();
                    } // else: Service is already running
                  } // else: Location permission not granted
                } else { print("22222check serrrrrvice"+isRunning.toString());
                  if (isRunning) {
                    service.invoke("stopService");
                  } // else: Service is not running
                }

                SharedPreferenceClass.SetSharedData('isLocationOn', val);

                setState(() {
                  isLocationOn = val;
                });
              },
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Choice {
  const Choice(
      {required this.title,
      required this.imageData,
      this.routeName,
      this.hasWidget});
  final String title;
  final String imageData;
  final String? routeName;
  final bool? hasWidget;
}
