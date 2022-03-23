import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lab2/account/auth_helper.dart';
import 'package:lab2/api/api_currency.dart';
import 'package:lab2/pages/home_page.dart';
import 'package:lab2/pages/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab2/themes/theme_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      builder: (context,_){
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
            title: 'Lab2',
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const MainPage(
              title: 'Home',
              index: 0,
            ),
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
        );
      },
      providers: [
        ChangeNotifierProvider(create: (context) => AuthHelper()),
        ChangeNotifierProvider(create: (context) => ThemeProvider())
      ],
    );
  }
}
