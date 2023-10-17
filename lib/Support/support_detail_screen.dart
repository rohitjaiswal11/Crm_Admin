// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, must_be_immutable, non_constant_identifier_names, avoid_print, import_of_legacy_library_into_null_safe, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_crm/util/storage_manger.dart';

import '../Plugin/lbmplugin.dart';
import 'package:marquee_widget/marquee_widget.dart';

class SupportDetailScreen extends StatefulWidget {
  static const id = '/SupportDetails';
  List TicketData = [];
  SupportDetailScreen({required this.TicketData});

  @override
  State<SupportDetailScreen> createState() => _SupportDetailScrenState();
}

class _SupportDetailScrenState extends State<SupportDetailScreen> {
  final deco = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: ColorCollection.backColor,
      boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]);
  HtmlEditorController controller = HtmlEditorController();

  File? imageFile;

  /// Get from gallery
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        UploadFileName = pickedFile.name;
        Navigator.pop(context);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        UploadFileName = pickedFile.name;
        Navigator.pop(context);
      });
    }
  }

  String UploadFileName = '';
  List ticketreply = [];
  List UploadTicketReply = [];

  List<Attachment> UploadTicketEmpty = [];
  List<Attachment> NotUploadTicket = [];
  List<Fetchdata> ticketreplynew = [];
  List<Attachment> ticketreplyAttachment = [];
  List<Attachment> newticketreplyAttachment = [];
  bool isDataFetched = false;
  String isReplyHistory = "yes";
  final _formKey = GlobalKey<FormState>();
  String replyperson = '';
  ScrollController _controller = ScrollController();
  int _state = 0;
  bool ShowText = false;

  @override
  void initState() {
    super.initState();
    getticketDashboard();
  }

  TextEditingController controllerreply = TextEditingController();

  Future<void> getticketDashboard() async {
    final paramDic = {
      "ticketid": widget.TicketData[0]['ticketid'].toString(),
      "message": controllerreply.text == '' ? '' : controllerreply.text,
      "userid": widget.TicketData[0]['userid'].toString(),
      "replydata": isReplyHistory.toString(),
    };
    var response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.GetTicketDetailReply, paramDic, "Post", Api_Key_by_Admin);
    var data = json.decode(response.body);
    replyperson = await SharedPreferenceClass.GetSharedData("firstname") +
        ' ' +
        await SharedPreferenceClass.GetSharedData("lastname");
    ticketreply.clear();
    ticketreplynew.clear();
    if (response.statusCode == 200) {
      setState(() {
        if (isReplyHistory == "yes") {
          //fetch reply
          _state = 0;
          imageFile = null;
          ticketreply = data['data'];
          controllerreply.text = '';
          isDataFetched = true;
        } else {
          // send reply
          setState(() {
            _state = 0;
            ticketreplynew.add(Fetchdata(
                replyperson,
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                controllerreply.text,
                NotUploadTicket));
            _controller.jumpTo(_controller.position.maxScrollExtent);
            controllerreply.text = '';
            isDataFetched = true;
          });
        }
      });
    } else {
      print("check data not found" + isReplyHistory);

      ticketreply.clear();
      ticketreplynew.clear();
      isDataFetched = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    log(ticketreply.toString());
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
                        'assets/newticket.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Text(KeyValues.support,
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
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.01,
                horizontal: width * 0.06,
              ),
              width: width,
              decoration:
                  kContaierDeco.copyWith(color: ColorCollection.containerC),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.TicketData[0]['subject'] == null
                        ? widget.TicketData[0]['ticketid']
                        : widget.TicketData[0]['ticketid'] +
                            '- (' +
                            widget.TicketData[0]['subject'] +
                            ' )',
                    style: ColorCollection.titleStyle2,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: SizedBox(
                      height: height * 0.4,
                      child: isDataFetched == false
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ticketreply.isNotEmpty
                              ? ListView.builder(
                                  controller: _controller,
                                  itemCount: ticketreply.length,
                                  itemBuilder: (context, i) =>
                                      messages(height, width, i))
                              : ListView.builder(
                                  controller: _controller,
                                  itemCount: 1,
                                  itemBuilder: (context, i) => Text(
                                        'No Replies Yet',
                                        style: ColorCollection.titleStyle,
                                      )),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  messageComposser(height, width),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(double height, double width, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.01),
      padding: EdgeInsets.only(
          left: width * 0.04,
          right: width * 0.04,
          top: height * 0.025,
          bottom: height * 0.025),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          color: ColorCollection.backColor.withOpacity(0.02),
          borderRadius: BorderRadius.circular(6)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ticketreply[index]['submitter'] == null
                ? ''
                : ticketreply[index]['submitter'].toString(),
            style: ColorCollection.titleStyle2,
          ),
          SizedBox(
            height: height * 0.003,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.6,
                child: Marquee(
                  child: Text(
                    ticketreply[index]['message'] == null
                        ? ''
                        : ticketreply[index]['message'].toString(),
                    style: ColorCollection.subTitleStyle,
                  ),
                ),
              ),
              Text(
                ticketreply[index]['date'] == null
                    ? ''
                    : ticketreply[index]['date'].toString(),
                style: ColorCollection.subTitleStyle.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0;
                    i < ticketreply[index]['attachments'].length;
                    i++)
                  InkWell(
                    onTap: () async {
                      CommanClass.FileURL = "http://" +
                          Base_Url_For_App +
                          "/crm/download/preview_image?path=uploads/ticket_attachments/" +
                          widget.TicketData[0]['ticketid'] +
                          "/" +
                          ticketreply[index]['attachments'][i]['file_name'] +
                          "&" +
                          ticketreply[index]['attachments'][i]['filetype'];

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
                    child: ticketreply[index]['attachments'][i]['filetype'] ==
                            "application/pdf"
                        ? Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/proposalicon.png')),
                            ),
                          )
                        : Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage("http://" +
                                    Base_Url_For_App +
                                    "/crm/download/preview_image?path=uploads/ticket_attachments/" +
                                    widget.TicketData[0]['ticketid'] +
                                    "/" +
                                    ticketreply[index]['attachments'][i]
                                        ['file_name'] +
                                    "&" +
                                    ticketreply[index]['attachments'][i]
                                        ['filetype']),
                              ),
                            ),
                          ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mainMessages(double height, double width, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.01),
      padding: EdgeInsets.only(
          left: width * 0.04,
          right: width * 0.04,
          top: height * 0.025,
          bottom: height * 0.025),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          color: ColorCollection.backColor.withOpacity(0.02),
          borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.TicketData[0]['submitter'] == null
                ? ''
                : widget.TicketData[0]['submitter'].toString(),
            style: ColorCollection.titleStyle2,
          ),
          SizedBox(
            height: height * 0.003,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.TicketData[0]['message'] == null
                    ? ''
                    : widget.TicketData[0]['message'].toString(),
                style: ColorCollection.subTitleStyle,
              ),
              Text(
                widget.TicketData[0]['date'] == null
                    ? ''
                    : widget.TicketData[0]['date'].toString(),
                style: ColorCollection.subTitleStyle.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }

  Widget messageComposser(
    double height,
    double width,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HtmlEditor(
            controller: controller,
            htmlEditorOptions: HtmlEditorOptions(
              hint: KeyValues.yourtexthere,
            ),
            otherOptions: OtherOptions(
              decoration: kDropdownContainerDeco,
              height: height * 0.17,
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            KeyValues.selectImage,
                            style: ColorCollection.titleStyle2,
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                )),
                          )
                        ],
                      ),
                      content: Container(
                        height: height * 0.12,
                        width: width,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _getFromCamera();
                                  },
                                  child: Icon(
                                    Icons.camera,
                                    size: 50,
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                Text(KeyValues.camera),
                              ],
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _getFromGallery();
                                  },
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                Text(KeyValues.gallery),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              });
            },
            child: Container(
              height: height * 0.05,
              decoration: kDropdownContainerDeco,
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.03,
                  ),
                  imageFile == null
                      ? Icon(Icons.image)
                      : SizedBox(
                          height: height * 0.03,
                          width: width * 0.05,
                          child: Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                          ),
                        ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  imageFile == null
                      ? Text(
                          KeyValues.nofile,
                          style: ColorCollection.subTitleStyle,
                        )
                      : SizedBox(
                          width: width * 0.5,
                          child: Text(
                            UploadFileName,
                            style: ColorCollection.titleStyleGreen3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          SizedBox(
            height: height * 0.045,
            width: width,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(ColorCollection.green),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_state == 0) {
                    setState(() {
                      _state == 0;
                      isReplyHistory = "no";
                      getticketDashboardReply();
                    });
                    controller.clear();
                  }
                }
              },
              child: _state == 0
                  ? Text(KeyValues.save, style: ColorCollection.buttonTextStyle)
                  : Text('...Sending', style: ColorCollection.buttonTextStyle),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
        ],
      ),
    );
  }

  ShowUploadFile() {
    setState(() {
      String FileType = '';
      imageFile = CommanClass.UploadFile;
      UploadFileName = CommanClass.UploadFilename;
// if(UploadFileName.split(".")[1]=="png"){
//   FileType="image/png";
// }else if(UploadFileName.split(".")[1]=="jpg") {
// FileType="image/jpg";
// }else if(UploadFileName.split(".")[1]=="pdf") {
// FileType="application/pdf";
// }
      NotUploadTicket.add(Attachment(imageFile.toString(), FileType));
    });
  }

  void getticketDashboardReply() async {
    final uri = Uri.https(APIClasses.BaseURL, APIClasses.GetTicketDetailReply);

    MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers['authtoken'] = (APIClasses.api_key);
    request.fields['ticketid'] = widget.TicketData[0]['ticketid'].toString();
    request.fields['message'] = await controller.getText();
    // request.fields['message'] =
    //     controllerreply.text == '' ? '' : controllerreply.text;
    request.fields['userid'] =
        await SharedPreferenceClass.GetSharedData("staff_id");
    request.fields['replydata'] = isReplyHistory.toString();

    var file;
    print(request.fields['message']);
    if (imageFile != null) {
      var stream =
          // ignore: deprecated_member_use
          await http.ByteStream(DelegatingStream.typed(imageFile!.openRead()));
      log('stream ${imageFile!.path}');
      var length = await imageFile!.length();
      file = http.MultipartFile('attachments[]', stream, length,
          filename: UploadFileName);
      request.files.add(file);
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      print('here if case');
      setState(() {
        isReplyHistory = "yes";
        getticketDashboard();

        response.stream.transform(utf8.decoder).listen((value) {
          log(value.toString());
        });
      });
    } else {
      print('here else case ${response.statusCode}');
      isDataFetched = true;
    }
  }
}

