import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfilePageViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();

  String getUsername() {
    return (_authService.currentUser != null)
        ? _authService.currentUser.name
        : "Utente ospite";
  }

  String getProfilePhotoUrl() {
    return _authService.currentUser.profilePic;
  }

  bool isUserLoggedIn() {
    return _authService.currentUser != null;
  }

  int getNumberOfReportsForType(int index) {
    Map<String, int> map = _authService.currentUser.binReportMap;
    if (map == null) return 0;

    return map[typesOfBin[index]] ?? 0;
  }

  navigateToLoginPage() {
    _navigationService.clearStackAndShow(Routes.loginPage);
  }

  signOut() async {
    DialogResponse response = await _dialogService.showDialog(
        title: "SIGN OUT",
        description: "Vuoi davvero disconnetterti?",
        cancelTitle: "NO",
        buttonTitle: "SI");

    if(response.confirmed){
      _authService.signOut();
      _navigationService.clearStackAndShow(Routes.loginPage);
    }
  }
}
