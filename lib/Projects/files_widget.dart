// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, non_constant_identifier_names, avoid_print, import_of_legacy_library_into_null_safe, prefer_typing_uninitialized_variables, deprecated_member_use, unnecessary_null_comparison, prefer_if_null_operators

import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:lbm_crm/Support/support_detail_screen.dart';
import 'package:lbm_crm/Tasks/task_detail_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/routesArguments.dart';
import 'package:lbm_crm/util/storage_manger.dart';

import '../Plugin/lbmplugin.dart';

class ProjectFiles extends StatefulWidget {
  static const id = 'ProjectFiles';
  RouteFile routefile;
  String CustomerID = '', CustomerType = '';
  ProjectFiles({required this.routefile}) {
    CustomerID = routefile.ID;
    CustomerType = routefile.Type;
  }

  @override
  ProjectFilesState createState() => ProjectFilesState();
}

class ProjectFilesState extends State<ProjectFiles> {
  //variable initialization
  File? UploadFile;
  String UploadFileName = '';
  List files = [];
  List filesnew = [];
  List filessearch = [];

  var isDataFetched = false;
  bool isLoading = false;
  bool isupload = false;

  @override
  void initState() {
    super.initState();
    print(widget.CustomerID);
    getfilesDashboard();
  }

  //page finish
  @override
  void dispose() {
    super.dispose();
    isDataFetched = false;
    files.clear();
    filesnew.clear();
    filessearch.clear();
  }

  //api data get files record
  Future<void> getfilesDashboard() async {
    final paramDic = {
      "customer_id": widget.CustomerID.toString(),
      "detailtype": 'files',
      "typeof": widget.CustomerType.toString(),
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetCustomerDetail, paramDic, "Get", Api_Key_by_Admin);
    var data = json.decode(response.body);
    files.clear();
    filesnew.clear();
    filessearch.clear();
    print('Data' + data.toString());
    if (response.statusCode == 200) {
      print('Files ===>' + files.toString());
      if (mounted) {
        setState(() {
          files = data['data'];
          // dataHeader.add(data['data']);
          filesnew.addAll(files);
          filessearch.addAll(files);
          isDataFetched = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          print('Failed ===>' + response.statusCode.toString());
          isDataFetched = true;
          files.clear();
          filesnew.clear();
        });
      }
    }
  }

  //this api use to change the permission to customer show image or not
  Future<void> VisiabletoCustomer(String id) async {
    final paramDic = {
      "id": id.toString(),
      "type": 'customer',
    };
    print(paramDic);
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetVisiabletoCustomer, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      getfilesDashboard();
      setState(() {
        ToastShowClass.coolToastShow(
            context, data['message'], CoolAlertType.success);
      });
    } else {
      ToastShowClass.coolToastShow(
          context, data['message'], CoolAlertType.error);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: ColorCollection.backColor,
          child: Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            showGeneralDialog(
                barrierColor: Colors.black.withOpacity(0.5),
                transitionBuilder: (context, a1, a2, widget) {
                  return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                      opacity: a1.value,
                      child: AttachmentAddDialogBox(),
                    ),
                  );
                },
                transitionDuration: Duration(milliseconds: 400),
                barrierDismissible: false,
                barrierLabel: '',
                context: context,
                pageBuilder: (context, animation1, animation2) {
                  return SizedBox();
                }).then((value) => ShowUploadFile());
          }),
      body: SelectionArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                height: height * 0.06,
                width: width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: height * 0.06,
                      width: width * 0.75,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Search Files',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.01),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.06,
                      width: width * 0.11,
                      decoration: BoxDecoration(
                          color: ColorCollection.darkGreen,
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Container(
                height: widget.CustomerType == 'customer'
                    ? height * 0.62
                    : height * 0.6,
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                ),
                width: width,
                decoration:
                    kContaierDeco.copyWith(color: ColorCollection.containerC),
                child: isupload == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: height * 0.04,
                          ),
                          SizedBox(
                            height: height * 0.5,
                            width: width,
                            child: isDataFetched == false
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : filesnew.isEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: width * 0.2,
                                            width: width * 0.2,
                                            child: Image.asset(
                                              'assets/folder.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          SizedBox(
                                            width: width * 0.25,
                                            child: OutlinedButton(
                                              style: ButtonStyle(
                                                  side:
                                                      MaterialStateProperty.all(
                                                          BorderSide(
                                                              color: Colors
                                                                  .orange
                                                                  .shade400))),
                                              onPressed: () {
                                                showGeneralDialog(
                                                        barrierColor: Colors
                                                            .black
                                                            .withOpacity(0.5),
                                                        transitionBuilder:
                                                            (context, a1, a2,
                                                                widget) {
                                                          return Transform
                                                              .scale(
                                                            scale: a1.value,
                                                            child: Opacity(
                                                              opacity: a1.value,
                                                              child:
                                                                  AttachmentAddDialogBox(),
                                                            ),
                                                          );
                                                        },
                                                        transitionDuration:
                                                            Duration(
                                                                milliseconds: 400),
                                                        barrierDismissible: false,
                                                        barrierLabel: '',
                                                        context: context,
                                                        pageBuilder:
                                                            (context, animation1,
                                                                animation2) {
                                                          return SizedBox();
                                                        })
                                                    .then((value) =>
                                                        ShowUploadFile());
                                              },
                                              child: Text(
                                                UploadFile != null
                                                    ? 'Change File'
                                                    : 'Add File',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                        Colors.orange.shade400,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          if (UploadFile != null)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    width: width * 0.3,
                                                    child: SingleChildScrollView(
                                                        child: Text(
                                                            UploadFileName))),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      UploadFile = null;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          if (UploadFile != null)
                                            ElevatedButton(
                                              onPressed: () {
                                                ShowUploadFile();
                                              },
                                              child: Text(
                                                'Upload',
                                                style: ColorCollection
                                                    .buttonTextStyle,
                                              ),
                                            ),
                                        ],
                                      )
                                    : ListView.builder(
                                        itemCount: files.length,
                                        itemBuilder: (c, i) =>
                                            newbuildList(context, i)),
                          )
                        ],
                      )),
          ],
        ),
      ),
    );
  }

