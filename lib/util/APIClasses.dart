// ignore_for_file: non_constant_identifier_names, file_names, slash_for_doc_comments

import 'package:lbm_crm/util/LicenceKey.dart';

class APIClasses {
  static String BaseURL = Base_Url_For_App; // Base Url
  static String api_key = Api_Key_by_Admin; //authtoken Key

  static String APPBaseURL = 'crm.lbmdemo.com/crm';
//
//
//
//

  static String LoginAPI = "/crm/api/Auth_user"; // Get - username,password

  //
  static String LeadShow = "/crm/api/leads"; //  /* *** Done *** */
  // Get - staff_id,view_all,limit,start,status,order_by=type any filed , asc / desc ,start_date,end_date,lead_id
  static String CreateLead = "/crm/api/leads"; //  /* *** Done *** */
  //Post - name,source,status,assigned,tags,title,email,website,phonenumber,company,address,city,zip,state,default_language,
  //description,custom_contact_date,is_public,contacted_today
  static String GetLeadStatus = "/crm/api/Get_lead_status"; //  /* *** Done *** */
  static String LeadSearch = "/crm/api/leads/search"; //  /* *** Done *** */
  //Get - type=tag / sources / status
  static String AddLeadReminderNotes = "/crm/api/Lead_notes"; //  /* *** Done *** */
  //Post -type=reminder / notes ,lead_id , description ,date_contacted,staff_id ,notify_by_email
  static String GetLeadReminderNotes = "/crm/api/Lead_notes"; //  /* *** Done *** */
  //Get - type =reminder / notes , lead_id
  static String GetLeadTask = "/crm/api/tasks"; // Get rel_id //  /* *** Done *** */
  static String GetDashboard = "/crm/api/dashboard"; //Get //  /* *** Done *** */
  static String GetProposalInvoice = "/crm/api/ProposalInvoice"; /* *** Done *** */

  // //Anouncement
  static String getAnnouncements = '/crm/api/Announcement'; /* *** Done *** */
  static String delAnnouncements =
      '/crm/api/Announcement/delete'; /* *** Done *** */

  //  Appointment
  static String grtAppointment = '/crm/api/Appointment'; /* *** Done *** */
  static String deleteAppointment =
      '/crm/api/Appointment/delete'; /* *** Done *** */
  static String getUpdateAppointment =
      '/crm/api/Appointment/dataupdate'; /* *** Done *** */
  static String getviewAppointment = '/crm/api/Appointment/view'; /* *** Done *** */
  static String getcontact = '/crm/api/Appointment/fetchcontact'; /* *** Done *** */

  //Contract
  static String getContract = '/crm/api/Contact'; /* *** Done *** */
  static String getCustomer = '/crm/api/Contact/insertinfo'; /* *** Done *** */
  static String deleteContract = '/crm/api/Contact/delete'; /* *** Done *** */

  //Task
  static String getask = '/crm/api/tasks';
  static String getaskFollower = '/crm/api/tasks/taskfollowers';
  static String getassignee = '/crm/api/tasks/stafflist';
  static String addassignee = '/crm/api/tasks/addtaskassignees';
  static String status = '/crm/api/tasks/TaskStatus';
  static String priority = '/crm/api/tasks/TaskPriority';
  static String update = '/crm/api/tasks/taskupdate';
  static String starttimer = '/crm/api/Tasks/timertracking';
  static String relateddata = '/crm/api/tasks/taskreleated';

//Proposal
  static String New_Proposal = '/crm/api/Proposal/customer';
  static String Create_Proposal = '/crm/api/Proposal';
  static String Relation_Data = '/crm/api/Proposal/relationdata';
  static String Country = '/crm/api/Others/countries';

  //
//Invoice
  static String New_Invoice = "/crm/api/Invoice/customer";
  static String Create_Invoice = "/crm/api/Invoice";

//Estimates
  static String New_Estimate = '/crm/api/Estimate/customer';
  static String Create_Estimate = '/crm/api/Estimate';

  //Expense
  static String getExpense = '/crm/api/Expense';
  static String getinfoExpense = '/crm/api/Expense/expenseinfo';
  static String delExpense = '/crm/api/Expense/delete';

  //
  static String UpdateLead = "/crm/api/leads/update"; // Post
  static String GetLeadProposal = "/crm/api/proposal"; // Get rel_id

//Customer
  static String GetCustomerDashboard = "/crm/api/Customers"; //  /* *** Done *** */
  static String GetCustomerDetail = "/crm/api/Customersdetail"; /* *** Done *** */
  static String GetTicketDetail = "/crm/api/Tickets";
  static String GetTicketDetailReply = "/crm/api/Tickets/ticketreply";
  static String GetCustomField = "/crm/api/Customers/Customfield";
  static String GetVisiabletoCustomer = "/crm/api/Filesupload/visibletocustomer";
  static String GetFileUpload = "/crm/api/Filesupload";
  //Support
  static String GetSupportAll = "/crm/api/Tickets/All";

//MasterSearch
  static String GetMasterSearch = "/crm/api/Mastersearch";

//Chat 
  static String chatList = "/crm/api/prchat/users";
  static String oldMessages = "/crm/api/prchat/oldmessage";
  static String sendSingleMessage = "/crm/api/prchat/sendsingle";
  static String sendClientMessage = "/crm/api/prchat/sendClientChat";
  static String sendgroupMessage = "/crm/api/prchat/sendGroupChat";
  static String updateUnread = "/crm/api/prchat/updateunread";
  static String updateUnreadClient = "/crm/api/prchat/updateUnreadClient";
//Location
  static String addLocation = "/crm/api/locations";
}
