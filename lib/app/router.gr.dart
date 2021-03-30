// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;

import '../main.dart' as _i2;
import '../ui/views/AddBinPage/add_bin_page_view.dart' as _i8;
import '../ui/views/AddBinPage/picture_selection_view.dart' as _i9;
import '../ui/views/AddBinPage/select_bin_position_view.dart' as _i10;
import '../ui/views/BinDetailsPage/bin_details_view.dart' as _i7;
import '../ui/views/IllegalWasteDisposalPage/illegal_waste_details_view.dart'
    as _i13;
import '../ui/views/IllegalWasteDisposalPage/illegal_waste_disposal_view.dart'
    as _i12;
import '../ui/views/LoginPage/login_page_view.dart' as _i3;
import '../ui/views/MapsPage/maps_page_view.dart' as _i5;
import '../ui/views/OnboardingPage/onboarding_view.dart' as _i4;
import '../ui/views/ProfilePage/profile_page_view.dart' as _i6;
import '../ui/views/ProfilePage/reporter_profile_page_view.dart' as _i11;

class AppRouter extends _i1.RootStackRouter {
  AppRouter();

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    StartUpViewRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i2.StartUpView(),
          opaque: true,
          barrierDismissible: false);
    },
    LoginPageViewRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i3.LoginPageView(),
          opaque: true,
          barrierDismissible: false);
    },
    OnboardingViewRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i4.OnboardingView(),
          opaque: true,
          barrierDismissible: false);
    },
    MapsPageViewRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i5.MapsPageView(),
          opaque: true,
          barrierDismissible: false);
    },
    ProfilePageViewRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i6.ProfilePageView(),
          opaque: true,
          barrierDismissible: false);
    },
    BinDetailsPageViewRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i7.BinDetailsPageView(),
          opaque: true,
          barrierDismissible: false);
    },
    AddBinPageViewRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i8.AddBinPageView(),
          opaque: true,
          barrierDismissible: false);
    },
    PictureSelectionViewRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i9.PictureSelectionView(),
          opaque: true,
          barrierDismissible: false);
    },
    SelectBinPositionViewRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i10.SelectBinPositionView(),
          opaque: true,
          barrierDismissible: false);
    },
    ReporterProfileViewRoute.name: (entry) {
      var args = entry.routeData.argsAs<ReporterProfileViewRouteArgs>(
          orElse: () => ReporterProfileViewRouteArgs());
      return _i1.CustomPage(
          entry: entry,
          child: _i11.ReporterProfileView(reporterUid: args.reporterUid),
          opaque: true,
          barrierDismissible: false);
    },
    IllegalWasteDisposalViewRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i12.IllegalWasteDisposalView(),
          opaque: true,
          barrierDismissible: false);
    },
    IllegalWasteDetailsViewRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i13.IllegalWasteDetailsView(),
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(StartUpViewRoute.name, path: '/'),
        _i1.RouteConfig(LoginPageViewRoute.name, path: '/login-page-view'),
        _i1.RouteConfig(OnboardingViewRoute.name, path: '/onboarding-view'),
        _i1.RouteConfig(MapsPageViewRoute.name, path: '/maps-page-view'),
        _i1.RouteConfig(ProfilePageViewRoute.name, path: '/profile-page-view'),
        _i1.RouteConfig(BinDetailsPageViewRoute.name,
            path: '/bin-details-page-view'),
        _i1.RouteConfig(AddBinPageViewRoute.name, path: '/add-bin-page-view'),
        _i1.RouteConfig(PictureSelectionViewRoute.name,
            path: '/picture-selection-view'),
        _i1.RouteConfig(SelectBinPositionViewRoute.name,
            path: '/select-bin-position-view'),
        _i1.RouteConfig(ReporterProfileViewRoute.name,
            path: '/reporter-profile-view'),
        _i1.RouteConfig(IllegalWasteDisposalViewRoute.name,
            path: '/illegal-waste-disposal-view'),
        _i1.RouteConfig(IllegalWasteDetailsViewRoute.name,
            path: '/illegal-waste-details-view')
      ];
}

class StartUpViewRoute extends _i1.PageRouteInfo {
  const StartUpViewRoute() : super(name, path: '/');

  static const String name = 'StartUpViewRoute';
}

class LoginPageViewRoute extends _i1.PageRouteInfo {
  const LoginPageViewRoute() : super(name, path: '/login-page-view');

  static const String name = 'LoginPageViewRoute';
}

class OnboardingViewRoute extends _i1.PageRouteInfo {
  const OnboardingViewRoute() : super(name, path: '/onboarding-view');

  static const String name = 'OnboardingViewRoute';
}

class MapsPageViewRoute extends _i1.PageRouteInfo {
  const MapsPageViewRoute() : super(name, path: '/maps-page-view');

  static const String name = 'MapsPageViewRoute';
}

class ProfilePageViewRoute extends _i1.PageRouteInfo {
  const ProfilePageViewRoute() : super(name, path: '/profile-page-view');

  static const String name = 'ProfilePageViewRoute';
}

class BinDetailsPageViewRoute extends _i1.PageRouteInfo {
  const BinDetailsPageViewRoute() : super(name, path: '/bin-details-page-view');

  static const String name = 'BinDetailsPageViewRoute';
}

class AddBinPageViewRoute extends _i1.PageRouteInfo {
  const AddBinPageViewRoute() : super(name, path: '/add-bin-page-view');

  static const String name = 'AddBinPageViewRoute';
}

class PictureSelectionViewRoute extends _i1.PageRouteInfo {
  const PictureSelectionViewRoute()
      : super(name, path: '/picture-selection-view');

  static const String name = 'PictureSelectionViewRoute';
}

class SelectBinPositionViewRoute extends _i1.PageRouteInfo {
  const SelectBinPositionViewRoute()
      : super(name, path: '/select-bin-position-view');

  static const String name = 'SelectBinPositionViewRoute';
}

class ReporterProfileViewRoute
    extends _i1.PageRouteInfo<ReporterProfileViewRouteArgs> {
  ReporterProfileViewRoute({String reporterUid})
      : super(name,
            path: '/reporter-profile-view',
            args: ReporterProfileViewRouteArgs(reporterUid: reporterUid));

  static const String name = 'ReporterProfileViewRoute';
}

class ReporterProfileViewRouteArgs {
  const ReporterProfileViewRouteArgs({this.reporterUid});

  final String reporterUid;
}

class IllegalWasteDisposalViewRoute extends _i1.PageRouteInfo {
  const IllegalWasteDisposalViewRoute()
      : super(name, path: '/illegal-waste-disposal-view');

  static const String name = 'IllegalWasteDisposalViewRoute';
}

class IllegalWasteDetailsViewRoute extends _i1.PageRouteInfo {
  const IllegalWasteDetailsViewRoute()
      : super(name, path: '/illegal-waste-details-view');

  static const String name = 'IllegalWasteDetailsViewRoute';
}
