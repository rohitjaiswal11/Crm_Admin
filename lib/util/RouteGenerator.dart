// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lbm_crm/Annoucement/add_new_announcement.dart';
import 'package:lbm_crm/Annoucement/announcement_detail.dart';
import 'package:lbm_crm/Annoucement/announcement_screen.dart';
import 'package:lbm_crm/Appointment/add_new_appointment.dart';
import 'package:lbm_crm/Appointment/appointment_screen.dart';
import 'package:lbm_crm/Appointment/appointmetView.dart';
import 'package:lbm_crm/Chat/chat_screen.dart';
import 'package:lbm_crm/Contract/add_new_contracts.dart';
import 'package:lbm_crm/Contract/contracts_screen.dart';
import 'package:lbm_crm/Customer/CustomerDetail/addnewContact.dart';
import 'package:lbm_crm/Customer/CustomerDetail/customer_detail_screen.dart';
import 'package:lbm_crm/Customer/add_new_customers.dart';
import 'package:lbm_crm/Customer/customers_screen.dart';
import 'package:lbm_crm/DashBoard/dashboard_screen.dart';
import 'package:lbm_crm/Estimates/add_estimate_screen.dart';
import 'package:lbm_crm/Estimates/estimates_screen.dart';
import 'package:lbm_crm/Estimates/estimates_view.dart';
import 'package:lbm_crm/Expenses/add_new_expenses.dart';
import 'package:lbm_crm/Expenses/expenses_screen.dart';
import 'package:lbm_crm/Invoice/add_invoice_screen.dart';
import 'package:lbm_crm/Invoice/invoiceView.dart';
import 'package:lbm_crm/Invoice/invoice_detail_screen.dart';
import 'package:lbm_crm/Invoice/invoices_screen.dart';
import 'package:lbm_crm/Language/language.dart';
import 'package:lbm_crm/Leads/add_new_lead.dart';
import 'package:lbm_crm/Leads/lead_detail_screen.dart';
import 'package:lbm_crm/Leads/lead_screen.dart';
import 'package:lbm_crm/Leads/noteView.dart';
import 'package:lbm_crm/Leads/reminderView.dart';
import 'package:lbm_crm/Leads/taskview.dart';
import 'package:lbm_crm/Master_Search/searchScreen.dart';
import 'package:lbm_crm/OnBoarding/onBoardingScreen.dart';
import 'package:lbm_crm/Payments/payment_detail_screen.dart';
import 'package:lbm_crm/Payments/payments_screen.dart';
import 'package:lbm_crm/Projects/DiscussionScreen.dart';
import 'package:lbm_crm/Projects/add_new_project.dart';
import 'package:lbm_crm/Projects/project_details_screen.dart';
import 'package:lbm_crm/Projects/projects_screen.dart';
import 'package:lbm_crm/Proposals/add_new_proposals.dart';
import 'package:lbm_crm/Proposals/proposal_detail_screen.dart';
import 'package:lbm_crm/Proposals/proposals_screen.dart';
import 'package:lbm_crm/SeeAll/see_all_screen.dart';
import 'package:lbm_crm/SettingsScreen.dart';
import 'package:lbm_crm/Support/add_new_ticket.dart';
import 'package:lbm_crm/Support/support_detail_screen.dart';
import 'package:lbm_crm/Support/support_screen.dart';
import 'package:lbm_crm/Tasks/add_new_tasks.dart';
import 'package:lbm_crm/Tasks/task_detail_screen.dart';
import 'package:lbm_crm/Tasks/tasks_screen.dart';
import 'package:lbm_crm/ThemeChanger.dart';
import 'package:lbm_crm/loginSignup/login_screen.dart';
import 'package:lbm_crm/loginSignup/signUp_screen.dart';
import 'package:lbm_crm/splashScreen.dart';
import 'package:lbm_crm/util/Authenticatin/confirmPasswordScreen.dart';
import 'package:lbm_crm/util/Authenticatin/createPasswordScreen.dart';
import 'package:lbm_crm/util/Authenticatin/localAuthVerifyScreen.dart';
import 'package:lbm_crm/util/routesArguments.dart';
import 'package:lbm_crm/widgets/bottom_navigationbar.dart';

