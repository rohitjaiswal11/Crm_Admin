// ignore_for_file: import_of_legacy_library_into_null_safe, must_be_immutable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:lbm_crm/util/colors.dart';

import '../LBM_Plugin/lbmplugin.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../Support/support_detail_screen.dart';
import '../util/APIClasses.dart';
import '../util/LicenceKey.dart';
import '../util/ToastClass.dart';
import '../util/commonClass.dart';
import 'chat_screen.dart';

class ChatDetail extends StatefulWidget {
  static const id = 'ChatDetail';
  final String type;
  final String reciever_id;
  ChatItems receiverData;
  ChatDetail(
      {required this.type,
      required this.reciever_id,
      required this.receiverData});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  List<types.Message> _messages = [];
  List<Attachment> filesList = [];
  bool loading = true;
  late types.User _user;
  var turn = 0;
  bool isRefreshloading = false;
  @override
  void initState() {
    _user = types.User(
      id: widget.type == 'Client'
          ? 'staff_${CommanClass.StaffId}'
          : CommanClass.StaffId,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await updateStatus();
      await _loadMessages();
    });
    super.initState();
  }

  Future<void> updateStatus() async {
    try {
      if (widget.type == 'Group') {
        return;
      }
      final paramDic = {
        'id': widget.type == 'Client'
            ? 'client_${widget.reciever_id}'
            : widget.reciever_id,
      };
      final response = await LbmPlugin.APIMainClass(
          Base_Url_For_App,
          widget.type == 'Client'
              ? APIClasses.updateUnreadClient
              : APIClasses.updateUnread,
          paramDic,
          "Post",
          Api_Key_by_Admin);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'].toString() == '1') {
        } else {
          print('failed status-- ${data['status']}');
        }
      } else {
        print('failed response -- ${response.reasonPhrase}');
      }
    } catch (e) {
      print('failed Errror -- $e');
    }
  }

  // void _handleAttachmentPressed() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       final height = MediaQuery.of(context).size.height;
  //       final width = MediaQuery.of(context).size.width;
  //       return AlertDialog(
  //         title: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Spacer(),
  //             Text(
  //               '',
  //               style: ColorCollection.titleStyle2,
  //               textAlign: TextAlign.center,
  //             ),
  //             Spacer(),
  //             CircleAvatar(
  //               backgroundColor: Colors.white,
  //               child: IconButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   icon: Icon(
  //                     Icons.close,
  //                     color: Colors.black,
  //                   )),
  //             )
  //           ],
  //         ),
  //         content: Container(
  //           height: height * 0.12,
  //           width: width,
  //           alignment: Alignment.center,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.pop(context);
  //                       _handleImageSelection();
  //                     },
  //                     child: Icon(
  //                       Icons.image,
  //                       size: 50,
  //                     ),
  //                   ),
  //                   SizedBox(height: 10),
  //                   Text(KeyValues.selectImage),
  //                 ],
  //               ),
  //               VerticalDivider(
  //                 color: Colors.grey,
  //                 thickness: 1,
  //               ),
  //               Column(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.pop(context);
  //                       _handleFileSelection();
  //                     },
  //                     child: Icon(
  //                       Icons.upload_file,
  //                       size: 50,
  //                     ),
  //                   ),
  //                   SizedBox(height: 10),
  //                   Text(KeyValues.Files),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );

  //   // showModalBottomSheet<void>(
  //   //   context: context,
  //   //   builder: (BuildContext context) => SafeArea(
  //   //     child: SizedBox(
  //   //       height: 144,
  //   //       child: Column(
  //   //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //   //         children: <Widget>[
  //   //           TextButton(
  //   //             onPressed: () {
  //   //               Navigator.pop(context);
  //   //               _handleImageSelection();
  //   //             },
  //   //             child: const Align(
  //   //               alignment: AlignmentDirectional.centerStart,
  //   //               child: Text('Photo'),
  //   //             ),
  //   //           ),
  //   //           TextButton(
  //   //             onPressed: () {
  //   //               Navigator.pop(context);
  //   //               _handleFileSelection();
  //   //             },
  //   //             child: const Align(
  //   //               alignment: AlignmentDirectional.centerStart,
  //   //               child: Text('File'),
  //   //             ),
  //   //           ),
  //   //           TextButton(
  //   //             onPressed: () => Navigator.pop(context),
  //   //             child: const Align(
  //   //               alignment: AlignmentDirectional.centerStart,
  //   //               child: Text('Cancel'),
  //   //             ),
  //   //           ),
  //   //         ],
  //   //       ),
  //   //     ),
  //   //   ),
  //   // );
  // }

  // void _handleFileSelection() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.any,
  //   );

  //   if (result != null && result.files.single.path != null) {
  //     final message = types.FileMessage(
  //       author: _user,
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       id: const Uuid().v4(),
  //       mimeType: lookupMimeType(result.files.single.path!),
  //       name: result.files.single.name,
  //       size: result.files.single.size,
  //       uri: result.files.single.path!,
  //     );
  //     log('File message -> ${message.toString()} \n json-> ${message.toJson()}');

  //     // _addMessage(message);
  //   }
  // }

  // void _handleImageSelection() async {
  //   final result = await ImagePicker().pickImage(
  //     imageQuality: 70,
  //     maxWidth: 1440,
  //     source: ImageSource.gallery,
  //   );

  //   if (result != null) {
  //     final bytes = await result.readAsBytes();
  //     final image = await decodeImageFromList(bytes);

  //     final message = types.ImageMessage(
  //       author: _user,
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       height: image.height.toDouble(),
  //       id: const Uuid().v4(),
  //       name: result.name,
  //       size: bytes.length,
  //       uri: result.path,
  //       width: image.width.toDouble(),
  //     );

  //     log('Image message -> ${message.toString()} \n json-> ${message.toJson()}');
  //     // _addMessage(message);
  //   }
  // }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message.toJson()['text'].toString().startsWith('http')) {
      launchUrl(Uri.parse(message.toJson()['text'].toString()),
          mode: LaunchMode.externalApplication);
    }
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final paramDic = {
      'sender_id': widget.type == 'Client'
          ? 'staff_${CommanClass.StaffId}'
          : CommanClass.StaffId,
      (widget.type == 'Group' ? 'group_id' : 'reciever_id'):
          widget.type == 'Client'
              ? 'client_${widget.reciever_id}'
              : widget.reciever_id,
      'message': message.text
    };
    final response = await LbmPlugin.APIMainClass(
        Base_Url_For_App,
        widget.type == 'Chat'
            ? APIClasses.sendSingleMessage
            : widget.type == 'Group'
                ? APIClasses.sendgroupMessage
                : APIClasses.sendClientMessage,
        paramDic,
        "Post",
        Api_Key_by_Admin);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'].toString() == '1') {
        _loadMessages();
      } else {
        ToastShowClass.toastShow(context, data['message'], Colors.red);
      }
    } else {
      ToastShowClass.toastShow(
          context, response.reasonPhrase ?? 'Something Went Wrong', Colors.red);
    }
  }

  Future<void> _loadMessages() async {
    final paramDic = {
      'staff_id': widget.type == 'Group'
          ? widget.reciever_id
          : widget.type == 'Client'
              ? 'staff_${CommanClass.StaffId}'
              : CommanClass.StaffId,
      'type': widget.type,
      if (widget.type != 'Group')
        'reciever_id': widget.type == 'Client'
            ? 'client_${widget.reciever_id}'
            : widget.reciever_id,
    };

    try {
      final response = await LbmPlugin.APIMainClass(Base_Url_For_App,
          APIClasses.oldMessages, paramDic, "Get", Api_Key_by_Admin);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'].toString() == '1') {
          _messages.clear();
          filesList.clear();
          final messageList = data['data'];
          final files = data['fileshare'] ?? [];
          for (var i = 0; i < messageList.length; i++) {
            final message = messageList[i];
            DateTime dateTime = DateTime.parse(message['time_sent']);

            // Get the timestamp (milliseconds since epoch)
            int timestamp = dateTime.millisecondsSinceEpoch;
            _messages.add(types.TextMessage(
                author: types.User(
                  id: message['sender_id'],
                  firstName: widget.receiverData.firstName,
                  lastName: widget.receiverData.lastName,
                ),
                id: Uuid().v4(),
                text: message['message'],
                createdAt: timestamp,
                type: types.MessageType.text,
                status: widget.type == 'Group'
                    ? null
                    : message['viewed'].toString() == '0'
                        ? types.Status.sent
                        : types.Status.seen));
          }
          for (var i = 0; i < files.length; i++) {
            filesList.add(Attachment(
                name: files[i]['file_name'],
                url:
                    'https://ppscs.io/crm/modules/prchat/uploads/${files[i]['file_name']}'));
          }
          setState(() {
            loading = false;
          });
        } else {
          ToastShowClass.toastShow(context, data['message'], Colors.red);
          setState(() {
            loading = false;
          });
        }
      } else {
        // ToastShowClass.toastShow(
        //     context, response.reasonPhrase ?? 'Something Went Wrong', Colors.red);
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      log('Error -> $e');
      ToastShowClass.toastShow(context, 'Something Went Wrong', Colors.red);
      setState(() {
        loading = false;
      });
    }

    // final response = await rootBundle.loadString('assets/messages.json');
    // final messages = (jsonDecode(response) as List)
    //     .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
    //     .toList();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 40,
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                width: width * 0.13,
                height: width * 0.13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: ColorCollection.green,
                    width: 1.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    'https://ppscs.io/crm/uploads/staff_profile_images/${widget.receiverData.staffID}/thumb_${widget.receiverData.imageSource}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 28,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 5),
              Text(widget.receiverData.name),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () async {
                _loadMessages;
                _handlePreviewDataFetched;
                //     OldChat();
                for (var i = 0; i < 4; i++) {
                  await Future.delayed(Duration(milliseconds: 100), () {
                    turn = turn + 1;
                    setState(() {});
                  });
                }

                setState(() {
                  isRefreshloading = true;
                });
                print("00000");
              },
              icon: RotatedBox(
                quarterTurns: turn,
                child: Icon(
                  Icons.refresh,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return _multipleItemDialog(height, width);
                      }).then((value) {
                    setState(() {});
                  });
                },
                child: Icon(
                  Icons.file_present_outlined,
                  color: ColorCollection.white,
                )),
            SizedBox(
              width: 10,
            ),
          ]),
      body: SafeArea(
        bottom: false,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Chat(
                messages: _messages.reversed.toList(),
                // onAttachmentPressed: _handleAttachmentPressed,
                onMessageTap: _handleMessageTap,
                onPreviewDataFetched: _handlePreviewDataFetched,
                onSendPressed: _handleSendPressed,
                showUserAvatars: true,
                showUserNames: true,
                user: _user,
                theme: DefaultChatTheme(
                  primaryColor: ColorCollection.backColor,
                  userAvatarNameColors: [ColorCollection.backColor],
                  userAvatarImageBackgroundColor: ColorCollection.backColor,
                  inputBackgroundColor: Colors.black87,
                ),
              ),
      ),
    );
  }

  StatefulBuilder _multipleItemDialog(double height, double width) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          height: height * 0.5,
          width: width * 0.8,
          decoration: BoxDecoration(
              border: Border.all(color: ColorCollection.backColor, width: 2)),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Media",
                    style: ColorCollection.titleStyleGreen2,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                height: height * 0.43,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < filesList.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          CommanClass.FileURL =
                                              filesList[i].url;
                                          showGeneralDialog(
                                              barrierColor:
                                                  Colors.black.withOpacity(0.5),
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
                                              pageBuilder: (context, animation1,
                                                  animation2) {
                                                return SizedBox();
                                              });
                                        },
                                        child: Image.network(
                                          filesList[i].url,
                                          fit: BoxFit.fill,
                                          height: 50,
                                          width: 50,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                            Icons.insert_drive_file_sharp,
                                            color: ColorCollection.backColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      SizedBox(
                                          width: width * 0.4,
                                          child: Marquee(
                                            child: Text(filesList[i].name),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                color: ColorCollection.backColor,
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class Attachment {
  final String name;
  final String url;
  Attachment({
    required this.name,
    required this.url,
  });
}
