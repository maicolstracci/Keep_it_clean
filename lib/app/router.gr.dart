// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:keep_it_clean/ui/views/LoginPage/login_page_view.dart';
import 'package:keep_it_clean/ui/views/OnboardingPage/onboarding_view.dart';

abstract class Routes {
  static const loginPage = '/';
  static const onboardingPage = '/onboarding-page';
  static const all = {
    loginPage,
    onboardingPage,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => LoginPageView(),
          settings: settings,
        );
      case Routes.onboardingPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => OnboardingView(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
