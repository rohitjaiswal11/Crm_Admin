// This page show the web view of invoice
// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, avoid_print, prefer_const_constructors, unused_field, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:lbm_crm/util/app_key.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/routesArguments.dart';

class EstimatesView extends StatefulWidget {
  static const id = 'estimatesView';
  Proposalinvoice proposalinvoice;
  String? url;

  EstimatesView({required this.proposalinvoice}) {
    url = proposalinvoice.url;
  }
  @override
  _EstimatesViewState createState() => _EstimatesViewState();
}

class _EstimatesViewState extends State<EstimatesView> {
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
      
      appBar: AppBar(
        backgroundColor: ColorCollection.backColor,
        title: Row(
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: Image.asset('assets/estimate.png'),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              KeyValues.estimates,
              style: ColorCollection.titleStyleWhite.copyWith(fontSize: 20),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
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
