import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/services/take_picture_service.dart';
import 'package:stacked/stacked.dart';

class PictureSelectionViewModel extends BaseViewModel {
  TakePictureService _takePictureService = locator<TakePictureService>();

  void takePicture(BuildContext context, String from) async {
    await _takePictureService.takePicture(from);

    if (_takePictureService.pic != null) {
      AutoRouter.of(context).push(SelectBinPositionViewRoute());
    }
  }
}
