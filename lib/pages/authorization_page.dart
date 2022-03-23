import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../account/auth_helper.dart';

class Authorization extends StatefulWidget {
  const Authorization({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {

  var _connected = false;

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

  @override
  Widget build(BuildContext context) {

    if (_connected){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).iconTheme.color,
              fixedSize: const Size.fromWidth(250),
              textStyle: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
            ),
            icon: FaIcon(FontAwesomeIcons.google, color: Theme.of(context).primaryColor),
            onPressed: () {
              final provider = Provider.of<AuthHelper>(context, listen: false);
              provider.signIn();
            },
            label: const Text('Sign in with Google'),
          ),
        ],
      ),
    );} else {
      return Center( child: Text("No internet connection"),);
    }
  }
}
