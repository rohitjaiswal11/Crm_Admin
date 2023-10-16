// ignore_for_file: import_of_legacy_library_into_null_safe, unused_element

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/storage_manger.dart';

import '../LBM_Plugin/lbmplugin.dart';
import 'package:permission_handler/permission_handler.dart';
import '../util/LicenceKey.dart';
import 'package:geocoding/geocoding.dart';

/*
class LocationScreen extends StatefulWidget {
  static const String id = 'LocationScreen';
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool isLocationOn = false;

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
    return Scaffold(
        appBar: AppBar(
          title: Text(KeyValues.locatoin),
          // automaticallyImplyLeading: false,
          backgroundColor: ColorCollection.backColor,
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            child: Column(children: [
              Column(children: [
                SizedBox(
                  height: height * 0.05,
                ),
                ListTile(
                  // onTap: () {
                  //   Navigator.pushNamed(context, LocalAuthVerifyScreen.id,
                  //       arguments: VerifyModel(
                  //           isForward: true,
                  //           routeName: CreatePasswordScreen.id));
                  // },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: ColorCollection.backColor)),
                  title: Text('Enable Location Tracking',
                      style: ColorCollection.titleStyle2),
                  minLeadingWidth: 1,
                  leading: Icon(Icons.location_on_outlined),
                  trailing: Switch(
                      value: isLocationOn,
                      onChanged: (val) async {
                        final service = FlutterBackgroundService();
                        var isRunning = await service.isRunning();

                        SharedPreferenceClass.SetSharedData(
                            'isLocationOn', val);
                        setState(() {
                          isLocationOn = val;
                        });
                        if (isLocationOn) {
                          final isEnable =
                              await LocationClass().handleLocationPermission();
                          if (isEnable) {
                            if (!isRunning) {
                              service.startService();
                            }
                          }
                        } else {
                          if (isRunning) {
                            service.invoke("stopService");
                          }
                        }
                      }),
                  tileColor: ColorCollection.navBarColor,
                ),
              ])
            ])));
  }
}
*/

class LocationClass {
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ToastShowClass.toastShow(
          null,
          'Location permissions are disabled. Please enable the permissions',
          Colors.red);

      return false;
    }
    permission = await Geolocator.checkPermission();
    log('Permission -> $permission');
    if (permission != LocationPermission.always) {
      ToastShowClass.toastShow(
          null, 'Please click always  in location settings', Colors.red);

      await Permission.location.request();
      await Permission.locationAlways.request();
      return false;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ToastShowClass.toastShow(
            null, 'Location permissions are denied', Colors.red);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ToastShowClass.toastShow(
          null,
          'Location permissions are permanently denied, we cannot request permissions.',
          Colors.red);
      return false;
    }
    return true;
  }

  Future<void> _sendLocation(Position position,Placemark place) async {
    try {
      final staffId =
          await SharedPreferenceClass.GetSharedData('staff_id') ?? '';

      final paramDic = {
        'staffid': staffId,
        'l_lat': position.latitude.toString(),
        'l_long': position.longitude.toString(),
        'address':"${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}"
      };
log("location param"+paramDic.toString());
      final response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.addLocation, paramDic, "Post", Api_Key_by_Admin);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'].toString() == 'true') {
          log('Success -> ${data['message']}');
        } else {
          log('Failed -> ${data['message']}');
        }
      } else {
        log('Response -> ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      log('Errr -$e');
    }
  }

  Future<void> getCurrentPosition() async {
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always) {
      return;
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      await _getAddressFromLatLng(position);

    }).catchError((e) {
      debugPrint('Errrr - $e');

      return null;
    });
    return;
  }
Future<void> _getAddressFromLatLng(Position position) async {
  await placemarkFromCoordinates(
          position.latitude, position.longitude)
      .then((List<Placemark> placemarks) async{
    Placemark place = placemarks[0];
          await _sendLocation(position,place);
log('position'+place.toString() +"\n"+position.toString());
  }).catchError((e) {
   debugPrint(e);
  });

 }
}
  

