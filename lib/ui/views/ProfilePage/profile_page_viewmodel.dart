import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/bloc/bloc_utils.dart';
import 'package:keep_it_clean/models/user_model.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfilePageBloc extends Cubit<BlocState<KeepItCleanUser>> {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  DatabaseService _databaseService = locator<DatabaseService>();

  KeepItCleanUser _currentUser;

  int currentIndex = 0;

  ProfilePageBloc(BlocState<KeepItCleanUser> state) : super(state);

  StreamController<int> currentIndexStreamController = StreamController();

  dispose() {
    currentIndexStreamController?.close();
  }

  String getUsername() {
    return (_authService.currentUser != null)
        ? _authService.currentUser.name
        : tr("Utente ospite");
  }

  Future initProfilePageBloc() async {
    _currentUser = await retrieveUserInformation();
  }

  String getProfilePhotoUrl() {
    return _authService.currentUser.profilePic;
  }

  bool isUserLoggedIn() {
    return _authService.currentUser != null;
  }

  int getNumberOfReportsForType(int index) {
    Map<String, int> map = _currentUser?.reports;
    if (map == null) return 0;

    return map[typesOfBin[index]] ?? 0;
  }

  signOut(BuildContext context) async {
    DialogResponse response = await _dialogService.showDialog(
        title: tr('SIGN OUT'),
        description: tr("Vuoi davvero disconnetterti?"),
        cancelTitle: tr("NO"),
        buttonTitle: tr("SI"));

    if (response.confirmed) {
      _authService.logOut();
      AutoRouter.of(context)
          .pushAndPopUntil(LoginPageViewRoute(), predicate: (r) => false);
    }
  }

  Future<KeepItCleanUser> retrieveUserInformation() {
    if (_authService.currentUser != null)
      return _databaseService.retrieveUserInfo(
          reporterUid: _authService.currentUser.uid);
    //Gross, change later biatch
    return null;
  }
}