class Fetchdata {
  String submitter;
  String date;
  String message;
  List<Attachment> attach;

  Fetchdata(this.submitter, this.date, this.message, this.attach);
}

class Attachment {
  String FileName;
  String FileType;
  Attachment(this.FileName, this.FileType);
}

class PreviewDialogBox extends StatefulWidget {
  bool? isFile;
  PreviewDialogBox({this.isFile});
  @override
  State<StatefulWidget> createState() {
    return _PreviewDialogBox();
  }
}

class _PreviewDialogBox extends State<PreviewDialogBox> {
  @override
  void initState() {
    super.initState();
    print(CommanClass.FileURL);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Center(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: GestureDetector(
          onTap: () {},
          child: SizedBox(
            height: 800,
            child: Dialog(
              backgroundColor: ColorCollection.backColor,
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: widget.isFile == true
                      ? Image.file(File(CommanClass.FileURL),
                          errorBuilder: (context, error, stackTrace) {
                          Navigator.pop(context);

                          return Text(
                            'No Image Found',
                            style: TextStyle(color: Colors.white),
                          );
                        })
                      : Image.network(CommanClass.FileURL,
                          errorBuilder: (context, error, stackTrace) {
                          Navigator.pop(context);
                          return Text(
                            'No Image Found',
                            style: TextStyle(color: Colors.white),
                          );
                        })),
            ),
          ),
        ),
      )),
    );
  }
}
