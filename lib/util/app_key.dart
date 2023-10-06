// ignore_for_file: finalant_identifier_names, non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class KeyValues extends ChangeNotifier {
  //Dashoboard Screen
  // static String lbm = 'LBM'.tr();
  // static String solutions = 'SOLUTIONS'.tr();
  static String leads = 'Leads'.tr(); //page title
  static String invoice = 'Invoice'.tr();
  static String seeall = 'See all'.tr();
  // Tab bar titles
  static String leadsoverview = 'LEADS OVERVIEW'.tr();
  static String peojectStatus = 'PROJECT STATUS'.tr();
  static String status = 'Status'.tr();

  //Lead Screen
  static String filter = 'Filter'.tr();
  static String sortA_Z = 'A-Z Sort'.tr();
  static String sortZ_A = 'Z-A Sort'.tr();
  static String company = 'Company'.tr();
  static String added = 'Added'.tr();

  // Lead Detail Screen

  static String billingAddress = 'Billing Address'.tr();
  static String source = 'Source'.tr();
  static String lastcontact = 'Last Contact'.tr();
  static String lastStatusChange = 'Last Status Change'.tr();
  static String lastLeadStatus = 'Last Lead Status'.tr();
  static String staffName = 'Staff Name'.tr();

  static String notes = 'Notes'.tr();
  static String tasks = 'Tasks'.tr();
  static String reminders = 'Reminders'.tr();

  //Tab Bar titles
  static String related = 'Related'.tr();
  static String proposal = 'Proposal'.tr();
  static String detail = 'Detail'.tr();

  //Add Estimate Screen
  static String addEstimate = 'Add Estimate'.tr(); //page title
  static String Customer = 'Customer'.tr();
  static String InvoiceNumber = 'Invoice Number'.tr();
  static String estimateDate = 'Estimate Date'.tr();
  static String expiryDate = 'Expire Date'.tr();
  static String currency = 'Currency'.tr();
  static String reference = 'Reference'.tr();
  static String saleAgent = 'Sale Agent'.tr();
  static String discount = 'Discount'.tr();
  static String adminNote = 'Admin Note'.tr();
  static String totalItem = 'Total Item'.tr();
  static String chooseItem = 'Choose Item'.tr();
  static String selectone = 'Select One'.tr();
  static String selectInvoiceDate = 'Select Invoice Date'.tr();
  static String selectCurrency = 'Select Currency'.tr();
  static String selectStatus = 'Select Status'.tr();
  static String selectSaleAgent = 'Select Sale Agent'.tr();
  static String select = 'Select'.tr();

  static String addItem = 'Add Item'.tr();
  static String submit = 'Submit'.tr(); //submit button

  // Invoice Screen

  static String dueAmount = 'Due Amount'.tr();
  static String totalAmount = 'Total Amount'.tr();

  // Add Invoice Screen

  static String addinvoice = 'Add Invoice'.tr();
  static String invoiceDate = 'Invoice Date'.tr();
  static String preventSending =
      'Prevent Sending Overdue Reminders For This Invoice'.tr();
  static String allowPayment = 'Allow payment modes for this invoice'.tr();
  static String recuring = 'Recurring Invoice'.tr();

  //Invoice Detail Screen

  static String invoices = 'Invoices'.tr(); //page title
  static String invocieDate = 'Invoice Date'.tr();
  static String dueDate = 'Due Date'.tr();
  static String shippingAddress = 'Shipping Address'.tr();
  static String address = 'Address'.tr();
  static String country = 'Country'.tr();
  static String items = 'ITEMS'.tr();
  static String subTotal = 'Sub Total'.tr();
  static String total = 'Total'.tr();
  static String qty = 'QTY'.tr();
  static String amount = 'Amount'.tr();
  static String igst = 'IGST'.tr();

  static String totalPaid = 'Total Paid'.tr();
  static String viewPdf = 'View PDF'.tr(); //button

  // Add new Announcement

  static String addannouncement = 'Add Announcement'.tr();
  static String subject = 'Subject'.tr();
  static String searchTask = 'Search Task'.tr();

  //checkboxes
  static String showToStaff = 'Show to Staff'.tr();
  static String showToClient = 'Show to Client'.tr();
  static String showMyName = 'Show my Name'.tr();

  // Announcement Screen
  static String announcement = 'Announcements'.tr();
  static String name = 'Name'.tr();
  static String date = 'Date'.tr();

  // Add New Appointment
  static String appointment = 'Appointment'.tr(); //page title
  static String description = 'Description'.tr();
  static String datetime = 'Date/Time'.tr();
  static String locatoin = 'Location'.tr();
  static String attendees = 'Attendees'.tr();
  static String enterSubject = 'Enter Subject'.tr();
  static String selectDate = 'Select Date'.tr();
  static String yourtexthere = 'Your Text Here...'.tr();
  static String nothingSelected = 'Nothing Selected'.tr();
  static String selectfollower = ' Select Follower'.tr();
  static String smsNotificatoin = 'SMS Notification'.tr();
  static String emailNotification = 'Email Notification'.tr();

  // Add new Contract

  static String newContracts = 'New Contracts'.tr();
  static String public = 'Public'.tr();
  static String private = 'Private'.tr();
  static String Subjecthint = 'Please enter the subject'.tr();
  static String contractValue = 'Contract Value'.tr();
  static String contractType = 'Contract Type'.tr();
  static String startDate = 'Start Date'.tr();
  static String endDate = 'End Date'.tr();
  static String deschint = 'Please enter the description'.tr();
  static String save = 'Save'.tr();

  // Contracts Screen

  static String contracts = 'Contracts'.tr();
  static String searchText = 'Search Text'.tr();
  static String project = 'Project'.tr();
  static String signature = 'Signature'.tr();

  //Add new Customers

  static String addNewCustomer = 'Add New Customer'.tr();
  static String enterDetails = 'Enter the details asked below'.tr();
  static String companyName = 'Comapny Name'.tr();
  static String website = 'Website'.tr();
  static String gstnumber = 'GSTIN Number'.tr();
  static String phoneNumber = 'Phone Number'.tr();
  static String groups = 'Groups'.tr();
  static String search = 'Search'.tr();
  static String systemDefault = 'System Default'.tr();
  static String city = 'City'.tr();
  static String street = 'Street'.tr();
  static String state = 'State'.tr();
  static String zipCode = 'ZIp Code'.tr();
  static String sameAs = 'Same As'.tr();
  static String fields = 'Fields'.tr();

  // Customers Screen
  static String customers = 'Customers'.tr();
  static String searchCustomers = 'Search Customers'.tr();
  static String excludeInactive = 'Exclude Inactive Customers'.tr();

  // Customer Detail Screen
  static String details = 'Details'.tr();
  static String contacts = 'Contacts'.tr();
  static String performa = 'Performa Invoices'.tr();
  static String estimates = 'Estimates'.tr();
  static String projects = 'Projects'.tr();
  static String tickets = 'Tickets'.tr();
  static String Files = 'Files'.tr();
  static String searchContacts = 'Search Contacts'.tr();
  static String searchNotes = 'Search Notes'.tr();
  static String searchPerforma = 'Search Performa'.tr();
  static String searchEstimates = 'Search Estimates'.tr();
  static String searchProjects = 'Search Projects'.tr();
  static String searchTickets = 'Search Tickets'.tr();
  static String searchFiles = 'Search Files'.tr();
  static String searchReminders = 'Search Reminders'.tr();
  static String gst = 'GST'.tr();
  static String lastLogin = 'Last Login'.tr();

  // Add new expenses
  static String addnewexpenses = 'Add New Expenses'.tr();
  static String attachReciept = 'Attach Reciept'.tr();
  static String note = 'Note'.tr();
  static String expenseCategory = 'Expense Category'.tr();
  static String expenseDate = 'Expense Date'.tr();
  static String selectExpenseDate = 'Select Expense Date'.tr();

  static String advancedOptions = 'Advanced Options'.tr();
  static String tax1 = 'Tax 1'.tr();
  static String tax2 = 'Tax 2'.tr();
  static String paymentMode = 'Payment Mode'.tr();
  static String repeat = 'Repeat'.tr();

  // Expenses Screen
  static String expenses = 'EXPENSES'.tr();
  static String searchExpenses = 'Search Expenses'.tr();
  static String category = 'Category'.tr();

  //Add New Lead

  static String title = 'Title'.tr();
  static String Company = 'Company Name'.tr();
  static String cityName = 'City Name'.tr();
  static String language = 'Language'.tr();
  static String stateName = 'State Name'.tr();
  static String selectTags = 'Select Tags'.tr();
  static String selectAssigned = 'Select Assigned'.tr();
  static String selectLanguage = 'Select Language'.tr();
  static String selectSource = 'Select Source'.tr();
  static String selectContactDate = 'Select Contact Date'.tr();
  static String selectContactToday = 'Select Contact Today'.tr();

  //Add new Proposals

  static String addNewProposal = 'ADD NEW PROPOSALS'.tr();
  static String allowComment = 'Allow Comment'.tr();
  static String openTill = 'Open Till'.tr();
  static String discountType = 'Discount Type'.tr();
  static String assigned = 'Assigned'.tr();
  static String To = 'To'.tr();
  static String Email = 'Email'.tr();
  static String Phone = 'Phone'.tr();

  // Proposals Screen
  static String proposals = 'PROPOSALS'.tr();
  static String proposalTo = 'Proposal-TO'.tr();

  // Add New Tasks
  static String addnewTAsk = 'ADD NEW TASKS'.tr();
  static String billable = 'Billable'.tr();
  static String hourlyRate = 'Hourly Rate'.tr();
  static String enterHourlyRate = 'Enter Hourly Rate'.tr();
  static String repeatEvery = 'Repeat Every'.tr();
  static String selectPriority = 'Select Priority'.tr();
  static String relatedTo = 'Related To'.tr();
  static String tags = 'Tags'.tr();
  static String cancel = 'Cancel'.tr();

  //Tasks Detail Screen
  static String startTimer = 'Start Timer'.tr();
  static String checkListItems = 'CheckList Items'.tr();
  static String comments = 'Comments'.tr();

  //Add New Ticket
  static String addnewTicket = 'ADD NEW TICKET'.tr();
  static String emailAddress = 'Email Address'.tr();
  static String department = 'Department'.tr();
  static String cc = 'CC'.tr();
  static String assignticket = 'Assign Ticket (default is current user)'.tr();
  static String selectService = 'Select Service'.tr();
  static String projHint = 'Select and begin typing'.tr();
  static String ticketBody = 'Ticket Body'.tr();
  static String tickethint = 'Insert Predefined Reply'.tr();
  static String nofile = 'No File'.tr();
  static String selectImage = 'Select Image'.tr();
  static String camera = 'Camera'.tr();
  static String gallery = 'Gallery'.tr();

  // Support Screen
  static String support = 'SUPPORT'.tr();
  static String dept = 'Dept.'.tr();
  static String lastReply = 'Last Reply'.tr();

  //Payment Detail Screen
  static String payment = 'PAYMENT'.tr();
  static String mode = 'Mode'.tr();
  static String paymentDate = 'Payment Date'.tr();
  static String paymentReciept = 'Payment Reciept'.tr();
  static String amountDue = 'Amount Due'.tr();
  static String paymentAmount = 'Payment Amount'.tr();
  static String invoiceAmount = 'Invoice Amount'.tr();

  //Projects Screen

  static String deadlineDate = 'DeadLine Date'.tr();
  static String CreateDate = 'Create Date'.tr();
  static String finishedLine = 'Finished Line'.tr();

  //Project Detail Screen

  static String billingType = 'Billing Type'.tr();
  static String totalRate = 'Total Rate'.tr();
  static String deadline = 'Deadline'.tr();
  static String domainName = 'Domain Name'.tr();
  static String members = 'Members'.tr();
  static String projectOverView = 'Project Overview'.tr();

  static String discussion = 'Discussion'.tr();

  // Chat Screen
  static String chat = 'Chat'.tr();
  static String staff = 'Staff'.tr();
  static String group = 'Group'.tr();
  static String Client = 'Client'.tr();

  //
  static String download = 'Download'.tr();
  static String reply = 'Reply'.tr();
  static String createdAt = 'Created At'.tr();
  static String expired = 'Expired'.tr();

  // Proposal Detail Screen
  static String summary = 'Summary'.tr();
  static String personalInfo = 'Personal Informaton'.tr();
  static String newTask = 'New Task'.tr();
  static String newNotes = 'New Notes'.tr();
  static String newReminder = 'New Reminder'.tr();
  static String priority = 'Priority'.tr();
  static String emailReminder = 'Send Reminder On Email'.tr();

  static String gotInTouch = 'I Got in Touch With This Lead'.tr();
  static String notConnected = 'I Have Not Connected This Lead'.tr();

  ///
  ///
  static String settings = 'Settings'.tr();
  static String themeChanger = 'Theme Changer'.tr();
  static String resetColors = 'Reset Colors'.tr();
  static String passCode = 'Passcode'.tr();
  static String changePasscode = 'Change Passcode'.tr();
  static String enterPasscode = 'Enter Passcode'.tr();
  static String createPasscode = 'Create Passcode'.tr();
  static String confirmPasscode = 'Confirm Passcode'.tr();
  static String next = 'Next'.tr();
  static String resetApp = 'Reset App'.tr();

  /// Add New Project ////////

  static String newProject = 'New Projects'.tr();

  ///
