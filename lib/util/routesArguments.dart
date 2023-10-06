// ignore_for_file: non_constant_identifier_names, file_names

class RouteArgument {
  String Ordername;
  String OrderBy;

  RouteArgument({required this.Ordername, required this.OrderBy});
}

class PageArgument {
  String? Staff_id;
  String? Title;
  String? Invoiceid;
  String? InvoiceNumber;

  PageArgument(
      {required this.Staff_id,
      required this.Title,
      this.Invoiceid,
      this.InvoiceNumber});
}

class PaymentArgument {
  String? Staff_id;
  String? Title;
  String? Invoiceid;
  String? paymentid;

  PaymentArgument({this.Staff_id, this.Title, this.Invoiceid, this.paymentid});
}

class Proposalinvoice {
  String url;
  String? Title;

  Proposalinvoice({required this.url, this.Title});
}

class RouteFile {
  String ID;
  String Type;

  RouteFile({required this.ID, required this.Type});
}

class TicketFileRoute {
  String CustomerID;
  String ProjectID;
  String Type;

  TicketFileRoute(
      {required this.CustomerID, required this.ProjectID, required this.Type});
}
