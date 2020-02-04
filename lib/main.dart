import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:keep_it_clean/FirstTimeUserPage/first_time_user.dart';
import 'package:keep_it_clean/Localization/app_translation_delegate.dart';
import 'package:keep_it_clean/Localization/application.dart';
import 'package:keep_it_clean/login_page.dart';

import 'login_page_test.dart';

//TODO: if no location enable should crash fix
//TODO: Add translations
//TODO: Improve fast delete admin option - OPTIONAL
//TODO: Check report before make it public
//TODO: Change loginPage colors to be more light

void main() => runApp(KeepItClean());

class KeepItClean extends StatefulWidget {
  @override
  _KeepItCleanState createState() {
    return new _KeepItCleanState();
  }
}

class _KeepItCleanState extends State<KeepItClean> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();

    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'Keep it Clean',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          body1: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w100,
              color: Colors.black87),
        ),
      ),
      home: FirstTimeUserWidget(),
//      home: LoginPage(),
      localizationsDelegates: [
        _newLocaleDelegate,
        const AppTranslationsDelegate(),
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'EN'),
        const Locale('it', 'IT'),
        const Locale('de', 'DE')
      ],
    );
  }
}
