import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginPageViewModel extends BaseViewModel{

  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  Future googleLogin() async{
    setBusy(true);
    await _authService.googleLogin();
    setBusy(false);

    if(_authService.currentUser != null){
      _navigateToNextPage();
    } else{
      _dialogService.showDialog(title: "Problema!",description: "Ez");
    }

  }

  Future facebookLogin() async {
    setBusy(true);
    await _authService.facebookLogin();
    setBusy(false);

    if(_authService.currentUser != null){
      _navigateToNextPage();
    } else{
      _dialogService.showDialog(title: "Problema!",description: "Ez");
    }
  }

  void guestLogin(){
    _navigateToNextPage();
  }

  void _navigateToNextPage() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if(!sharedPreferences.containsKey("returningUser")){

      await sharedPreferences.setBool('returningUser', true);
      _navigationService.replaceWith(Routes.onboardingPage);

    } else {
      _navigationService.replaceWith(Routes.mapsPage);
    }


  }

}