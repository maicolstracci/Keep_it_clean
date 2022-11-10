import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/utils/utils.dart';

class StartupBloc extends Cubit<void> {
  final AuthService _authenticationService = locator<AuthService>();

  var hasLoggedInUser;

  BuildContext? context;

  StartupBloc(state, {this.context}) : super(state);

  Future<void> minimumTimeWait(Duration duration) async {
    await Future.delayed(duration, () {});
  }

  Future handleStartUpLogic() async {
    await Future.wait<dynamic>([
      setCustomMapPin(),
      hasLoggedInUser = _authenticationService.isUserLoggedIn(),
      minimumTimeWait(Duration(seconds: 3)),
    ]);
  }
}
