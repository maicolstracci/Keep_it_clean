import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/localization/app_translation.dart';
import 'package:keep_it_clean/models/user_model.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfilePageViewModel extends FutureViewModel<User> {
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  DatabaseService _databaseService = locator<DatabaseService>();

  int currentIndex = 0;

  String getUsername() {
    return (_authService.currentUser != null)
        ? _authService.currentUser.name
        : tr("Utente ospite");
  }

  changeCurrentIndex(int index){
    currentIndex = index;
    notifyListeners();
  }

  String getProfilePhotoUrl() {
    return _authService.currentUser.profilePic;
  }

  bool isUserLoggedIn() {
    return _authService.currentUser != null;
  }

  int getNumberOfReportsForType(int index) {
    Map<String, int> map = data.reports;
    if (map == null) return 0;

    return map[typesOfBin[index]] ?? 0;
  }

  navigateToLoginPage() {
    _navigationService.clearStackAndShow(Routes.loginPage);
  }

  signOut() async {
    DialogResponse response = await _dialogService.showDialog(
        title: tr('SIGN OUT'),
        description: tr("Vuoi davvero disconnetterti?"),
        cancelTitle: tr("NO"),
        buttonTitle: tr("SI"));

    if (response.confirmed) {
      _authService.signOut();
      _navigationService.clearStackAndShow(Routes.loginPage);
    }
  }

  @override
  Future<User> futureToRun() {
    if (_authService.currentUser != null)
      return _databaseService.retrieveUserInfo(
          reporterUid: _authService.currentUser.uid);
  }
}