import '../Chat/chat_detail_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments as dynamic;

    switch (settings.name) {
      case SplashScreen.id:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case SearchScreen.id:
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case OnBoardingScreen.id:
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
      case LanguageView.id:
        return MaterialPageRoute(builder: (_) => LanguageView());
      case SettingsScreen.id:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case ThemeChangerScreen.id:
        return MaterialPageRoute(builder: (_) => ThemeChangerScreen());
      case SeeAllScreen.id:
        return MaterialPageRoute(builder: (_) => SeeAllScreen());
      case BottomBar.id:
        return MaterialPageRoute(builder: (_) => BottomBar());
      case LoginScreen.id:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case SignupScreen.id:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case DashBoardScreen.id:
        return MaterialPageRoute(builder: (_) => DashBoardScreen());

      //////// Main Screens ////////

      case ContractsScreen.id:
        return MaterialPageRoute(builder: (_) => ContractsScreen());
      case CustomerScreen.id:
        return MaterialPageRoute(builder: (_) => CustomerScreen());
      case ExpensesScreen.id:
        return MaterialPageRoute(builder: (_) => ExpensesScreen());
      case PaymentScreen.id:
        return MaterialPageRoute(builder: (_) => PaymentScreen());
      case ProjectsScreen.id:
        return MaterialPageRoute(builder: (_) => ProjectsScreen());
      case ProposalScreen.id:
        return MaterialPageRoute(builder: (_) => ProposalScreen());
      case SupportScreen.id:
        return MaterialPageRoute(builder: (_) => SupportScreen());
      case AppointmentScreen.id:
        return MaterialPageRoute(builder: (_) => AppointmentScreen());
      case AnnouncementScreen.id:
        return MaterialPageRoute(builder: (_) => AnnouncementScreen());
      case TasksScreen.id:
        return MaterialPageRoute(builder: (_) => TasksScreen(args));
      case ChatScreen.id:
        return MaterialPageRoute(builder: (_) => ChatScreen());
      case ChatDetail.id:
        return MaterialPageRoute(
            builder: (_) => ChatDetail(
                  type: args['type'],
                  receiverData: args['data'],
                  reciever_id: args['id'],
                ));
      case ProposalDetailScreen.id:
        return MaterialPageRoute(builder: (_) => ProposalDetailScreen());
      case InvoiceScreen.id:
        return MaterialPageRoute(builder: (_) => InvoiceScreen());
      case EstimatesScreen.id:
        return MaterialPageRoute(builder: (_) => EstimatesScreen());
      case LeadScreen.id:
        return MaterialPageRoute(
            builder: (_) => LeadScreen(
                  leadStatus: args as String?,
                ));

      //////// Detail Screens ////////

      case SupportDetailScreen.id:
        return MaterialPageRoute(
            builder: (_) => SupportDetailScreen(
                  TicketData: args as List,
                ));
      case ProjectDetailScreen.id:
        return MaterialPageRoute(
            builder: (_) => ProjectDetailScreen(
                  ProjectData: args as List,
                ));
      case CustomerDetailScreen.id:
        return MaterialPageRoute(
            builder: (_) => CustomerDetailScreen(
                  CustomerData: args as List<dynamic>,
                ));
      case InvoiceDetailScreen.id:
        return MaterialPageRoute(
            builder: (_) => InvoiceDetailScreen(
                  pageArgument: args as PageArgument,
                ));
      case TaskDetailScreen.id:
        return MaterialPageRoute(
            builder: (_) => TaskDetailScreen(
                  Task: args as List,
                ));
      case LeadDetailScreen.id:
        return MaterialPageRoute(
            builder: (_) => LeadDetailScreen(
                  LeadData: args as List,
                ));
      case AnnouncementDetail.id:
        return MaterialPageRoute(
            builder: (_) => AnnouncementDetail(
                  data: args,
                ));
      case PaymentDetailScreen.id:
        return MaterialPageRoute(
            builder: (_) => PaymentDetailScreen(
                  paymentArgument: args as PaymentArgument,
                ));

      ////////  Views ////////
      case InvoiceView.id:
        return MaterialPageRoute(
            builder: (_) => InvoiceView(
                  proposalinvoice: args as Proposalinvoice,
                ));

      case ViewAppointment.idA:
        return MaterialPageRoute(
            builder: (_) => ViewAppointment(
                  id: args as String,
                ));
      case EstimatesView.id:
        return MaterialPageRoute(
            builder: (_) => EstimatesView(
                  proposalinvoice: args as Proposalinvoice,
                ));

      case NoteViewDialogBox.id:
        return MaterialPageRoute(
            builder: (_) => NoteViewDialogBox(
                  LeadID: args as String,
                ));

      case TaskViewDialogBox.id:
        return MaterialPageRoute(
            builder: (_) => TaskViewDialogBox(
                  LeadID: args as String,
                ));

      case ReminderViewDialogBox.id:
        return MaterialPageRoute(
            builder: (_) => ReminderViewDialogBox(
                  LeadID: args as String,
                ));

      case DiscussionScreen.id:
        return MaterialPageRoute(
            builder: (_) => DiscussionScreen(
                  data: args as List,
                ));

      //////// Add or Edit Screens ////////
      case AddInvoiceScreen.id:
        return MaterialPageRoute(
            builder: (_) => AddInvoiceScreen(
                  invoiceData: args,
                ));
      case AddEstimateScreen.id:
        return MaterialPageRoute(
            builder: (_) => AddEstimateScreen(
                  estimateData: args,
                ));
      case NewCustomer.id:
        return MaterialPageRoute(
            builder: (_) => NewCustomer(
                  CustomerProfile: args as List,
                ));
      case AddNewExpenses.id:
        return MaterialPageRoute(
            builder: (_) => AddNewExpenses(
                  EditExpense: args as List,
                ));

      case AddNewTicket.id:
        return MaterialPageRoute(
            builder: (_) => AddNewTicket(
                  CustomerID: args as String,
                ));

      case NewContractScreen.id:
        return MaterialPageRoute(
            builder: (_) => NewContractScreen(
                  EditData: args as List,
                ));
      case AddNewProposalScreen.id:
        return MaterialPageRoute(
            builder: (_) => AddNewProposalScreen(
                  data: args,
                ));
      case AddNewAppointment.id:
        return MaterialPageRoute(
            builder: (_) => AddNewAppointment(
                  EditList: args as List,
                ));
      case AddNewAnnouncementScreen.id:
        return MaterialPageRoute(
            builder: (_) => AddNewAnnouncementScreen(
                  EditData: args as List,
                ));
      case AddNewLead.id:
        return MaterialPageRoute(
            builder: (_) => AddNewLead(
                  LeadID: args as String,
                ));
      case AddNewContact.id:
        return MaterialPageRoute(
            builder: (_) => AddNewContact(
                  customerID: args['customerID'] as String,
                  contactID: args['contactID'],
                ));
      case AddNewTasks.id:
        return MaterialPageRoute(
            builder: (_) => AddNewTasks(
                  taskData: args,
                ));
      case AddNewProject.id:
        return MaterialPageRoute(builder: (_) => AddNewProject());

      //////// Password  ////////
      case CreatePasswordScreen.id:
        return MaterialPageRoute(builder: (_) => CreatePasswordScreen());
      case ConfirmPasswordScreen.id:
        return MaterialPageRoute(
            builder: (_) => ConfirmPasswordScreen(
                  password: args as String,
                ));
      case LocalAuthVerifyScreen.id:
        return MaterialPageRoute(
            builder: (_) => LocalAuthVerifyScreen(
                  navigationDetails: args as VerifyModel,
                ));
//////// Location  ////////
      // case LocationScreen.id:
      //   return MaterialPageRoute(builder: (_) => LocationScreen());
      default:
        //    If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Page Note Found'),
        ),
      );
    });
  }
}
