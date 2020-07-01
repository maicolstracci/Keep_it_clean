
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/models/bin_model.dart';
import 'package:keep_it_clean/models/illegal_waste_disposal_model.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/services/bin_details_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/reporter_profile_page_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class IllegalWasteDetailsViewModel extends FutureViewModel<IllegalWasteDisposal> {
  DatabaseService _databaseService = locator<DatabaseService>();
  BinDetailsService _binDetailsService = locator<BinDetailsService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  AuthService _authService = locator<AuthService>();

  String imageUrl;

  @override
  void onData(IllegalWasteDisposal data) async {
    super.onData(data);
    imageUrl =
    await _databaseService.getDownloadUrlImageFromName(data.photoUrl);
    notifyListeners();
  }

  showReportDialog() async {
    if(_authService.currentUser != null){
      DialogResponse response = await _dialogService.showConfirmationDialog(
          title: "C'e' qualche problema?",
          description: "Invia una segnalazione se qualcosa non va",
          cancelTitle: "No, non inviare",
          confirmationTitle: "Si, voglio segnalare");
      if(response.confirmed){
        _databaseService.reportBinProblem(data.id, _authService.currentUser);
      }
      return;
    } else {
      _dialogService.showDialog(title: "Utente non autenticato",
          description:
          "Solo gli utenti autenticati possono segnalare problemi",
          buttonTitle: "Ho capito");
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
  Future<IllegalWasteDisposal> futureToRun() =>
      _databaseService.getIllegalWasteDisposalInfo(_binDetailsService.reportID);

  navigateToReporterProfile() {
    _navigationService.navigateWithTransition(ReporterProfileView(reporterUid: data.uidUser,),
        transition: NavigationTransition.RightToLeft);
  }
}
