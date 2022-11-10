import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/services/add_bin_types_list_service.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/services/location_service.dart';
import 'package:keep_it_clean/services/take_picture_service.dart';
import 'package:keep_it_clean/services/type_of_report_service.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectBinPositionViewModel extends BaseViewModel {
  late GoogleMapController mapsController;
  Set<Marker> markers = Set.from([]);

  bool errorLoadingLocation = false;
  bool uploading = false;

  late LatLng currentLatLng;

  DatabaseService _databaseService = locator<DatabaseService>();
  LocationService _locationService = locator<LocationService>();
  TakePictureService _takePictureService = locator<TakePictureService>();
  AddBinTypesListService _addBinTypesListService =
      locator<AddBinTypesListService>();
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  TypeOfReportService _typeOfReportService = locator<TypeOfReportService>();

  Future moveCameraToUserLocation(BuildContext context) async {
    setBusy(true);
    if (await _locationService.getLocationPermissionStatus()) {
      LocationData? location = await _locationService.getUserLocation();

      if (location == null) {
        errorLoadingLocation = true;
        setBusy(false);
        return;
      } else {
        errorLoadingLocation = false;

        currentLatLng = LatLng(location.latitude!, location.longitude!);

        CameraPosition _userCameraPosition = CameraPosition(
          target: currentLatLng,
          zoom: 24.4746,
        );

        markers.add(Marker(
          markerId: MarkerId("1337"),
          position: currentLatLng,
        ));
        setBusy(false);
        await mapsController
            .animateCamera(CameraUpdate.newCameraPosition(_userCameraPosition));
      }
    } else {
      DialogResponse? dialogResponse = await _dialogService.showConfirmationDialog(
          title: tr("Permessi di localizzazione disattivati"),
          description: tr(
              "E' necessario fornire i permessi di localizzazione per completare l'operazione"),
          cancelTitle: tr("Non voglio"),
          confirmationTitle: tr("Portami alle impostazioni"));
      if (dialogResponse!.confirmed) {
        await openAppSettings();
      } else {
        if (_takePictureService.pic != null)
          //TODO: da capire per xfile anziche' File
          // await _takePictureService.pic.delete();
          _addBinTypesListService.typesSelected.clear();
        AutoRouter.of(context)
            .pushAndPopUntil(MapsPageViewRoute(), predicate: (r) => false);
      }
    }
    setBusy(false);
  }

  onCameraMove(CameraPosition cameraPosition) {
    currentLatLng =
        LatLng(cameraPosition.target.latitude, cameraPosition.target.longitude);

    markers.clear();
    markers.add(Marker(
      markerId: MarkerId("1337"),
      position: currentLatLng,
    ));
    notifyListeners();
  }

  uploadReport(BuildContext context) {
    if (_typeOfReportService.typeOfReport == Report.Bin) {
      createBinReport(context);
    } else if (_typeOfReportService.typeOfReport == Report.IllegalWaste) {
      createIllegalWasteDisposalReport(context);
    } else {
      //TODO: show error message + xfile
      // _takePictureService.pic.delete();
    }
  }

  createBinReport(BuildContext context) async {
    // uploading = true;
    // notifyListeners();
    //
    // String _imgName = '${_authService.currentUser?.uid}-${DateTime.now()}';
    // //Todo: image
    // // String img = await _databaseService.uploadImage(
    // //     imgFile: _takePictureService.pic, imgName: _imgName);
    //
    // for (int type in _addBinTypesListService.typesSelected) {
    //   await _databaseService.createBin(
    //       type: typesOfBin[type],
    //       imgName: img,
    //       binPos: currentLatLng,
    //       user: _authService.currentUser);
    // }
    // await _databaseService.addPoints(
    //     _authService.currentUser, _addBinTypesListService.typesSelected);
    //
    // _addBinTypesListService.typesSelected.clear();
    // uploading = false;
    //
    // AutoRouter.of(context)
    //     .pushAndPopUntil(MapsPageViewRoute(), predicate: (r) => false);
  }

  createIllegalWasteDisposalReport(BuildContext context) async {
    //   uploading = true;
    //   notifyListeners();
    //
    //   String _imgName = '${_authService.currentUser.uid}-${DateTime.now()}';
    //   String img = await _databaseService.uploadImage(
    //       imgFile: _takePictureService.pic, imgName: _imgName);
    //
    //   _databaseService.createIllegalWasteDisposalReport(
    //       imgName: img, binPos: currentLatLng, user: _authService.currentUser);
    //
    //   uploading = false;
    //
    //   AutoRouter.of(context)
    //       .pushAndPopUntil(MapsPageViewRoute(), predicate: (r) => false);
  }
}
