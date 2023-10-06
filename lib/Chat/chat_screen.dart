// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lbm_crm/Chat/chat_detail_screen.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/util/APIClasses.dart';
import 'package:lbm_crm/util/LicenceKey.dart';
import 'package:lbm_crm/util/ToastClass.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/commonClass.dart';
import 'package:lbm_crm/util/constants.dart';
import 'package:lbm_plugin/lbm_plugin.dart';
import 'package:marquee_widget/marquee_widget.dart';

class ChatScreen extends StatefulWidget {
  static const id = '/Chat';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {


final searchController  = TextEditingController();

  late TabController _tabController;
  bool loading = true;
  List<ChatItems> staffList = [];
    List<ChatItems> staffListFilted = [];
  List<ChatItems> groupList = [];
   List<ChatItems> groupListFilter = [];
  List<ChatItems> clientList = [];
  List<ChatItems> clientListFilter = [];

  addDataTolist(List<ChatItems> list, data) {
    for (var i = 0; i < data.length; i++) {
      list.add(ChatItems(
          firstName: data[i]['firstname'] ?? '',
          lastName: data[i]['lastname'] ?? '',
          name: (data[i]['firstname'] ?? '').toString() +
              ' ' +
              (data[i]['lastname']).toString(),
          imageSource: data[i]['profile_image'],
          staffID: data[i]['staffid']));
    }
  }

  Future<void> getChatList() async {
    final paramDic = {'staff_id': CommanClass.StaffId};

    // try {
    final response = await LbmPlugin.APIMainClass(Base_Url_For_App,
        APIClasses.chatList, paramDic, "Get", Api_Key_by_Admin);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'].toString() == '1') {
        /// Staff List Data

        for (var i = 0; i < data['user_data'].length; i++) {
          staffList.add(ChatItems(
              firstName: data['user_data'][i]['firstname'] ?? '',
              lastName: data['user_data'][i]['lastname'] ?? '',
              name: (data['user_data'][i]['firstname'] ?? '').toString() +
                  ' ' +
                  (data['user_data'][i]['lastname']).toString(),
              imageSource: data['user_data'][i]['profile_image'],
              staffID: data['user_data'][i]['staffid']));

        }
        staffListFilted.clear;
        staffListFilted.addAll(staffList);
    



        /// Group List Data

        for (var i = 0; i < data['group_data'].length; i++) {
          groupList.add(ChatItems(
              firstName: data['group_data'][i]['group_name'] ?? '',
              lastName: '',
              name: data['group_data'][i]['group_name'] ?? '',
              imageSource: data['group_data'][i]['profile_image'],
              staffID: data['group_data'][i]['id']));
        }
       groupListFilter.clear;
       
        groupListFilter.addAll(groupList);

        /// Client List Data

        for (var i = 0; i < data['client_data'].length; i++) {
          clientList.add(ChatItems(
              firstName: data['client_data'][i]['firstname'] ?? '',
              lastName: data['client_data'][i]['lastname'] ?? '',
              name: (data['client_data'][i]['firstname'] ?? '').toString() +
                  ' ' +
                  (data['client_data'][i]['lastname']).toString(),
              imageSource: data['client_data'][i]['profile_image'],
              staffID: data['client_data'][i]['id']));
        }

  clientListFilter.clear;
       
        clientListFilter.addAll(clientList);

        // addDataTolist(staffList, data['user_data']);
        // addDataTolist(groupList, data['group_data']);
        // addDataTolist(clientList, data['client_data']);
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
      ToastShowClass.toastShow(
          context, response.reasonPhrase ?? 'Something Went Wrong', Colors.red);
      setState(() {
        loading = false;
      });
    }
    // } catch (e) {
    //   log('Error -> $e');
    //   ToastShowClass.toastShow(context, 'Something Went Wrong', Colors.red);
    //   setState(() {
    //     loading = false;
    //   });
    // }
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    getChatList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
                child: Column(
                  children: [
                    SizedBox(height: height/21,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width * 0.05,
                        ),
                        SizedBox(
                          height: height * 0.07,
                          width: width * 0.11,
                          child: Image.asset(
                            'assets/chat.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.04,
                        ),
                        Text(KeyValues.chat,
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
           


SizedBox(height: height/71,),
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
                         controller: searchController,
                        autofocus: false,
                         onChanged: (_){

                          //List<ChatItems> groupList = [];
  //  List<ChatItems> groupListFilter = [];
  // List<ChatItems> clientList = [];
  // List<ChatItems> clientListFilter = [];

                          if(_tabController.index ==0){
                           
                          staffList = staffList  .where((staff) => staff.name.toLowerCase().contains(searchController.text.toLowerCase())).toList();
                           setState(() { });
                          }else if(_tabController.index ==1){
                          groupList = groupList  .where((staff) => staff.name.toLowerCase().contains(searchController.text.toLowerCase())).toList();
                           setState(() { });
                          }else if(_tabController.index ==2){
                            clientList = clientList  .where((staff) => staff.name.toLowerCase().contains(searchController.text.toLowerCase())).toList();
                           setState(() { });
                          }

       
if(searchController.text.isEmpty){

  print("empty==> list  "+staffListFilted.length.toString() );
   print("staffList==> list  "+staffList.length.toString() );
  setState(() {
    staffList= [];
    clientList =[];
    groupList = [];
  staffList.addAll(staffListFilted);
  clientList.addAll(clientListFilter);
  groupList.addAll(groupListFilter);
  
    
  });
}


                         },
                        decoration: InputDecoration(
                          hintText: KeyValues.search,
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

           
                  
                  ],
                ),
              ),
            ),
          
            SizedBox(
              height: height * 0.04,
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: height * 0.022),
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.05,
                    horizontal: width * 0.06,
                  ),
                  width: width,
                  decoration:
                      kContaierDeco.copyWith(color: ColorCollection.containerC),
                  child: SizedBox(
                    height: height * 0.65,
                    child: loading
                        ? Center(child: CircularProgressIndicator())
                        : TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                                SizedBox(
                                  height: height * 0.5,
                                  child: staffList.isEmpty
                                      ? Center(
                                          child: Text('No Data Found'),
                                        )
                                      : ListView.builder(
                                          itemCount: staffList.length,
                                          itemBuilder: (c, i) => chatContainer(
                                              height: height,
                                              width: width,
                                              name: staffList[i].name,
                                              imageSource:
                                                  staffList[i].imageSource,
                                              chat: staffList[i],
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, ChatDetail.id,
                                                    arguments: {
                                                      'type': 'Chat',
                                                      'id':
                                                          staffList[i].staffID,
                                                      'data': staffList[i]
                                                    });
                                              }),
                                        ),
                                ),
                                SizedBox(
                                  height: height * 0.5,
                                  child: groupList.isEmpty
                                      ? Center(
                                          child: Text('No Data Found'),
                                        )
                                      : ListView.builder(
                                          itemCount: groupList.length,
                                          itemBuilder: (c, i) => chatContainer(
                                              height: height,
                                              width: width,
                                              name: groupList[i].name,
                                              imageSource:
                                                  groupList[i].imageSource,
                                              chat: groupList[i],
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, ChatDetail.id,
                                                    arguments: {
                                                      'type': 'Group',
                                                      'id':
                                                          groupList[i].staffID,
                                                      'data': groupList[i]
                                                    });
                                              }),
                                        ),
                                ),
                                SizedBox(
                                  height: height * 0.5,
                                  child: clientList.isEmpty
                                      ? Center(
                                          child: Text('No Data Found'),
                                        )
                                      : ListView.builder(
                                          itemCount: clientList.length,
                                          itemBuilder: (c, i) => chatContainer(
                                              height: height,
                                              width: width,
                                              name: clientList[i].name,
                                              imageSource:
                                                  clientList[i].imageSource,
                                              chat: clientList[i],
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, ChatDetail.id,
                                                    arguments: {
                                                      'type': 'Client',
                                                      'id':
                                                          clientList[i].staffID,
                                                      'data': clientList[i]
                                                    });
                                              }),
                                        ),
                                ),
                              ]),
                  ),

                  
                ),
                TabBar(
                    onTap: (_) {
                      setState(() {
                        _tabController.index;
                      });
                    },
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: ColorCollection.backColor),
                    tabs: [
                      _tabController.index != 0
                          ? Tab(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 5)
                                    ]),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(KeyValues.staff),
                                ),
                              ),
                            )
                          : Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(KeyValues.staff),
                              ),
                            ),
                      _tabController.index != 1
                          ? Tab(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 5)
                                    ]),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(KeyValues.group),
                                ),
                              ),
                            )
                          : Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(KeyValues.group),
                              ),
                            ),
                      _tabController.index != 2
                          ? Tab(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 7)
                                    ]),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(KeyValues.Client),
                                ),
                              ),
                            )
                          : Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(KeyValues.Client),
                              ),
                            ),
                    ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget chatContainer(
      {required double height,
      required double width,
      required String name,
      required String imageSource,
      required ChatItems chat,
      Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2),
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
                    'https://ppscs.io/crm/uploads/staff_profile_images/${chat.staffID}/thumb_$imageSource',
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
              SizedBox(
                width: width * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: width * 0.7,
                      child: Marquee(
                          child:
                              Text(name, style: ColorCollection.titleStyle))),
                  SizedBox(
                    height: height * 0.005,
                  ),
                  // Row(
                  //   children: [
                  //     chat.unreadCount == 0
                  //         ? Icon(
                  //             Icons.done_all,
                  //             color: ColorCollection.backColor,
                  //           )
                  //         : CircleAvatar(
                  //             radius: 8,
                  //             backgroundColor: ColorCollection.green,
                  //             child: Text(
                  //               chat.unreadCount.toString(),
                  //               style: TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 9,
                  //                   fontWeight: FontWeight.bold),
                  //             ),
                  //           ),
                  //     Text(
                  //       message,
                  //       style: ColorCollection.subTitleStyle,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              Spacer(),
              //   Column(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       // Text(time, style: ColorCollection.titleStyle),
              //       SizedBox(
              //         height: height * 0.01,
              //       ),
              //       Icon(
              //         Icons.circle,
              //         size: 7,
              //         color: ColorCollection.green,
              //       ),
              //     ],
              //   ),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Divider()
        ],
      ),
    );
  }
}

class ChatItems {
  final String firstName;
  final String lastName;
  final String name;
  final String staffID;
  // final String message;
  final String imageSource;
  // final String time;
  // final bool isRead;
  // final int unreadCount;

  ChatItems({
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.staffID,
    // required this.message,
    required this.imageSource,
    // required this.time,
    // required this.isRead,
    // required this.unreadCount
  });
}
