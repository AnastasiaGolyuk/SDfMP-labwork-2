import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab2/consts/consts.dart';
import 'package:lab2/models/product.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  var _connected = false;

  void initConnect(){
    isNetworkConnected().then((value) {
      setState(() {
        _connected=value;
      });
    });
  }

  @override
  void initState() {
    initConnect();
    super.initState();
  }

  Future<bool> isNetworkConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
                icon: Icon(CupertinoIcons.back),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: _connected?
        WebView(
    initialUrl: widget.product.productLink,
    ):Center(child: Text("No internet connection"),));
  }
}
