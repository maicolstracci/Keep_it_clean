import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/services/add_bin_types_list_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/services/take_picture_service.dart';
import 'package:keep_it_clean/services/type_of_report_service.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/picture_selection_view.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddBinPageViewModel extends BaseViewModel{

  NavigationService _navigationService = locator<NavigationService>();
  AddBinTypesListService _addBinTypesListService = locator<AddBinTypesListService>();
  TypeOfReportService _typeOfReportService = locator<TypeOfReportService>();

  get getTypesSelectedLength => _addBinTypesListService.typesSelected.length;

  void addOrRemoveTypeToList(int type) {
    _addBinTypesListService.addOrRemoveTypeToList(type);
    notifyListeners();
  }

  bool binTypesListContainsIndex(int index){
    return _addBinTypesListService.typesSelected.contains(index);
  }

  navigateToPictureSelection(){
    _typeOfReportService.setTypeOfReport(type: Report.Bin);
    _navigationService.navigateWithTransition(PictureSelectionView(),transition: NavigationTransition.RightToLeft);
  }

}
