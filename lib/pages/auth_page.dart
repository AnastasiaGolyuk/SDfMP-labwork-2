import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab2/pages/authorization_page.dart';
import 'package:lab2/pages/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../account/auth_helper.dart';
import 'about_page.dart';
import 'main_page.dart';

class ChooseAccount extends StatefulWidget {
  const ChooseAccount({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ChooseAccountState createState() => _ChooseAccountState();
}

class _ChooseAccountState extends State<ChooseAccount> {

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
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).iconTheme.color,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error with authorization",
                  style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor)),
            );
          } else if (snapshot.hasData) {
            User? account = FirebaseAuth.instance.currentUser;
            if (account != null) {
              return ProfilePage();
            } else {
              return Center(
                child: Text("Error with authorization",
                    style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor)),
              );
            }
          } else {
            return Authorization(title: 'title');
          }
        });} else {
      return Center(child: Text("No internet connection"),);
    }
  }
}
