// This page show the web view of invoice
// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, avoid_print, prefer_const_constructors, unused_field, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/routesArguments.dart';

class InvoiceView extends StatefulWidget {
  static const id = 'invoiceView';
  Proposalinvoice proposalinvoice;
  String? url;
  String? title;

  InvoiceView({required this.proposalinvoice}) {
    url = proposalinvoice.url;
    title = proposalinvoice.Title;
  }
  @override
  _InvoiceViewState createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  // PDFDocument doc;
  @override
  void initState() {
    super.initState();
    print(widget.url);

    //getUrl(widget.url);
  }

  //show url show in web view
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url!,
      allowFileURLs: true,
      ignoreSSLErrors: true,
      appCacheEnabled: true,
      enableAppScheme: true,
      appBar: AppBar(
        backgroundColor: ColorCollection.backColor,
        title: Row(
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: widget.title == 'Proposal View'
                  ? Image.asset('assets/third.png')
                  : Image.asset('assets/second.png'),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              widget.title == 'Proposal View'
                  ? KeyValues.proposal
                  : KeyValues.invoice,
              style: ColorCollection.titleStyleWhite.copyWith(fontSize: 20),
            ),
          ],
        ),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true, 
      initialChild: Container(
        color: Colors.white,
        child: Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }
}
