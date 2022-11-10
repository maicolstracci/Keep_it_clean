import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/bloc/bloc_utils.dart';
import 'package:keep_it_clean/models/user_model.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/ui/views/LoginPage/login_button.dart';
import 'package:keep_it_clean/utils/appconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginBloc extends Cubit<BlocState> {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();

  LoginBloc(BlocState state) : super(state);

  bool get appleSignInAvailable => _authService.appleSignInAvailable;

  KeepItCleanUser? get currentUser => _authService.currentUser;

  Future performLogin(
    BuildContext context,
    LoginButtonType buttonType,
  ) async {
    emit(BlocState<bool>(state: BlocStateEnum.LOADING));
    switch (buttonType) {
      case LoginButtonType.GOOGLE:
        await _authService.googleLogin();
        break;
      // case LoginButtonType.APPLE:
      //   await _authService.appleLogin();
      //   break;
      case LoginButtonType.GUEST:
        _navigateToNextPage(context);
        break;
    }
    emit(BlocState<bool>(state: BlocStateEnum.DONE));
    if (_authService.currentUser != null) {
      _navigateToNextPage(context);
    } else {
      _dialogService.showDialog(
          title: tr("Problema con il login!"),
          description: tr("Qualcosa e' andato storto, riprova tra poco."));
    }
  }

  void _navigateToNextPage(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (!sharedPreferences.containsKey("returningUser") ||
        AppConfig.alwaysShowOnBoarding) {
      await sharedPreferences.setBool('returningUser', true);
      AutoRouter.of(context).replace(OnboardingViewRoute());
    } else {
      AutoRouter.of(context).replace(MapsPageViewRoute());
    }
  }
}
