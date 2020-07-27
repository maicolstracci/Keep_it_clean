import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/take_picture_service.dart';
import 'package:keep_it_clean/services/type_of_report_service.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/select_bin_position_view.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';


class IllegalWasteDisposalViewModel extends BaseViewModel{
  NavigationService _navigationService = locator<NavigationService>();
  TakePictureService _takePictureService = locator<TakePictureService>();
  TypeOfReportService _typeOfReportService = locator<TypeOfReportService>();

  void takePicture(String from) async {
    await _takePictureService.takePicture(from);

    if(_takePictureService.pic != null ){
      _typeOfReportService.setTypeOfReport(type: Report.IllegalWaste);
      _navigationService.navigateWithTransition(SelectBinPositionView(),transition: NavigationTransition.RightToLeft);
    }
  }
}