/////
////
////
////
////
////
////
////
////
  ///
  changeTodefault() {
    // KeyValues.lbm = 'LBM';
    // KeyValues.solutions = 'SOLUTIONS';
    KeyValues.leads = 'Leads'; //page title
    KeyValues.invoice = 'Invoice';
    KeyValues.seeall = 'See all';
    // Tab bar titles
    KeyValues.leadsoverview = 'LEADS OVERVIEW';
    KeyValues.peojectStatus = 'PROJECT STATUS';
    KeyValues.status = 'Status';

    //Lead Screen
    KeyValues.filter = 'Filter';
    KeyValues.sortA_Z = 'A-Z Sort';
    KeyValues.sortZ_A = 'Z-A Sort';
    KeyValues.company = 'Company';
    KeyValues.added = 'Added';

    // Lead Detail Screen

    KeyValues.billingAddress = 'Billing Address';
    KeyValues.source = 'Source';
    KeyValues.lastcontact = 'Last Contact';
    KeyValues.lastStatusChange = 'Last Status Change';
    KeyValues.lastLeadStatus = 'Last Lead Status';
    KeyValues.staffName = 'Staff Name';

    KeyValues.notes = 'Notes';
    KeyValues.tasks = 'Tasks';
    KeyValues.reminders = 'Reminders';

    //Tab Bar titles
    KeyValues.related = 'Related';
    KeyValues.proposal = 'Proposal';
    KeyValues.detail = 'Detail';

    //Add Estimate Screen
    KeyValues.addEstimate = 'Add Estimate'; //page title
    KeyValues.Customer = 'Customer';
    KeyValues.InvoiceNumber = 'Invoice Number';
    KeyValues.estimateDate = 'Estimate Date';
    KeyValues.expiryDate = 'Expire Date';
    KeyValues.currency = 'Currency';
    KeyValues.reference = 'Reference';
    KeyValues.saleAgent = 'Sale Agent';
    KeyValues.discount = 'Discount';
    KeyValues.adminNote = 'Admin Note';
    KeyValues.totalItem = 'Total Item';
    KeyValues.chooseItem = 'Choose Item';
    KeyValues.selectone = 'Select One';
    KeyValues.selectInvoiceDate = 'Select Invoice Date';
    KeyValues.selectCurrency = 'Select Currency';
    KeyValues.selectStatus = 'Select Status';
    KeyValues.selectSaleAgent = 'Select Sale Agent';
    KeyValues.select = 'Select';

    KeyValues.addItem = 'Add Item';
    KeyValues.submit = 'Submit'; //submit button

    // Invoice Screen

    KeyValues.dueAmount = 'Due Amount';
    KeyValues.totalAmount = 'Total Amount';

    // Add Invoice Screen

    KeyValues.addinvoice = 'Add Invoice';
    KeyValues.invoiceDate = 'Invoice Date';
    KeyValues.preventSending =
        'Prevent Sending Overdue Reminders For This Invoice';
    KeyValues.allowPayment = 'Allow payment modes for this invoice';
    KeyValues.recuring = 'Recurring Invoice';

    //Invoice Detail Screen

    KeyValues.invoices = 'Invoices'; //page title
    KeyValues.invocieDate = 'Invoice Date';
    KeyValues.dueDate = 'Due Date';
    KeyValues.shippingAddress = 'Shipping Address';
    KeyValues.address = 'Address';
    KeyValues.country = 'Country';
    KeyValues.items = 'ITEMS';
    KeyValues.subTotal = 'Sub Total';
    KeyValues.total = 'Total';
    KeyValues.qty = 'QTY';
    KeyValues.amount = 'Amount';
    KeyValues.igst = 'IGST';

    KeyValues.totalPaid = 'Total Paid';
    KeyValues.viewPdf = 'View PDF'; //button

    // Add new Announcement

    KeyValues.addannouncement = 'Add Announcement';
    KeyValues.subject = 'Subject';
    KeyValues.searchTask = 'Search Task';

    //checkboxes
    KeyValues.showToStaff = 'Show to Staff';
    KeyValues.showToClient = 'Show to Client';
    KeyValues.showMyName = 'Show my Name';

    // Announcement Screen
    KeyValues.announcement = 'Announcements';
    KeyValues.name = 'Name';
    KeyValues.date = 'Date';

    // Add New Appointment
    KeyValues.appointment = 'Appointment'; //page title
    KeyValues.description = 'Description';
    KeyValues.datetime = 'Date/Time';
    KeyValues.locatoin = 'Location';
    KeyValues.attendees = 'Attendees';
    KeyValues.enterSubject = 'Enter Subject';
    KeyValues.selectDate = 'Select Date';
    KeyValues.yourtexthere = 'Your Text Here...';
    KeyValues.nothingSelected = 'Nothing Selected';
    KeyValues.selectfollower = ' Select Follower';
    KeyValues.smsNotificatoin = 'SMS Notification';
    KeyValues.emailNotification = 'Email Notification';

    // Add new Contract

    KeyValues.newContracts = 'New Contracts';
    KeyValues.public = 'Public';
    KeyValues.private = 'Private';
    KeyValues.Subjecthint = 'Please enter the subject';
    KeyValues.contractValue = 'Contract Value';
    KeyValues.contractType = 'Contract Type';
    KeyValues.startDate = 'Start Date';
    KeyValues.endDate = 'End Date';
    KeyValues.deschint = 'Please enter the description';
    KeyValues.save = 'Save';

    // Contracts Screen

    KeyValues.contracts = 'Contracts';
    KeyValues.searchText = 'Search Text';
    KeyValues.project = 'Project';
    KeyValues.signature = 'Signature';

    //Add new Customers

    KeyValues.addNewCustomer = 'Add New Customer';
    KeyValues.enterDetails = 'Enter the details asked below';
    KeyValues.companyName = 'Comapny Name';
    KeyValues.website = 'Website';
    KeyValues.gstnumber = 'GSTIN Number';
    KeyValues.phoneNumber = 'Phone Number';
    KeyValues.groups = 'Groups';
    KeyValues.search = 'Search';
    KeyValues.systemDefault = 'System Default';
    KeyValues.city = 'City';
    KeyValues.street = 'Street';
    KeyValues.state = 'State';
    KeyValues.zipCode = 'ZIp Code';
    KeyValues.sameAs = 'Same As';
    KeyValues.fields = 'Fields';

    // Customers Screen
    KeyValues.customers = 'Customers';
    KeyValues.searchCustomers = 'Search Customers';
    KeyValues.excludeInactive = 'Exclude Inactive Customers';

    // Customer Detail Screen
    KeyValues.details = 'Details';
    KeyValues.contacts = 'Contacts';
    KeyValues.performa = 'Performa Invoices';
    KeyValues.estimates = 'Estimates';
    KeyValues.projects = 'Projects';
    KeyValues.tickets = 'Tickets';
    KeyValues.Files = 'Files';
    KeyValues.searchContacts = 'Search Contacts';
    KeyValues.searchNotes = 'Search Notes';
    KeyValues.searchPerforma = 'Search Performa';
    KeyValues.searchEstimates = 'Search Estimates';
    KeyValues.searchProjects = 'Search Projects';
    KeyValues.searchTickets = 'Search Tickets';
    KeyValues.searchFiles = 'Search Files';
    KeyValues.searchReminders = 'Search Reminders';
    KeyValues.gst = 'GST';
    KeyValues.lastLogin = 'Last Login';

    // Add new expenses
    KeyValues.addnewexpenses = 'Add New Expenses';
    KeyValues.attachReciept = 'Attach Reciept';
    KeyValues.note = 'Note';
    KeyValues.expenseCategory = 'Expense Category';
    KeyValues.expenseDate = 'Expense Date';
    KeyValues.selectExpenseDate = 'Select Expense Date';

    KeyValues.advancedOptions = 'Advanced Options';
    KeyValues.tax1 = 'Tax 1';
    KeyValues.tax2 = 'Tax 2';
    KeyValues.paymentMode = 'Payment Mode';
    KeyValues.repeat = 'Repeat';

    // Expenses Screen
    KeyValues.expenses = 'EXPENSES';
    KeyValues.searchExpenses = 'Search Expenses';
    KeyValues.category = 'Category';

    //Add New Lead

    KeyValues.title = 'Title';
    KeyValues.Company = 'Company Name';
    KeyValues.cityName = 'City Name';
    KeyValues.language = 'Language';
    KeyValues.stateName = 'State Name';
    KeyValues.selectTags = 'Select Tags';
    KeyValues.selectAssigned = 'Select Assigned';
    KeyValues.selectLanguage = 'Select Language';
    KeyValues.selectSource = 'Select Source';
    KeyValues.selectContactDate = 'Select Contact Date';
    KeyValues.selectContactToday = 'Select Contact Today';

    //Add new Proposals

    KeyValues.addNewProposal = 'ADD NEW PROPOSALS';
    KeyValues.allowComment = 'Allow Comment';
    KeyValues.openTill = 'Open Till';
    KeyValues.discountType = 'Discount Type';
    KeyValues.assigned = 'Assigned';
    KeyValues.To = 'To';
    KeyValues.Email = 'Email';
    KeyValues.Phone = 'Phone';

    // Proposals Screen
    KeyValues.proposals = 'PROPOSALS';
    KeyValues.proposalTo = 'Proposal-TO';

    // Add New Tasks
    KeyValues.addnewTAsk = 'ADD NEW TASKS';
    KeyValues.billable = 'Billable';
    KeyValues.hourlyRate = 'Hourly Rate';
    KeyValues.enterHourlyRate = 'Enter Hourly Rate';
    KeyValues.repeatEvery = 'Repeat Every';
    KeyValues.selectPriority = 'Select Priority';
    KeyValues.relatedTo = 'Related To';
    KeyValues.tags = 'Tags';
    KeyValues.cancel = 'Cancel';

    //Tasks Detail Screen
    KeyValues.startTimer = 'Start Timer';
    KeyValues.checkListItems = 'CheckList Items';
    KeyValues.comments = 'Comments';

    //Add New Ticket
    KeyValues.addnewTicket = 'ADD NEW TICKET';
    KeyValues.emailAddress = 'Email Address';
    KeyValues.department = 'Department';
    KeyValues.cc = 'CC';
    KeyValues.assignticket = 'Assign Ticket (default is current user)';
    KeyValues.selectService = 'Select Service';
    KeyValues.projHint = 'Select and begin typing';
    KeyValues.ticketBody = 'Ticket Body';
    KeyValues.tickethint = 'Insert Predefined Reply';
    KeyValues.nofile = 'No File';
    KeyValues.selectImage = 'Select Image';
    KeyValues.camera = 'Camera';
    KeyValues.gallery = 'Gallery';

    // Support Screen
    KeyValues.support = 'SUPPORT';
    KeyValues.dept = 'Dept.';
    KeyValues.lastReply = 'Last Reply';

    //Payment Detail Screen
    KeyValues.payment = 'PAYMENT';
    KeyValues.mode = 'Mode';
    KeyValues.paymentDate = 'Payment Date';
    KeyValues.paymentReciept = 'Payment Reciept';
    KeyValues.amountDue = 'Amount Due';
    KeyValues.paymentAmount = 'Payment Amount';
    KeyValues.invoiceAmount = 'Invoice Amount';

    //Projects Screen

    KeyValues.deadlineDate = 'DeadLine Date';
    KeyValues.CreateDate = 'Create Date';
    KeyValues.finishedLine = 'Finished Line';

    //Project Detail Screen

    KeyValues.billingType = 'Billing Type';
    KeyValues.totalRate = 'Total Rate';
    KeyValues.deadline = 'Deadline';
    KeyValues.domainName = 'Domain Name';
    KeyValues.members = 'Members';
    KeyValues.projectOverView = 'Project Overview';

    KeyValues.discussion = 'Discussion';

    // Chat Screen
    KeyValues.chat = 'Chat';
    KeyValues.staff = 'Staff';
    KeyValues.group = 'Group';
    KeyValues.Client = 'Client';

    //
    KeyValues.download = 'Download';
    KeyValues.reply = 'Reply';
    KeyValues.createdAt = 'Created At';
    KeyValues.expired = 'Expired';

    // Proposal Detail Screen
    KeyValues.summary = 'Summary';
    KeyValues.personalInfo = 'Personal Informaton';
    KeyValues.newTask = 'New Task';
    KeyValues.newNotes = 'New Notes';
    KeyValues.newReminder = 'New Reminder';
    KeyValues.priority = 'Priority';
    KeyValues.emailReminder = 'Send Reminder On Email';

    KeyValues.gotInTouch = 'I Got in Touch With This Lead';
    KeyValues.notConnected = 'I Have Not Connected This Lead';

    ///

    KeyValues.settings = 'Settings';
    KeyValues.themeChanger = 'Theme Changer';
    KeyValues.resetColors = 'Reset Colors';
    KeyValues.passCode = 'Passcode';
    KeyValues.changePasscode = 'Change Passcode';
    KeyValues.enterPasscode = 'Enter Passcode';
    KeyValues.createPasscode = 'Create Passcode';
    KeyValues.confirmPasscode = 'Confirm Passcode';
    KeyValues.next = 'Next';
    KeyValues.resetApp = 'Reset App';

    /// Add New Projects
    KeyValues.newProject = 'New Projects';

    notifyListeners();
  }

  changeLang() {
    ////
    ///
    ///
    ///
    ////
    ////
    ///
    ///
    ///
    // KeyValues.lbm = 'LBM'.tr();
    // KeyValues.solutions = 'SOLUTIONS'.tr();
    KeyValues.leads = 'Leads'.tr(); //page title
    KeyValues.invoice = 'Invoice'.tr();
    KeyValues.seeall = 'See all'.tr();
    // Tab bar titles
    KeyValues.leadsoverview = 'LEADS OVERVIEW'.tr();
    KeyValues.peojectStatus = 'PROJECT STATUS'.tr();
    KeyValues.status = 'Status'.tr();

    //Lead Screen
    KeyValues.filter = 'Filter'.tr();
    KeyValues.sortA_Z = 'A-Z Sort'.tr();
    KeyValues.sortZ_A = 'Z-A Sort'.tr();
    KeyValues.company = 'Company'.tr();
    KeyValues.added = 'Added'.tr();

    // Lead Detail Screen

    KeyValues.billingAddress = 'Billing Address'.tr();
    KeyValues.source = 'Source'.tr();
    KeyValues.lastcontact = 'Last Contact'.tr();
    KeyValues.lastStatusChange = 'Last Status Change'.tr();
    KeyValues.lastLeadStatus = 'Last Lead Status'.tr();
    KeyValues.staffName = 'Staff Name'.tr();

    KeyValues.notes = 'Notes'.tr();
    KeyValues.tasks = 'Tasks'.tr();
    KeyValues.reminders = 'Reminders'.tr();

    //Tab Bar titles
    KeyValues.related = 'Related'.tr();
    KeyValues.proposal = 'Proposal'.tr();
    KeyValues.detail = 'Detail'.tr();

    //Add Estimate Screen
    KeyValues.addEstimate = 'Add Estimate'.tr(); //page title
    KeyValues.Customer = 'Customer'.tr();
    KeyValues.InvoiceNumber = 'Invoice Number'.tr();
    KeyValues.estimateDate = 'Estimate Date'.tr();
    KeyValues.expiryDate = 'Expire Date'.tr();
    KeyValues.currency = 'Currency'.tr();
    KeyValues.reference = 'Reference'.tr();
    KeyValues.saleAgent = 'Sale Agent'.tr();
    KeyValues.discount = 'Discount'.tr();
    KeyValues.adminNote = 'Admin Note'.tr();
    KeyValues.totalItem = 'Total Item'.tr();
    KeyValues.chooseItem = 'Choose Item'.tr();
    KeyValues.selectone = 'Select One'.tr();
    KeyValues.selectInvoiceDate = 'Select Invoice Date'.tr();
    KeyValues.selectCurrency = 'Select Currency'.tr();
    KeyValues.selectStatus = 'Select Status'.tr();
    KeyValues.selectSaleAgent = 'Select Sale Agent'.tr();
    KeyValues.select = 'Select'.tr();

    KeyValues.addItem = 'Add Item'.tr();
    KeyValues.submit = 'Submit'.tr(); //submit button

    // Invoice Screen

    KeyValues.dueAmount = 'Due Amount'.tr();
    KeyValues.totalAmount = 'Total Amount'.tr();

    // Add Invoice Screen

    KeyValues.addinvoice = 'Add Invoice'.tr();
    KeyValues.invoiceDate = 'Invoice Date'.tr();
    KeyValues.preventSending =
        'Prevent Sending Overdue Reminders For This Invoice'.tr();
    KeyValues.allowPayment = 'Allow payment modes for this invoice'.tr();
    KeyValues.recuring = 'Recurring Invoice'.tr();

    //Invoice Detail Screen

    KeyValues.invoices = 'Invoices'.tr(); //page title
    KeyValues.invocieDate = 'Invoice Date'.tr();
    KeyValues.dueDate = 'Due Date'.tr();
    KeyValues.shippingAddress = 'Shipping Address'.tr();
    KeyValues.address = 'Address'.tr();
    KeyValues.country = 'Country'.tr();
    KeyValues.items = 'ITEMS'.tr();
    KeyValues.subTotal = 'Sub Total'.tr();
    KeyValues.total = 'Total'.tr();
    KeyValues.qty = 'QTY'.tr();
    KeyValues.amount = 'Amount'.tr();
    KeyValues.igst = 'IGST'.tr();

    KeyValues.totalPaid = 'Total Paid'.tr();
    KeyValues.viewPdf = 'View PDF'.tr(); //button

    // Add new Announcement

    KeyValues.addannouncement = 'Add Announcement'.tr();
    KeyValues.subject = 'Subject'.tr();
    KeyValues.searchTask = 'Search Task'.tr();

    //checkboxes
    KeyValues.showToStaff = 'Show to Staff'.tr();
    KeyValues.showToClient = 'Show to Client'.tr();
    KeyValues.showMyName = 'Show my Name'.tr();

    // Announcement Screen
    KeyValues.announcement = 'Announcements'.tr();
    KeyValues.name = 'Name'.tr();
    KeyValues.date = 'Date'.tr();

    // Add New Appointment
    KeyValues.appointment = 'Appointment'.tr(); //page title
    KeyValues.description = 'Description'.tr();
    KeyValues.datetime = 'Date/Time'.tr();
    KeyValues.locatoin = 'Location'.tr();
    KeyValues.attendees = 'Attendees'.tr();
    KeyValues.enterSubject = 'Enter Subject'.tr();
    KeyValues.selectDate = 'Select Date'.tr();
    KeyValues.yourtexthere = 'Your Text Here...'.tr();
    KeyValues.nothingSelected = 'Nothing Selected'.tr();
    KeyValues.selectfollower = ' Select Follower'.tr();
    KeyValues.smsNotificatoin = 'SMS Notification'.tr();
    KeyValues.emailNotification = 'Email Notification'.tr();

    // Add new Contract

    KeyValues.newContracts = 'New Contracts'.tr();
    KeyValues.public = 'Public'.tr();
    KeyValues.private = 'Private'.tr();
    KeyValues.Subjecthint = 'Please enter the subject'.tr();
    KeyValues.contractValue = 'Contract Value'.tr();
    KeyValues.contractType = 'Contract Type'.tr();
    KeyValues.startDate = 'Start Date'.tr();
    KeyValues.endDate = 'End Date'.tr();
    KeyValues.deschint = 'Please enter the description'.tr();
    KeyValues.save = 'Save'.tr();

    // Contracts Screen

    KeyValues.contracts = 'Contracts'.tr();
    KeyValues.searchText = 'Search Text'.tr();
    KeyValues.project = 'Project'.tr();
    KeyValues.signature = 'Signature'.tr();

    //Add new Customers

    KeyValues.addNewCustomer = 'Add New Customer'.tr();
    KeyValues.enterDetails = 'Enter the details asked below'.tr();
    KeyValues.companyName = 'Comapny Name'.tr();
    KeyValues.website = 'Website'.tr();
    KeyValues.gstnumber = 'GSTIN Number'.tr();
    KeyValues.phoneNumber = 'Phone Number'.tr();
    KeyValues.groups = 'Groups'.tr();
    KeyValues.search = 'Search'.tr();
    KeyValues.systemDefault = 'System Default'.tr();
    KeyValues.city = 'City'.tr();
    KeyValues.street = 'Street'.tr();
    KeyValues.state = 'State'.tr();
    KeyValues.zipCode = 'ZIp Code'.tr();
    KeyValues.sameAs = 'Same As'.tr();
    KeyValues.fields = 'Fields'.tr();

    // Customers Screen
    KeyValues.customers = 'Customers'.tr();
    KeyValues.searchCustomers = 'Search Customers'.tr();
    KeyValues.excludeInactive = 'Exclude Inactive Customers'.tr();

    // Customer Detail Screen
    KeyValues.details = 'Details'.tr();
    KeyValues.contacts = 'Contacts'.tr();
    KeyValues.performa = 'Performa Invoices'.tr();
    KeyValues.estimates = 'Estimates'.tr();
    KeyValues.projects = 'Projects'.tr();
    KeyValues.tickets = 'Tickets'.tr();
    KeyValues.Files = 'Files'.tr();
    KeyValues.searchContacts = 'Search Contacts'.tr();
    KeyValues.searchNotes = 'Search Notes'.tr();
    KeyValues.searchPerforma = 'Search Performa'.tr();
    KeyValues.searchEstimates = 'Search Estimates'.tr();
    KeyValues.searchProjects = 'Search Projects'.tr();
    KeyValues.searchTickets = 'Search Tickets'.tr();
    KeyValues.searchFiles = 'Search Files'.tr();
    KeyValues.searchReminders = 'Search Reminders'.tr();
    KeyValues.gst = 'GST'.tr();
    KeyValues.lastLogin = 'Last Login'.tr();

    // Add new expenses
    KeyValues.addnewexpenses = 'Add New Expenses'.tr();
    KeyValues.attachReciept = 'Attach Reciept'.tr();
    KeyValues.note = 'Note'.tr();
    KeyValues.expenseCategory = 'Expense Category'.tr();
    KeyValues.expenseDate = 'Expense Date'.tr();
    KeyValues.selectExpenseDate = 'Select Expense Date'.tr();

    KeyValues.advancedOptions = 'Advanced Options'.tr();
    KeyValues.tax1 = 'Tax 1'.tr();
    KeyValues.tax2 = 'Tax 2'.tr();
    KeyValues.paymentMode = 'Payment Mode'.tr();
    KeyValues.repeat = 'Repeat'.tr();

    // Expenses Screen
    KeyValues.expenses = 'EXPENSES'.tr();
    KeyValues.searchExpenses = 'Search Expenses'.tr();
    KeyValues.category = 'Category'.tr();

    //Add New Lead

    KeyValues.title = 'Title'.tr();
    KeyValues.Company = 'Company Name'.tr();
    KeyValues.cityName = 'City Name'.tr();
    KeyValues.language = 'Language'.tr();
    KeyValues.stateName = 'State Name'.tr();
    KeyValues.selectTags = 'Select Tags'.tr();
    KeyValues.selectAssigned = 'Select Assigned'.tr();
    KeyValues.selectLanguage = 'Select Language'.tr();
    KeyValues.selectSource = 'Select Source'.tr();
    KeyValues.selectContactDate = 'Select Contact Date'.tr();
    KeyValues.selectContactToday = 'Select Contact Today'.tr();

    //Add new Proposals

    KeyValues.addNewProposal = 'ADD NEW PROPOSALS'.tr();
    KeyValues.allowComment = 'Allow Comment'.tr();
    KeyValues.openTill = 'Open Till'.tr();
    KeyValues.discountType = 'Discount Type'.tr();
    KeyValues.assigned = 'Assigned'.tr();
    KeyValues.To = 'To'.tr();
    KeyValues.Email = 'Email'.tr();
    KeyValues.Phone = 'Phone'.tr();

    // Proposals Screen
    KeyValues.proposals = 'PROPOSALS'.tr();
    KeyValues.proposalTo = 'Proposal-TO'.tr();

    // Add New Tasks
    KeyValues.addnewTAsk = 'ADD NEW TASKS'.tr();
    KeyValues.billable = 'Billable'.tr();
    KeyValues.hourlyRate = 'Hourly Rate'.tr();
    KeyValues.enterHourlyRate = 'Enter Hourly Rate'.tr();
    KeyValues.repeatEvery = 'Repeat Every'.tr();
    KeyValues.selectPriority = 'Select Priority'.tr();
    KeyValues.relatedTo = 'Related To'.tr();
    KeyValues.tags = 'Tags'.tr();
    KeyValues.cancel = 'Cancel'.tr();

    //Tasks Detail Screen
    KeyValues.startTimer = 'Start Timer'.tr();
    KeyValues.checkListItems = 'CheckList Items'.tr();
    KeyValues.comments = 'Comments'.tr();

    //Add New Ticket
    KeyValues.addnewTicket = 'ADD NEW TICKET'.tr();
    KeyValues.emailAddress = 'Email Address'.tr();
    KeyValues.department = 'Department'.tr();
    KeyValues.cc = 'CC'.tr();
    KeyValues.assignticket = 'Assign Ticket (default is current user)'.tr();
    KeyValues.selectService = 'Select Service'.tr();
    KeyValues.projHint = 'Select and begin typing'.tr();
    KeyValues.ticketBody = 'Ticket Body'.tr();
    KeyValues.tickethint = 'Insert Predefined Reply'.tr();
    KeyValues.nofile = 'No File'.tr();
    KeyValues.selectImage = 'Select Image'.tr();
    KeyValues.camera = 'Camera'.tr();
    KeyValues.gallery = 'Gallery'.tr();

    // Support Screen
    KeyValues.support = 'SUPPORT'.tr();
    KeyValues.dept = 'Dept.'.tr();
    KeyValues.lastReply = 'Last Reply'.tr();

    //Payment Detail Screen
    KeyValues.payment = 'PAYMENT'.tr();
    KeyValues.mode = 'Mode'.tr();
    KeyValues.paymentDate = 'Payment Date'.tr();
    KeyValues.paymentReciept = 'Payment Reciept'.tr();
    KeyValues.amountDue = 'Amount Due'.tr();
    KeyValues.paymentAmount = 'Payment Amount'.tr();
    KeyValues.invoiceAmount = 'Invoice Amount'.tr();

    //Projects Screen

    KeyValues.deadlineDate = 'DeadLine Date'.tr();
    KeyValues.CreateDate = 'Create Date'.tr();
    KeyValues.finishedLine = 'Finished Line'.tr();

    //Project Detail Screen

    KeyValues.billingType = 'Billing Type'.tr();
    KeyValues.totalRate = 'Total Rate'.tr();
    KeyValues.deadline = 'Deadline'.tr();
    KeyValues.domainName = 'Domain Name'.tr();
    KeyValues.members = 'Members'.tr();
    KeyValues.projectOverView = 'Project Overview'.tr();

    KeyValues.discussion = 'Discussion'.tr();

    // Chat Screen
    KeyValues.chat = 'Chat'.tr();
    KeyValues.staff = 'Staff'.tr();
    KeyValues.group = 'Group'.tr();
    KeyValues.Client = 'Client'.tr();

    //
    KeyValues.download = 'Download'.tr();
    KeyValues.reply = 'Reply'.tr();
    KeyValues.createdAt = 'Created At'.tr();
    KeyValues.expired = 'Expired'.tr();

    // Proposal Detail Screen
    KeyValues.summary = 'Summary'.tr();
    KeyValues.personalInfo = 'Personal Informaton'.tr();
    KeyValues.newTask = 'New Task'.tr();
    KeyValues.newNotes = 'New Notes'.tr();
    KeyValues.newReminder = 'New Reminder'.tr();
    KeyValues.priority = 'Priority'.tr();
    KeyValues.emailReminder = 'Send Reminder On Email'.tr();

    KeyValues.gotInTouch = 'I Got in Touch With This Lead'.tr();
    KeyValues.notConnected = 'I Have Not Connected This Lead'.tr();

    ///
    KeyValues.settings = 'Settings'.tr();
    KeyValues.themeChanger = 'Theme Changer'.tr();
    KeyValues.resetColors = 'Reset Colors'.tr();
    KeyValues.passCode = 'Passcode'.tr();
    KeyValues.changePasscode = 'Change Passcode'.tr();
    KeyValues.enterPasscode = 'Enter Passcode'.tr();
    KeyValues.createPasscode = 'Create Passcode'.tr();
    KeyValues.confirmPasscode = 'Confirm Passcode'.tr();
    KeyValues.next = 'Next'.tr();
    KeyValues.resetApp = 'Reset App'.tr();
    KeyValues.newProject = 'New Projects'.tr();

    notifyListeners();
  }
}
