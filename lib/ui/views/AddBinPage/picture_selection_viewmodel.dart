import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/take_picture_service.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/select_bin_position_view.dart';
import 'package:stacked/stacked.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:stacked_services/stacked_services.dart';

class PictureSelectionViewModel extends BaseViewModel{

  TakePictureService _takePictureService = locator<TakePictureService>();
  NavigationService _navigationService = locator<NavigationService>();

  void takePicture(String from) async {
    await _takePictureService.takePicture(from);

    if(_takePictureService.pic != null ){
      _navigationService.navigateWithTransition(SelectBinPositionView(),transition: NavigationTransition.RightToLeft);
    }

  }

}