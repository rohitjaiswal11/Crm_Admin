// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Tasks/task_detail_screen.dart';

class CommanClass {
  static NumberFormat Cr = NumberFormat("#,##0.00", "en_US");
  static bool notifcationTapped = false;
  static RemoteMessage? noticationMessage;
  static String StaffId = '';
  static String AccountID = "";
  static String LeadUpdateNew = "New";
  static List LeadData = [];
  static bool isFilter = false;
  static String DateAdded = '';
  static String DateAssigned = '';
  static String DateLastContact = '';
  static String DateConverted = '';
  static String DateLastStatus = '';
  static List CustomFieldData = [];
  static List limitList = ['10', '20', '50', '100', 'All'];
  static String CustomerID = '';
  static bool taskDetailfirtsTime = true;
  static bool dashBoardfirtsTime = true;
  static String FileURL = '';
  static File? UploadFile;
  static List<MultiFileClass> multiFileList = [];
  static String? HeaderLogo;
  static bool isLogin = false;
  static bool showSupport = false;
  static bool showTask = false;
  static bool showProjects = false;
  static String UploadFilename = '';
  static String DownloadPath = '';
  static String CheckResponse = '';
  static double header_textsize = 15.0;
  static double body_textsize = 12.0;
  static int TimeInterval = 600;

  ///Invoice Create--
  static String Customername = 'Select One';
  static String Customerid = '';
  static String Billing_street = '';
  static String Billing_state = '';
  static String Billing_city = '';
  static String Billing_country = '';
  static String Billing_zip = '';
  static String Shipping_street = '';
  static String Shipping_city = '';
  static String Shipping_state = '';
  static String Shipping_country = '';
  static String Shipping_zip = '';
  static String InvNo = "";
  static String selectedInvoiceCurrency = '';
  static String selectedEstimateCurrency = '';
  static int selectedEstimateStatus = 0;
  static String selectedEstimatepayment = '';
  static String selectedInvoicepayment = '';
  static String currentDate = '';
  static String dueDate = '';
  static String selectedValuesJson = '';
  static String selectsaleagent = '';
  static String recInvoice = "";
  static String adminNote = "";
  static String tags = "";
  static String discountType = '';
  static String appLockStatus = 'lock';
  //
  // static String additem = "";
  // static String longdesscription = "";
  // static String rate = "";
  static String qty = '';
  static String tax = '';
  static int sum = 0;
  static int percent = 0;
  static int total = 0;
  static int TotalPrice = 0;

  static String Discount = "00";
  static String Adjustment = "00";
  static String JsonList = '';

  ///Proposal
  static String Related = '';
  static String SelectRelation = '';
  static String CustomerName = '';
  static String itemselect = '';
  static String userid = '';
  static String address = '';
  static String email = '';
  static String zip = '';
  static String country = '';
  static String country_id = '';
  static String state = '';
  static String city = '';
  static String phone_num = '';

  ///Task
  static String assigneeid = '';
  static String remid = '';
  static String remname = '';
  static String statusid = '';
  static String priorityid = '';
  static String followerid = '';

  ///Expense
  static String currency_exp = '';
  static String tax_exp = '';
  static String project_exp = '';
  static String payment_exp = '';
  static String repeat_exp = '';
  static var navigatingData;

  ///////////////////    NEW     ////////////////////////

  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
  static bool speechEnabled = false;
}
