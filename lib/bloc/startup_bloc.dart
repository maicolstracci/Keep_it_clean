import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/utils/utils.dart';

class StartupBloc extends Cubit<void> {
  final AuthService _authenticationService = locator<AuthService>();
  BuildContext context;

  StartupBloc(state, {this.context}) : super(state);

  Future<void> minimumTimeWait(Duration duration) async {
    await Future.delayed(duration, () {});
  }

  Future handleStartUpLogic(
      BuildContext context,
      AnimationController controller,
      AnimationController animationContController,
      AnimationController opacityController) async {
    var hasLoggedInUser;

    await Future.wait([
      locator<AuthService>().retriveAppleSignInAvailable(),
      setCustomMapPin(),
      hasLoggedInUser = _authenticationService.isUserLoggedIn(),
      minimumTimeWait(Duration(seconds: 3)),
    ]);

    animationContController.stop();
    controller.reverse();

    opacityController.reverse().then(
      (value) async {
        if (await hasLoggedInUser) {
          AutoRouter.of(context).replace(MapsPageViewRoute());
        } else {
          AutoRouter.of(context).replace(LoginPageViewRoute());
        }
      },
    );
  }
}
