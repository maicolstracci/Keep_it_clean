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
import 'package:keep_it_clean/ui/views/AddBinPage/picture_selection_view.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/select_bin_position_view.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/reporter_profile_page_view.dart';
import 'package:keep_it_clean/ui/views/IllegalWasteDisposalPage/illegal_waste_disposal_view.dart';
import 'package:keep_it_clean/ui/views/IllegalWasteDisposalPage/illegal_waste_details_view.dart';

abstract class Routes {
  static const loginPage = '/login-page';
  static const onboardingPage = '/onboarding-page';
  static const mapsPage = '/maps-page';
  static const profilePage = '/profile-page';
  static const binDetailsPage = '/bin-details-page';
  static const addBinPage = '/add-bin-page';
  static const pictureSelectionPage = '/picture-selection-page';
  static const selectBinPositionPage = '/select-bin-position-page';
  static const reporterProfilePage = '/reporter-profile-page';
  static const illegalWasteDisposalPage = '/illegal-waste-disposal-page';
  static const illegalWasteDetailsPage = '/illegal-waste-details-page';
  static const all = {
    loginPage,
    onboardingPage,
    mapsPage,
    profilePage,
    binDetailsPage,
    addBinPage,
    pictureSelectionPage,
    selectBinPositionPage,
    reporterProfilePage,
    illegalWasteDisposalPage,
    illegalWasteDetailsPage,
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
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.loginPage:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginPageView(),
          settings: settings,
        );
      case Routes.onboardingPage:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              OnboardingView(),
          settings: settings,
        );
      case Routes.mapsPage:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              MapsPageView(),
          settings: settings,
        );
      case Routes.profilePage:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ProfilePageView(),
          settings: settings,
        );
      case Routes.binDetailsPage:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              BinDetailsPageView(),
          settings: settings,
        );
      case Routes.addBinPage:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              AddBinPageView(),
          settings: settings,
        );
      case Routes.pictureSelectionPage:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              PictureSelectionView(),
          settings: settings,
        );
      case Routes.selectBinPositionPage:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SelectBinPositionView(),
          settings: settings,
        );
      case Routes.reporterProfilePage:
        if (hasInvalidArgs<ReporterProfileViewArguments>(args)) {
          return misTypedArgsRoute<ReporterProfileViewArguments>(args);
        }
        final typedArgs = args as ReporterProfileViewArguments ??
            ReporterProfileViewArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ReporterProfileView(reporterUid: typedArgs.reporterUid),
          settings: settings,
        );
      case Routes.illegalWasteDisposalPage:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              IllegalWasteDisposalView(),
          settings: settings,
        );
      case Routes.illegalWasteDetailsPage:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              IllegalWasteDetailsView(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//ReporterProfileView arguments holder class
class ReporterProfileViewArguments {
  final String reporterUid;
  ReporterProfileViewArguments({this.reporterUid});
}
