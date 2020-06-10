import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/services/add_bin_types_list_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/services/location_service.dart';
import 'package:keep_it_clean/services/take_picture_service.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectBinPositionViewModel extends BaseViewModel{

  GoogleMapController mapsController;
  Set<Marker> markers = Set.from([]);

  LatLng currentLatLng;

  DatabaseService _databaseService = locator<DatabaseService>();
  LocationService _locationService = locator<LocationService>();
  TakePictureService _takePictureService = locator<TakePictureService>();
  AddBinTypesListService _addBinTypesListService = locator<AddBinTypesListService>();
  NavigationService _navigationService = locator<NavigationService>();

  Future moveCameraToUserLocation() async {
    setBusy(true);
    if (await _locationService.getLocationPermissionStatus()) {

      LocationData location = await _locationService.getUserLocation();

      if (location == null) {
        //TODO: cant find user location, show error...
        setBusy(false);
        return;
      } else{
        currentLatLng = LatLng(location.latitude, location.longitude);

        CameraPosition _userCameraPosition = CameraPosition(
          target: currentLatLng,
          zoom: 14.4746,
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
      //TODO: we dont have user permission to track location, show dialog explaining and asking to turn it on
    }
    setBusy(false);
  }

  onCameraMove(CameraPosition cameraPosition) {
    currentLatLng = LatLng(cameraPosition.target.latitude, cameraPosition.target.longitude);

    markers.clear();
    markers.add(Marker(
      markerId: MarkerId("1337"),
      position: currentLatLng,
    ));
    notifyListeners();
  }

  createBin() async {

    //TODO: add indicator that we are uploading stuff...
    print('Uploading img');
    String img = await _databaseService.uploadImage(_takePictureService.pic);
    print('Finished uploading img');
    print('Creating bin');

    for(int type in _addBinTypesListService.typesSelected){
      _databaseService.createBin(typesOfBin[type], img, currentLatLng);
    }
    _addBinTypesListService.typesSelected.clear();

    _navigationService.clearStackAndShow(Routes.mapsPage);



  }

}