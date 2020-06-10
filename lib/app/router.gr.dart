// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:keep_it_clean/ui/views/LoginPage/login_page_view.dart';
import 'package:keep_it_clean/ui/views/OnboardingPage/onboarding_view.dart';
import 'package:keep_it_clean/ui/views/MapsPage/maps_page_view.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/profile_page_view.dart';
import 'package:keep_it_clean/ui/views/BinDetailsPage/bin_details_view.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/add_bin_page_view.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/select_bin_position_view.dart';

abstract class Routes {
  static const loginPage = '/';
  static const onboardingPage = '/onboarding-page';
  static const mapsPage = '/maps-page';
  static const profilePage = '/profile-page';
  static const binDetailsPage = '/bin-details-page';
  static const addBinPage = '/add-bin-page';
  static const selectBinPositionPage = '/select-bin-position-page';
  static const all = {
    loginPage,
    onboardingPage,
    mapsPage,
    profilePage,
    binDetailsPage,
    addBinPage,
    selectBinPositionPage,
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
      case Routes.mapsPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => MapsPageView(),
          settings: settings,
        );
      case Routes.profilePage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => ProfilePageView(),
          settings: settings,
        );
      case Routes.binDetailsPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => BinDetailsPageView(),
          settings: settings,
        );
      case Routes.addBinPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => AddBinPageView(),
          settings: settings,
        );
      case Routes.selectBinPositionPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SelectBinPositionView(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
