import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/services/add_bin_types_list_service.dart';
import 'package:keep_it_clean/services/type_of_report_service.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';

class AddBinPageViewModel extends BaseViewModel {
  AddBinTypesListService _addBinTypesListService =
      locator<AddBinTypesListService>();
  TypeOfReportService _typeOfReportService = locator<TypeOfReportService>();

  get getTypesSelectedLength => _addBinTypesListService.typesSelected.length;

  void addOrRemoveTypeToList(int type) {
    _addBinTypesListService.addOrRemoveTypeToList(type);
    notifyListeners();
  }

  bool binTypesListContainsIndex(int index) {
    return _addBinTypesListService.typesSelected.contains(index);
  }

  navigateToPictureSelection(BuildContext context) {
    _typeOfReportService.setTypeOfReport(type: Report.Bin);
    AutoRouter.of(context).push(PictureSelectionViewRoute());
  }
}
