import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lab2/consts/consts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance?.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    dialogBackgroundColor: Consts.darkThemeBackgroundColor,
    cardColor: Consts.darkThemeCardColor,
      appBarTheme: AppBarTheme(backgroundColor: Consts.darkThemeBarColor),
      scaffoldBackgroundColor: Consts.darkThemeBackgroundColor,
      primaryColor: Consts.darkThemeMainColor,
      colorScheme: ColorScheme.dark(),
      iconTheme: IconThemeData(color: Consts.darkThemeBrightColor),
      buttonTheme: ButtonThemeData(
          buttonColor: Consts.darkThemeBrightColor,
          textTheme: ButtonTextTheme.primary),
      fontFamily: 'Barlow');

  static final lightTheme = ThemeData(
    dialogBackgroundColor: Consts.lightThemeBackgroundColor,
    cardColor: Consts.lightThemeCardColor,
      appBarTheme: AppBarTheme(backgroundColor: Consts.lightThemeBarColor),
      scaffoldBackgroundColor: Consts.lightThemeBackgroundColor,
      primaryColor: Consts.lightThemeMainColor,
      colorScheme: ColorScheme.light(),
      iconTheme: IconThemeData(color: Consts.lightThemeBrightColor),
      buttonTheme: ButtonThemeData(
          buttonColor: Consts.lightThemeBrightColor,
          textTheme: ButtonTextTheme.primary),
      fontFamily: 'Barlow');
}
