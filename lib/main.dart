import 'package:app_developer_assignment/dashboard/view.dart';
import 'package:app_developer_assignment/registration/view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Resources/WidgetConstants.dart';
import 'login/view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAlreadyLoggedIn = false;

  @override
  void initState() {
    checkAlreadyLoggedIn();
    super.initState();
  }

  void checkAlreadyLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isAlreadyLoggedIn = (await prefs.getBool('AlreadyLoggedIn')) ?? false;
    print(isAlreadyLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              supportedLocales: [
                Locale('en', 'US'),
                Locale('ja', 'JA'),
              ],
              localizationsDelegates: [
                // delegate from flutter_localization
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                // delegate from localization package.
                LocalJsonLocalization.delegate,
              ],
              initialRoute: isAlreadyLoggedIn ? DashboardPage.id : LoginPage.id,
              routes: {
                DashboardPage.id: (context) => DashboardPage(),
                LoginPage.id: (context) => LoginPage(),
                RegistrationPage.id: (context) => RegistrationPage()
              },
            );
          }
          return loadingWidget();
        });
  }
}
