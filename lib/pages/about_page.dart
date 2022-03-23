import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab2/consts/consts.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: Consts.getWidth(context),
              child: Text(
                "Labwork 2",
                style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: Consts.titleFont),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Image(
                image: AssetImage('images/my_photo.jpg'),
                width: 250,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: Consts.getWidth(context),
              child: Text(
                "Anastasia Golyuk",
                style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: Consts.getWidth(context),
              child: Text(
                "951006",
                style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ));
  }
}
