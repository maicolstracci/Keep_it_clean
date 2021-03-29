import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/models/bin_model.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/services/bin_details_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/utils/bloc_utils.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class BinDetailsBloc extends Cubit<BlocState<Bin>> {
  DatabaseService _databaseService = locator<DatabaseService>();
  BinDetailsService _binDetailsService = locator<BinDetailsService>();
  DialogService _dialogService = locator<DialogService>();
  AuthService _authService = locator<AuthService>();

  Bin _currentBin;

  BinDetailsBloc(BlocState<Bin> state) : super(state);

  showReportDialog() async {
    if (_authService.currentUser != null) {
      DialogResponse response = await _dialogService.showConfirmationDialog(
          title: "C'e' qualche problema?",
          description: "Invia una segnalazione se qualcosa non va",
          cancelTitle: "No, non inviare",
          confirmationTitle: "Si, voglio segnalare");
      if (response.confirmed) {
        _databaseService.reportBinProblem(
            _currentBin.id, _authService.currentUser);
      }
      return;
    } else {
      _dialogService.showDialog(
          title: "Utente non autenticato",
          description: "Solo gli utenti autenticati possono segnalare problemi",
          buttonTitle: "Ho capito");
    }
  }

  launchMaps() async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${_currentBin.position.latitude},${_currentBin.position.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future getBinInfo() async {
    emit(BlocState(state: BlocStateEnum.LOADING));
    _currentBin = await _databaseService.getBinInfo(_binDetailsService.binID);
    emit(BlocState(state: BlocStateEnum.DONE, data: _currentBin));
  }

  navigateToReporterProfile(BuildContext context) {
    AutoRouter.of(context).push(
      ReporterProfileViewRoute(
        reporterUid: _currentBin.uidUser,
      ),
    );
  }
}
