import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/type_of_report_service.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/picture_selection_view.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:keep_it_clean/app/router.gr.dart';


class IllegalWasteDisposalViewModel extends BaseViewModel{
  NavigationService _navigationService = locator<NavigationService>();
  TypeOfReportService _typeOfReportService = locator<TypeOfReportService>();


  navigateToTakePicture() {
    _typeOfReportService.setTypeOfReport(type: Report.IllegalWaste);
    _navigationService.navigateWithTransition(PictureSelectionView(),transition: NavigationTransition.RightToLeft);
  }

}