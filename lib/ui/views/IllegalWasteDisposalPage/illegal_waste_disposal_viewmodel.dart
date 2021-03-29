import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/services/take_picture_service.dart';
import 'package:keep_it_clean/services/type_of_report_service.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';

class IllegalWasteDisposalViewModel extends BaseViewModel {
  TakePictureService _takePictureService = locator<TakePictureService>();
  TypeOfReportService _typeOfReportService = locator<TypeOfReportService>();

  void takePicture(BuildContext context, String from) async {
    await _takePictureService.takePicture(from);

    if (_takePictureService.pic != null) {
      _typeOfReportService.setTypeOfReport(type: Report.IllegalWaste);

      AutoRouter.of(context).push(SelectBinPositionViewRoute());
    }
  }
}
