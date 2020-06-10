import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';

class ProfilePageViewModel extends BaseViewModel{

  AuthService _authService = locator<AuthService>();

  String getUsername(){
    return _authService.currentUser.name;
  }

  String getProfilePhotoUrl(){
    return _authService.currentUser.profilePic;
  }

  int getNumberOfReportsForType(int index){
    Map<String, int> map = _authService.currentUser.binReportMap;
    if(map == null) return 0;

    return map[typesOfBin[index]] ?? 0;
  }

}