import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:keep_it_clean/AddBin/add_bin_page_new.dart';
import 'package:keep_it_clean/FirstTimeUserPage/first_time_user.dart';
import 'package:keep_it_clean/Localization/app_translation_delegate.dart';
import 'package:keep_it_clean/Localization/application.dart';
import 'package:keep_it_clean/login_page.dart';
//TODO: check ios google login
//TODO: add translations for new strings
//TODO: Check report before make it public

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

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light
    ));

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
//      home: LoginPage(),
      home: FirstTimeUserWidget(user: null),
      routes: <String, WidgetBuilder> {
        '/loginScreen': (BuildContext context) => new LoginPage(),
      },
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
        //const Locale('de', 'DE')
      ],
    );
  }
}
