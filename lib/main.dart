import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/utils/utils.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:easy_localization/easy_localization.dart';

import 'app/router.gr.dart';

//TODO: add translations for new strings

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  locator<NavigationService>().config(defaultTransition: NavigationTransition.RightToLeft);
  await setCustomMapPin();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(EasyLocalization(
      supportedLocales: [Locale('it', 'IT'), Locale('en', 'US')],
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
        statusBarBrightness: Brightness.light));

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
      home: StartUpView(),
//      initialRoute: Routes.onboardingPage,
    );
  }
}

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
        onModelReady: (model) => model.handleStartUpLogic(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: Color(0xff06442d),
          body: SizedBox.expand(),
            ),
        viewModelBuilder: () => StartUpViewModel());
  }
}

class StartUpViewModel extends BaseViewModel {

  final AuthService _authenticationService =
  locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    if (hasLoggedInUser) {
      _navigationService.replaceWith(Routes.mapsPage);
    } else {
      _navigationService.replaceWith(Routes.loginPage);
    }
  }
}
