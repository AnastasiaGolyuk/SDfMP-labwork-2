import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:lab2/api/api_products.dart';
import 'package:lab2/pages/about_page.dart';
import 'package:lab2/pages/product_page.dart';
import 'package:lab2/tiles/product_search_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final APIProducts apiProducts = Get.put(APIProducts());

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Center(child:
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutPage()),
                          (ret) => true);
                    },
                    child: Text('About',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 20, fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(primary: Theme.of(context).iconTheme.color,fixedSize: Size.fromWidth(200)),)
              )],
            ));
  }
}
