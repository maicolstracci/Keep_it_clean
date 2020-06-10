import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/services/add_bin_types_list_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/services/take_picture_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddBinPageViewModel extends BaseViewModel{



  TakePictureService _takePictureService = locator<TakePictureService>();
  NavigationService _navigationService = locator<NavigationService>();
  AddBinTypesListService _addBinTypesListService = locator<AddBinTypesListService>();

  get getTypesSelectedLength => _addBinTypesListService.typesSelected.length;

  void addOrRemoveTypeToList(int type) {
    _addBinTypesListService.addOrRemoveTypeToList(type);
    notifyListeners();
  }

  bool binTypesListContainsIndex(int index){
    return _addBinTypesListService.typesSelected.contains(index);
  }

  void takePicture() async {
    await _takePictureService.takePicture();

    if(_takePictureService.pic != null ){
        _navigationService.navigateTo(Routes.selectBinPositionPage);
    }

  }
}

//Future<void> takePicture() async {
//    compressedImage = await ImagePicker.pickImage(
//            source: ImageSource.camera, imageQuality: 30)
//        .catchError((e) {
//      print(e.code);
//      if (e.code == "camera_access_denied") {
//        _scaffoldKey.currentState.showSnackBar(SnackBar(
//          duration: Duration(seconds: 6),
//          content: Text(AppTranslations.of(context).text("camera_error")),
//          action: SnackBarAction(
//            label: AppTranslations.of(context).text("settings_string"),
//            onPressed: () {
//              PermissionHandler().openAppSettings();
//            },
//          ),
//        ));
//      }
//    });
//    if (compressedImage != null) {
//      LatLng lat = await Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => SelectPosition()),
//      );
//      if (lat != null) {
//        setState(() {
//          _uploadInProgress = true;
//        });
//        _uploadImage(compressedImage).then((imgName) async {
//          Bin bin = await addBin(_selected, imgName, lat);
//          Navigator.pop(context, bin);
//        });
//      }
//    }
//  }