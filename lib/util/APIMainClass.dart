// // ignore_for_file: unused_import, non_constant_identifier_names, prefer_typing_uninitialized_variables, file_names, avoid_print

// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:lbm_crm/util/ToastClass.dart';

// import 'APIClasses.dart';

// Future<http.Response> APIMainClass(
//     String SubURL, Map<String, dynamic> paramDic, String PostGet) async {
//   var response;
//   switch (PostGet) {
//     //Get Method Work
//     case "Get":
//       final uri = Uri.https(APIClasses.BaseURL, SubURL, paramDic);
//       print("Get :" + uri.toString());
//       response = await http.get(uri, headers: {
//         "Accept": "application/json",
//         'authtoken': APIClasses.api_key
//       });
//       try {
//        final data = json.decode(response.body);
//         if (data['status'] != true) if (data['status'].toString() != '1') {
//          ToastShowClass.toastShow(null, data['message'] ?? 'Failed to Load Data', Colors.red);
//        }
//       } catch (e) {
//         log('Error == > $e');
//       }
//       return response;

//     //Post Method Work
//     case "Post":
//       final uri = Uri.https(APIClasses.BaseURL, SubURL);
//       print("Post :" + uri.toString());
//       response = await http.post(uri,
//           headers: {
//             "Accept": "application/json",
//             'authtoken': APIClasses.api_key
//           },
//           body: paramDic);

//       return response;

//     case "Put":
//       final uri = Uri.https(APIClasses.BaseURL, SubURL);
//       print("Put :" + uri.toString());
//       response = await http.post(uri,
//           headers: {
//             "Accept": "application/json",
//             'authtoken': APIClasses.api_key
//           },
//           body: paramDic);

//       return response;

//     case "Delete":
//       break;
//   }
//   return response;
// }
