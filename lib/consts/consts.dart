import 'package:flutter/material.dart';

class Consts {

  static getWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }

  static getHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  static final productsAPIUrlBrand ='http://makeup-api.herokuapp.com/api/v1/products.json?brand=';
  static final productsAPIUrlBase ='http://makeup-api.herokuapp.com';
  static final currenciesAPIUrl ='https://myfin.by/currency/minsk';

  static final okStatus = 200;

  static final currenciesSymbols = <String>{"Br","\$","\€","\₽","zł","hr"};
  static final currenciesName = <String>{"BYN","USD","EUR","RUB","PLN","UAH"};

  static final brandList = <String>{'clinique', 'wet n wild', 'maybelline'};

  static final simpleFont = 'Barlow';
  static final titleFont = 'Cinzel';

  static final lightThemeMainColor = Color(0xff7763a7);
  static final lightThemeBrightColor = Color(0xffa3d9b3);
  static final lightThemeBackgroundColor = Color(0xffffffe3);
  static final lightThemeCardColor = Color(0xfffffff4);
  static final lightThemeBarColor = Color(0xffaa96da);

  static final darkThemeMainColor = Color(0xffffffe3);
  static final darkThemeCardColor = Color(0xff7677b0);
  static final darkThemeBrightColor = Color(0xffa3d9b3);
  static final darkThemeBackgroundColor = Color(0xff9985da);
  static final darkThemeBarColor = Color(0xff555185);
}