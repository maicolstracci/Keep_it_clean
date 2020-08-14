import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/router.gr.dart';

//TODO: Test Sign in with Apple
//TODO: Check Device preview package

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  locator<NavigationService>().config(
      defaultTransition: NavigationTransition.RightToLeft,
      defaultDurationTransition: Duration(milliseconds: 200));
  await locator<AuthService>().retriveAppleSignInAvailable();
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

class StartUpView extends StatefulWidget {
  @override
  _StartUpViewState createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView>
    with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController controllerContAnimation;
  AnimationController controllerTextOpacity;

  Animation<Offset> offsetAnimation;
  Animation<Offset> offsetContAnimation;
  Animation<double> textOpacityAnimation;

  void _onFinishInitAnim(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      controllerContAnimation.forward();
      controllerTextOpacity.forward();
    }
  }

  void _onChangeStatusContAnim(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      controllerContAnimation.reverse();
    } else if (status == AnimationStatus.dismissed) {
      controllerContAnimation.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 1500), vsync: this)
          ..addStatusListener(_onFinishInitAnim);
    controllerContAnimation =
        AnimationController(duration: Duration(seconds: 1), vsync: this)
          ..addStatusListener(_onChangeStatusContAnim);
    controllerTextOpacity =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    offsetAnimation = Tween<Offset>(
            begin: Offset(0, -10), end: Offset(0, 0.017))
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    offsetContAnimation =
        Tween<Offset>(begin: Offset(0, 0.15), end: Offset(0, -0.15)).animate(
            CurvedAnimation(
                parent: controllerContAnimation, curve: Curves.easeInOut));

    textOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: controllerTextOpacity,
            curve: Curves.fastLinearToSlowEaseIn));

    controller.forward();
  }

  @override
  void dispose() {
    controller.removeStatusListener(_onFinishInitAnim);
    controllerContAnimation.removeStatusListener(_onChangeStatusContAnim);
    controllerContAnimation.dispose();
    controllerTextOpacity.dispose();
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
        onModelReady: (model) => model.handleStartUpLogic(
            controller, controllerContAnimation, controllerTextOpacity),
        builder: (context, model, child) => Scaffold(
              backgroundColor: Color(0xff06442d),
              body: SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SlideTransition(
                          position: offsetAnimation,
                          child: SlideTransition(
                            position: offsetContAnimation,
                            child: SizedBox(
                                width: 150,
                                child: Image.asset(
                                    "assets/illustrations/happy-earth.png")),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedBuilder(
                          animation: textOpacityAnimation,
                          builder: (_, child) => Opacity(
                            opacity: textOpacityAnimation.value,
                            child: child,
                          ),
                          child: Text(
                            tr("Caricamento in corso"),
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => StartUpViewModel());
  }
}

class StartUpViewModel extends BaseViewModel {
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic(
      AnimationController controller,
      AnimationController animationContController,
      AnimationController opacityController) async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    await Future.delayed(Duration(seconds: 4));
    animationContController.stop();
    controller.reverse();
    opacityController.reverse().then((value) {
      if (hasLoggedInUser) {
        _navigationService.replaceWith(Routes.mapsPage);
      } else {
        _navigationService.replaceWith(Routes.loginPage);
      }
    });
  }
}
