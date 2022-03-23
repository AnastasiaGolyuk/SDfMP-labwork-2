import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:lab2/api/api_currency.dart';
import 'package:lab2/api/api_products.dart';
import 'package:lab2/consts/consts.dart';
import 'package:lab2/pages/about_page.dart';
import 'package:lab2/pages/auth_page.dart';
import 'package:lab2/pages/home_page.dart';
import 'package:lab2/pages/product_page.dart';
import 'package:lab2/tiles/product_search_tile.dart';
import 'package:lab2/pages/search_page.dart';
import 'package:lab2/widgets/theme_button.dart';

import 'favourites_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title, required this.index})
      : super(key: key);

  final String title;

  final int index;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _selectedIndex = widget.index;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _currencyIndex = 1;
  APIProducts _apiProducts = Get.put(APIProducts());
  APICurrency _apiCurrency = Get.put(APICurrency());

  @override
  Widget build(BuildContext context) {
    var pages = [
      HomePage(title: ' '),
      SearchPage(),
      ChooseAccount(title: 'title'),
      FavouritesPage()
    ];

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('A.shop',
                style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontFamily: Consts.titleFont,
                    fontSize: 30)),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            leading: PopupMenuButton(
              child: Container(
                width: 50,
                child: Text(
                  "${Consts.currenciesName.elementAt(_currencyIndex)}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("BYN"),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text("USD"),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text("EUR"),
                  value: 2,
                ),
                PopupMenuItem(
                  child: Text("RUB"),
                  value: 3,
                ),
                PopupMenuItem(
                  child: Text("PLN"),
                  value: 4,
                ),
                PopupMenuItem(
                  child: Text("UAH"),
                  value: 5,
                ),
              ],
              onSelected: (int value) {
                setState(() {
                  _currencyIndex = value;
                  _apiProducts.setCurrency(
                      _apiCurrency.currencies.elementAt(_currencyIndex));
                });
              },
            ),
            actions: [
              ChangeThemeButtonWidget(),
            ]),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              activeIcon: Icon(CupertinoIcons.house_fill),
              label: '.',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: '.',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled),
              activeIcon: Icon(CupertinoIcons.person_crop_circle_fill),
              label: '.',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart),
              activeIcon: Icon(CupertinoIcons.heart_fill),
              label: 'Favourites',
            ),
          ],
          iconSize: 25,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Theme.of(context).primaryColor,
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).iconTheme.color,
          onTap: _onItemTapped,
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: pages[_selectedIndex],
        ));
  }
}
