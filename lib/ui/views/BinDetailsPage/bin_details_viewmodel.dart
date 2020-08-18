import 'package:easy_localization/easy_localization.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/models/bin_model.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/services/bin_details_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/reporter_profile_page_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class BinDetailsPageViewModel extends FutureViewModel<Bin> {
  DatabaseService _databaseService = locator<DatabaseService>();
  BinDetailsService _binDetailsService = locator<BinDetailsService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  AuthService _authService = locator<AuthService>();

  String imageUrl;

  @override
  void onData(Bin data) async {
    super.onData(data);
    imageUrl =
        await _databaseService.getDownloadUrlImageFromName(data.photoUrl);
    notifyListeners();
  }

  //TODO: Add translations
  showReportDialog() async {
    if (_authService.currentUser != null) {
      DialogResponse response = await _dialogService.showConfirmationDialog(
          title: "C'e' qualche problema?",
          description: "Invia una segnalazione se qualcosa non va",
          cancelTitle: "No, non inviare",
          confirmationTitle: "Si, voglio segnalare",
      barrierDismissible: true);

      if (response.confirmed) {
        _databaseService.reportBinProblem(data.id, _authService.currentUser);
      }
      return;
    } else {
      _dialogService.showDialog(
          title: "Utente non autenticato",
          description: tr(
              "Solo gli utenti che hanno effettuato l'accesso possono effettuare segnalazioni"),
          buttonTitle: "Ho capito",
      barrierDismissible: true);
    }
  }

  launchMaps() async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${data.position.latitude},${data.position.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Future<Bin> futureToRun() =>
      _databaseService.getBinInfo(_binDetailsService.binID);

  navigateToReporterProfile() {
    _navigationService.navigateWithTransition(
        ReporterProfileView(
          reporterUid: data.uidUser,
        ),
        transition: NavigationTransition.RightToLeft);
  }
}
