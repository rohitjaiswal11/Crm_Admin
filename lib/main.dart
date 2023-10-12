// ignore_for_file:  prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, avoid_print, non_constant_identifier_names

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lbm_crm/Location/locationService.dart';
import 'package:lbm_crm/splashScreen.dart';
import 'package:lbm_crm/util/Notifiation_service.dart';
import 'package:lbm_crm/util/RouteGenerator.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/storage_manger.dart';
import 'package:lbm_crm/widgets/bottom_navigationbar.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'Chat/chat_screen.dart';
import 'util/constants.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   log("Handling a background message: ${message.messageId}/n ${message.toMap().toString()}");
//   PushNotification notification = PushNotification(
//     title: message.notification?.title,
//     body: message.notification?.body,
//     dataTitle: message.data['title'],
//     dataBody: message.data['body'],
//   );
//   final _notificationInfo = notification;
//   showOverlayNotification(
//     (context) {
//       return Material(
//         // shape: RoundedRectangleBorder(
//         //     borderRadius: BorderRadius.circular(10),
//         //     side: BorderSide(color: Colors.white, width: 0.3)),

//         // elevation: 1,
//         color: Colors.transparent,
//         child: Padding(
//           padding: EdgeInsets.all(10),
//           child: ListTile(
//             selected: true,
//             selectedTileColor: ColorCollection.white,
//             selectedColor: ColorCollection.backColor,
//             title: SizedBox(
//                 width: MediaQuery.of(context).size.width - 50,
//                 child: Text(
//                   _notificationInfo.title ?? 'CRM',
//                   style: TextStyle(fontWeight: FontWeight.w700),
//                   overflow: TextOverflow.ellipsis,
//                 )),
//             subtitle: SizedBox(
//                 width: MediaQuery.of(context).size.width - 50,
//                 child: Text(
//                   _notificationInfo.body ?? '',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                   overflow: TextOverflow.ellipsis,
//                 )),
//             leading: Image.asset(
//               'assets/appLogo.png',
//               height: 50,
//               width: 50,
//             ),
//             trailing: IconButton(
//                 onPressed: () {
//                   OverlaySupportEntry.of(context)?.dismiss();
//                 },
//                 icon: Icon(Icons.close)),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 side: BorderSide(color: ColorCollection.backColor, width: 0.3)),
//           ),
//         ),
//       );
//     },
//     // Text(_notificationInfo!.title ?? 'CRM'),
//     // leading: NotificationBadge(totalNotifications: _totalNotifications),
//     // Text(_notificationInfo!.body ?? '-'),
//     context: CommanClass.navState.currentContext,
//     position: NotificationPosition.top,
//     duration: Duration(seconds: 3),
//   );
// }

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: false,
        isForegroundMode: true,
        autoStartOnBoot: true),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(minutes: 5), (timer) async {
    if ((await SharedPreferenceClass.GetSharedData('isLocationOn') ?? false) ==
        false) {
      service.stopSelf();
      return;
    } else if ((await Geolocator.checkPermission()) !=
        LocationPermission.always) {
      await SharedPreferenceClass.SetSharedData('isLocationOn', false);
      service.stopSelf();
      return;
    }

    await LocationClass().getCurrentPosition();

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "SECOM USA",
          content: "User Tracking",
        );
      }
    }

    // service.invoke(
    //   'update',
    //   {
    //     "latitude": position?.latitude.toString(),
    //     "longitude": position?.longitude.toString(),
    //   },
    // );
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  //await initializeService();

  await Firebase.initializeApp();

  await FirebaseMessaging.instance.requestPermission();
  
  await Notification_Helper.initialize(flutterLocalPlugin);
  HttpOverrides.global = MyHttpOverrides();

  runApp(EasyLocalization(
    supportedLocales: [
      Locale('en', 'US'),
      Locale('de', 'DE'),
      Locale('es', 'ES')
    ],
    path: 'assets/langs',
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;
  SpeechToText _speechToText = SpeechToText();

  /// This has to happen only once per app
  void _initSpeech() async {
    CommanClass.speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void registerNotification() async {
    _messaging = FirebaseMessaging.instance;

   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       log('User granted permission');
//       SharedPreferenceClass.SetSharedData("TokenKey",
//           "AAAAMue_ylA:APA91bHIASApWJVz-VTt2PJ0wVGo4lik1x9OtO290ECgYgFemSBFM6R5uRDdLHO_riqN9XQO12r2AJwu1j-BjSp7zZpHVdZopjCsOuqOLB5E0bPKtyfLauV97cRqI9ZfTCCrMu2spAHy");
//       _messaging.getToken().then((token) {
//         log("$token");
//         SharedPreferenceClass.SetSharedData("TokenID", token);
//       });
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         log('Message title: ${message.notification?.title}, body: ${message.notification?.body!.split("_")}, data: ${message.data}');
  


//          log(message.toMap().toString());

//         // Parse the message received
//         PushNotification notification = PushNotification(
//           title: message.notification?.title,
//           body: message.notification?.body,
//           dataTitle: message.data['title'],
//           dataBody: message.data['body'],
//         );
// //

// //vcv
//         setState(() {
//           _notificationInfo = notification;
//         });

//         if (_notificationInfo != null) {
//           // For displaying the notification as an overlay

//           // showSimpleNotification(
//           //   Text(_notificationInfo!.title ?? 'CRM'),
//           //   // leading: NotificationBadge(totalNotifications: _totalNotifications),
//           //   subtitle: Text(_notificationInfo!.body ?? '-'),
//           //   context: CommanClass.navState.currentContext,
//           //   background: ColorCollection.backColor,
//           //   duration: Duration(seconds: 3),
//           //   slideDismissDirection: DismissDirection.startToEnd,

//           //   elevation: 5,
//           // );

//           showOverlayNotification(
//             (context) {
//               return Material(
//                 // shape: RoundedRectangleBorder(
//                 //     borderRadius: BorderRadius.circular(10),
//                 //     side: BorderSide(color: Colors.white, width: 0.3)),

//                 // elevation: 1,
//                 color: Colors.transparent,
//                 child: Padding(
//                   padding: EdgeInsets.all(10),
//                   child: ListTile(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ChatScreen()));
//                     },
//                     selected: true,
//                     selectedTileColor: ColorCollection.white,
//                     selectedColor: ColorCollection.backColor,
//                     title: SizedBox(
//                         width: MediaQuery.of(context).size.width - 50,
//                         child: Text(
//                           _notificationInfo!.title ?? 'CRM',
//                           style: TextStyle(fontWeight: FontWeight.w700),
//                           overflow: TextOverflow.ellipsis,
//                         )),
//                     subtitle: SizedBox(
//                         width: MediaQuery.of(context).size.width - 50,
//                         child: Text(
//                           _notificationInfo!.body ?? '',
//                           style: TextStyle(fontWeight: FontWeight.w600),
//                           overflow: TextOverflow.ellipsis,
//                         )),
//                     leading: Image.asset(
//                       'assets/appLogo.png',
//                       height: 50,
//                       width: 50,
//                     ),
//                     trailing: IconButton(
//                         onPressed: () {
//                           OverlaySupportEntry.of(context)?.dismiss();
//                         },
//                         icon: Icon(Icons.close)),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: BorderSide(
//                             color: ColorCollection.backColor, width: 0.3)),
//                   ),
//                 ),
//               );
//             },
//             // Text(_notificationInfo!.title ?? 'CRM'),
//             // leading: NotificationBadge(totalNotifications: _totalNotifications),
//             // Text(_notificationInfo!.body ?? '-'),
//             context: CommanClass.navState.currentContext,
//             position: NotificationPosition.top,
//             duration: Duration(seconds: 3),
//           );
//         }
//       });
//     } else {
//       log('User declined or has not accepted permission');
//     }
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      log(initialMessage.toMap().toString());
      setState(() {
        CommanClass.noticationMessage = initialMessage;
        CommanClass.notifcationTapped = true;
      });
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
      });
    }
  }

  @override
  void initState() {
    _initSpeech();
    //registerNotification();
    checkForInitialMessage();

    // For handling notification when the app is in background
    // but not terminated

    getColors();
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   setState(() {
    //     CommanClass.notifcationTapped = true;
    //     CommanClass.noticationMessage = message;
    //   });
    //   log('notification Tapped == > $message');
    //   log(message.toMap().toString());
    //   if (CommanClass.isLogin) {
    //     if (CommanClass.StaffId != '') {
    //       Navigator.pushNamedAndRemoveUntil(
    //       //##
    //         CommanClass.navState.currentContext!,
    //         BottomBar.id,
    //         (route) => false,
    //       );
    //     }
    //   } else {
    //     log(' ELse Case 1');
    //   }

    //   PushNotification notification = PushNotification(
    //     title: message.notification?.title,
    //     body: message.notification?.body,
    //     dataTitle: message.data['title'],
    //     dataBody: message.data['body'],
    //   );

    //   setState(() {
    //     _notificationInfo = notification;
    //   });
    // });

    super.initState();
  }

  Future<void> getColors() async {
    if (await SharedPreferenceClass.GetSharedData("themeBool") == "True" &&
        await SharedPreferenceClass.GetSharedData("appBarColor") != null &&
        await SharedPreferenceClass.GetSharedData("textColor") != null &&
        await SharedPreferenceClass.GetSharedData("appBarTextColor") != null &&
        await SharedPreferenceClass.GetSharedData("containerC") != null) {
      String? col = await SharedPreferenceClass.GetSharedData("appBarColor");
      String? tColor = await SharedPreferenceClass.GetSharedData("textColor");
      String? appbarcolor =
          await SharedPreferenceClass.GetSharedData("appBarTextColor");
      String? containerCol =
          await SharedPreferenceClass.GetSharedData("containerC");
      setState(() {
        appcolors = col.toString();
        textColor = tColor.toString();
        appbarTextColor = appbarcolor.toString();
        containerColor = containerCol.toString();
      });
    } else {
      setState(() {
        appcolors = '0xFF68A642';
        textColor = '0xFF000000';
        appbarTextColor = '0xFFFFFFFF';
        containerColor = '0xFFFFFFFF';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ColorCollection()),
        ChangeNotifierProvider(create: (_) => KeyValues()),
      ],
      child: Consumer<ColorCollection>(
        builder: ((context, value, child) => OverlaySupport.global(
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: MaterialApp(
                  localizationsDelegates: context.localizationDelegates,
                  locale: context.locale,
                  supportedLocales: context.supportedLocales,
                  navigatorKey: CommanClass.navState,
                  debugShowCheckedModeBanner: false,
                  title: 'CRM ADMIN',
                  theme: ThemeData(
                      textTheme: GoogleFonts.montserratTextTheme(),
                      primarySwatch: appcolors != null
                          ? MaterialColor(
                              ColorCollection.backColor.value,
                              <int, Color>{
                                50: lighten(ColorCollection.backColor, 0.9),
                                100: lighten(ColorCollection.backColor, 0.8),
                                200: lighten(ColorCollection.backColor, 0.7),
                                300: lighten(ColorCollection.backColor, 0.6),
                                400: lighten(ColorCollection.backColor, 0.5),
                                500: ColorCollection.backColor,
                                600: darken(ColorCollection.backColor, 0.1),
                                700: darken(ColorCollection.backColor, 0.2),
                                800: darken(ColorCollection.backColor, 0.3),
                                900: darken(ColorCollection.backColor, 0.4),
                              },
                            )
                          : Colors.green),
                  initialRoute: SplashScreen.id,
                  // home: P2PChatPage(),
                  onGenerateRoute: RouteGenerator.generateRoute,
                ),
              ),
            )),
      ),
    );
  }
}

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}

// class TestScreen extends StatefulWidget {
//   const TestScreen({Key? key}) : super(key: key);

//   @override
//   State<TestScreen> createState() => TestScreenState();
// }

// class TestScreenState extends State<TestScreen> {
//   List dataList = [];

//   @override
//   void initState() {
//     if (CommanClass.noticationMessage != null) {
//       dataList.add(CommanClass.noticationMessage!.data['data']);
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Text(
//               '${CommanClass.notifcationTapped} }',
//             ),
//             if (CommanClass.noticationMessage != null)
//               Text(
//                 '${CommanClass.noticationMessage!.data['root']}}',
//               ),
//             if (CommanClass.noticationMessage != null)
//               Text(
//                 '${CommanClass.noticationMessage!.data['data']}}',
//               ),

//             // if (CommanClass.noticationMessage != null)
//             //   Text(
//             //     '${dataList[0]['name'].toString()}',
//             //   ),
//           ],
//         ),
//       ),
//     ));
//   }
// }
