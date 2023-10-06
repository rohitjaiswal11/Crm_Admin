// ignore_for_file: prefer_final_fields, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field, avoid_print, prefer_typing_uninitialized_variables

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lbm_crm/SettingsScreen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:lbm_crm/profileScreen.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/SeeAll/see_all_screen.dart';
import 'package:lbm_crm/util/colors.dart';

import '../main.dart';
import '../util/commonClass.dart';

class BottomBar extends StatefulWidget {
  static const id = 'bottombar';
  const BottomBar({Key? key}) : super(key: key);

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Future<void> notificationCheck() async {
  //   if (CommanClass.notifcationTapped) {
  //     final message = CommanClass.noticationMessage!;
  //     List dataList = [];
  //     dataList.add(message.data['data']);
  //     if (message.data['root'].toString().toLowerCase() == 'supportdetail') {
  //       Navigator.pushNamed(
  //           CommanClass.navState.currentContext!, SupportDetailScreen.id,
  //           arguments: dataList);
  //     } else if (message.data['root'].toString().toLowerCase() ==
  //         'projectdetail') {
  //       Navigator.pushNamed(
  //           CommanClass.navState.currentContext!, ProjectDetailScreen.id,
  //           arguments: dataList);
  //     } else if (message.data['root'].toString().toLowerCase() ==
  //         'customerdetail') {
  //       Navigator.pushNamed(
  //           CommanClass.navState.currentContext!, CustomerDetailScreen.id,
  //           arguments: dataList);
  //     } else if (message.data['root'].toString().toLowerCase() ==
  //         'invoicedetail') {
  //       Navigator.pushNamed(
  //           CommanClass.navState.currentContext!, InvoiceDetailScreen.id,
  //           arguments: PageArgument(Staff_id: '', Title: ''));
  //     } else if (message.data['root'].toString().toLowerCase() ==
  //         'taskdetail') {
  //       Navigator.pushNamed(
  //           CommanClass.navState.currentContext!, TaskDetailScreen.id,
  //           arguments: dataList);
  //     } else if (message.data['root'].toString().toLowerCase() ==
  //         'leaddetail') {
  //       Navigator.pushNamed(
  //           CommanClass.navState.currentContext!, LeadDetailScreen.id,
  //           arguments: dataList);
  //     } else if (message.data['root'].toString().toLowerCase() ==
  //         'paymentdetail') {
  //       Navigator.pushNamed(
  //           CommanClass.navState.currentContext!, PaymentDetailScreen.id,
  //           arguments: PaymentArgument());
  //     } else {
  //       Navigator.push(
  //         CommanClass.navState.currentContext!,
  //         MaterialPageRoute(
  //           builder: (context) => TestScreen(),
  //         ),
  //       );
  //     }
  //   }
  //   ;
  // }
  checkNotification() async {
    if (CommanClass.notifcationTapped) {
      PushNotification notification = PushNotification(
        title: CommanClass.noticationMessage?.notification?.title,
        body: CommanClass.noticationMessage?.notification?.body,
        dataTitle: CommanClass.noticationMessage?.data['title'],
        dataBody: CommanClass.noticationMessage?.data['body'],
      );

      final _notificationInfo = notification;
      ;
      showOverlayNotification(
        (context) {
          return Material(
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10),
            //     side: BorderSide(color: Colors.white, width: 0.3)),
            // elevation: 1,
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ListTile(
                selected: true,
                selectedTileColor: ColorCollection.white,
                selectedColor: ColorCollection.backColor,
                title: SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Text(
                      _notificationInfo.title ?? 'CRM',
                      style: TextStyle(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    )),
                subtitle: SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Text(
                      _notificationInfo.body ?? '',
                      style: TextStyle(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    )),
                leading: Image.asset(
                  'assets/appLogo.png',
                  height: 50,
                  width: 50,
                ),
                trailing: IconButton(
                    onPressed: () {
                      OverlaySupportEntry.of(context)?.dismiss();
                    },
                    icon: Icon(Icons.close)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                        color: ColorCollection.backColor, width: 0.3)),
              ),
            ),
          );
        },
        // Text(_notificationInfo!.title ?? 'CRM'),
        // leading: NotificationBadge(totalNotifications: _totalNotifications),
        // Text(_notificationInfo!.body ?? '-'),
        context: CommanClass.navState.currentContext,
        position: NotificationPosition.top,
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  void initState() {
WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
  await 
    checkNotification();

 });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Page=====>" + _page.toString());

    final height = MediaQuery.of(context).size.height;
    print(height * 0.07 > 75 ? 75 : height * 0.07);
    return Consumer<ColorCollection>(
        builder: (context, theme, child) => Scaffold(
              extendBody: true,
              // backgroundColor: Colors.transparent,
              body: WillPopScope(
                onWillPop: () async {
                  return true;
                },
                child: Container(
                    color: Colors.transparent,
                    margin: _page == 1
                        ? EdgeInsets.only(bottom: height * 0.07)
                        : null,
                    child: pagesList[_page]),
              ),
              bottomNavigationBar: CurvedNavigationBar(
                height: height * 0.07 > 75 ? 75 : height * 0.07,
                key: _bottomNavigationKey,
                index: 0,
                items: <Widget>[
                  Icon(
                    Icons.home,
                    size: 35,
                    color: ColorCollection.iconColor,
                  ),
                  Icon(
                    Icons.list,
                    size: 35,
                    color: ColorCollection.iconColor,
                  ),
                  Icon(
                    Icons.person_outline,
                    size: 35,
                    color: ColorCollection.iconColor,
                  ),
                  Icon(
                    Icons.settings,
                    size: 35,
                    color: ColorCollection.iconColor,
                  ),
                ],
                color: ColorCollection.navBarColor,
                buttonBackgroundColor: ColorCollection.iconBack,
                backgroundColor: Colors.transparent,
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds: 600),
                onTap: (index) {
                  setState(() {
                    _page = index;
                  });
                },
                letIndexChange: (index) => true,
              ),
            ));
  }
}

List<Widget> pagesList = [
  DashBoardScreen(),
  SeeAllScreen(),
  ProfileScreen(),
  SettingsScreen(),
];