//list of images show in list
  Widget newbuildList(BuildContext context, int index) {
    print('File Name = ' +
        filesnew[index]['file_name'].toString() +
        'Status = => ${filesnew[index]['visible_to_customer'].toString()}');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      // Icon(Icons.image),
                      Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            image: DecorationImage(
                              image: widget.CustomerType == 'customer'
                                  ? NetworkImage("http://" +
                                      Base_Url_For_App +
                                      "/crm/download/preview_image?path=/uploads/clients/" +
                                      widget.CustomerID.toString() +
                                      "/" +
                                      filesnew[index]['file_name'].toString())
                                  : NetworkImage("http://" +
                                      Base_Url_For_App +
                                      "/crm/uploads/projects/" +
                                      widget.CustomerID +
                                      "/" +
                                      filesnew[index]['file_name'].toString()),
                              fit: BoxFit.fill,
                            ),
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                          onTap: () {
                            CommanClass.FileURL = widget.CustomerType ==
                                    'customer'
                                ? "http://" +
                                    Base_Url_For_App +
                                    "/crm/download/preview_image?path=/uploads/clients/" +
                                    widget.CustomerID.toString() +
                                    "/" +
                                    filesnew[index]['file_name'].toString()
                                : "http://" +
                                    Base_Url_For_App +
                                    "/crm/uploads/projects/" +
                                    widget.CustomerID +
                                    "/" +
                                    filesnew[index]['file_name'].toString();

                            showGeneralDialog(
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionBuilder: (context, a1, a2, widget) {
                                  return Transform.scale(
                                    scale: a1.value,
                                    child: Opacity(
                                      opacity: a1.value,
                                      child: PreviewDialogBox(),
                                    ),
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 100),
                                barrierDismissible: false,
                                barrierLabel: '',
                                context: context,
                                pageBuilder: (context, animation1, animation2) {
                                  return SizedBox();
                                });
                          },
                          child: SizedBox(
                            width: 150,
                            child: Text(
                              filesnew[index]['file_name'].toString() == null
                                  ? ''
                                  : filesnew[index]['file_name'].toString(),
                              style: TextStyle(
                                color: ColorCollection.titleColor,
                                fontSize: 14.0,
                              ),
                            ),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 6.0),
                      Text(
                        filesnew[index]['dateadded'] == null
                            ? ''
                            : filesnew[index]['dateadded'].toString(),
                        style: TextStyle(
                          color: ColorCollection.titleColor,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      PlatformSwitch(
                        value:
                            filesnew[index]['visible_to_customer'].toString() ==
                                "1",
                        onChanged: (bool value) {
                          VisiabletoCustomer(filesnew[index]['id'].toString());

                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());

                            print(value);
                          });
                        },
                      ),
                      Text(
                        "Show to customers area",
                        style: TextStyle(fontSize: 8.0),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: ColorCollection.titleColor,
                        border: Border.all(color: ColorCollection.lightgreen),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 1.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.mail_outline,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
              )
            ],
          ),
        ),
      ],
    );
  }

  //search image
  onSearchTextChanged(String text) async {
    filesnew.clear();
    if (text.isEmpty) {
      setState(() {
        filesnew = List.from(filessearch);
      });
      return;
    }

    setState(() {
      filesnew = filessearch
          .where((item) => item['file_name']
              .toString()
              .toLowerCase()
              .contains(text.toString().toLowerCase()))
          .toList();
    });
  }

  //image upload on server by multipart api
  uploadonserver() async {
    print(UploadFile);

    final uri = Uri.https(APIClasses.BaseURL, APIClasses.GetFileUpload);

    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers['authtoken'] = (APIClasses.api_key);
    request.fields['project_id'] = widget.CustomerID.toString();
    request.fields['staff_id'] =
        await SharedPreferenceClass.GetSharedData('staff_id');
    request.fields['contact_id'] = "0";
    request.fields['typeof'] = widget.CustomerType.toString();

    var file;

    if (UploadFile != null) {
      print(UploadFile);
      var stream =
          http.ByteStream(DelegatingStream.typed(UploadFile!.openRead()));
      var length = await UploadFile!.length();
      file =
          http.MultipartFile('file', stream, length, filename: UploadFileName);
      request.files.add(file);
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Upload Done');
      setState(() {
        isupload = false;
        UploadFile = null;
        UploadFileName = '';
        ToastShowClass.coolToastShow(
            context, 'Uploaded Successfully', CoolAlertType.success);
      });
      response.stream.transform(utf8.decoder).listen((value) {});
      getfilesDashboard();
    } else {
      print('Upload Failed ' + response.statusCode.toString());
      ToastShowClass.coolToastShow(
          context, 'Uploading Failed', CoolAlertType.error);
    }
  }

  ShowUploadFile() {
    setState(() {
      UploadFile = CommanClass.UploadFile;
      UploadFileName = CommanClass.UploadFilename;
      if (UploadFile != null) {
        isupload = true;
        uploadonserver();
      }
    });
  }
}
