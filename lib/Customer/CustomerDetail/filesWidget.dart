
 // ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';
// import 'package:lbm_crm/util/colors.dart';
// import 'package:lbm_crm/util/constants.dart';

// class CustomerFiles extends StatefulWidget {
//   static const id = 'CustomerFiles';

//   @override
//   CustomerFilesState createState() => CustomerFilesState();
// }

// class CustomerFilesState extends State<CustomerFiles> {
//   PlatformFile? file;

//   void _pickFile() async {
//     // opens storage to pick files and the picked file or files
//     // are assigned into result and if no file is chosen result is null.
//     // you can also toggle "allowMultiple" true or false depending on your need
//     final result = await FilePicker.platform.pickFiles(allowMultiple: true);

//     // if no file is picked
//     if (result == null) return;

//     // we get the file from result object
//     file = result.files.first;
//     setState(() {});
//   }

//   void _openFile(PlatformFile? file) {
//     if (file != null) {
//       OpenFile.open(file.path!);
//     }
//     return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: width * 0.03),
//           child: Container(
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10)),
//             height: height * 0.06,
//             width: width * 0.9,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   height: height * 0.06,
//                   width: width * 0.75,
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                       hintText: 'Search Files',
//                       contentPadding: EdgeInsets.symmetric(
//                           horizontal: width * 0.02, vertical: height * 0.01),
//                       hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: height * 0.06,
//                   width: width * 0.11,
//                   decoration: BoxDecoration(
//                       color: ColorCollection.darkGreen,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: IconButton(
//                     onPressed: () {},
//                     icon: Icon(
//                       Icons.search,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(
//           height: height * 0.04,
//         ),
//         Container(
//             height: height * 0.62,
//             padding: EdgeInsets.symmetric(
//               horizontal: width * 0.06,
//             ),
//             width: width,
//             decoration: kContaierDeco.copyWith(color: ColorCollection.containerC),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('No Data', style: ColorCollection.subTitleStyle),
//                 SizedBox(height: height * 0.03),
//                 SizedBox(
//                   height: width * 0.2,
//                   width: width * 0.2,
//                   child: Image.asset(
//                     'assets/folder.png',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(height: height * 0.01),
//                 SizedBox(
//                   width: width * 0.25,
//                   child: OutlinedButton(
//                     style: ButtonStyle(
//                         side: MaterialStateProperty.all(
//                             BorderSide(color: Colors.orange.shade400))),
//                     onPressed: () {
//                       _pickFile();
//                     },
//                     child: Text(
//                       file != null ? 'Change File' : 'Add File',
//                       style: TextStyle(
//                           color: Colors.orange.shade400,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: height * 0.01,
//                 ),
//                 if (file != null)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(file!.name),
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             file = null;
//                           });
//                         },
//                         child: Icon(
//                           Icons.delete,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                 if (file != null)
//                   TextButton(
//                     onPressed: () {
//                       _openFile(file);
//                     },
//                     child: Text(
//                       'Tap To See',
//                       style: ColorCollection.titleStyleGreen2,
//                     ),
//                   ),
//               ],
//             )),
//       ],
//     );
//   }
// }
