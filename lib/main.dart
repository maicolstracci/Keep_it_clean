import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_it_clean/utils/utils.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:easy_localization/easy_localization.dart';

import 'app/router.gr.dart';


//TODO: check ios google login
//TODO: add translations for new strings
//TODO: Check report before make it public

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();

  await setCustomMapPin();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(EasyLocalization(
      supportedLocales: [Locale('it', 'IT'),Locale('en', 'US')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      preloaderColor: Color(0xff06442d),
      child: KeepItClean()));
}

class KeepItClean extends StatefulWidget {
  @override
  _KeepItCleanState createState() {
    return new _KeepItCleanState();
  }
}

class _KeepItCleanState extends State<KeepItClean> {


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light
    ));

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Keep it clean',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        backgroundColor: Color(0xff1e5540),
        accentColor: Color(0xfff4f8f9),
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          body1: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w100,
              color: Colors.black87),
        ),
      ),
      onGenerateRoute: Router().onGenerateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,

//      initialRoute: Routes.onboardingPage,

//      localizationsDelegates: [
//        _newLocaleDelegate,
//        const AppTranslationsDelegate(),
//        //provides localised strings
//        GlobalMaterialLocalizations.delegate,
//        //provides RTL support
//        GlobalWidgetsLocalizations.delegate,
//        GlobalCupertinoLocalizations.delegate
//      ],
//      supportedLocales: [
//        const Locale('en', 'EN'),
//        const Locale('it', 'IT'),
//      ],
    );
  }
}
