
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/DatabaseServices/database_services.dart';
import 'package:keep_it_clean/Models/bin_model.dart';
import 'package:keep_it_clean/Utils/utils.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/location_service.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';



class MapsPageViewModel extends StreamViewModel<List<Bin>>{
  LocationService _locationService = locator<LocationService>();
  DatabaseService _databaseService = locator<DatabaseService>();

  GoogleMapController mapsController;
  Set<Marker> markers = Set.from([]);



  @override
  void onData(List<Bin> data) {
    markers.clear();
    for(Bin bin in data){
      print('$bin');
      _addMarker(bin.id, new LatLng(bin.position.latitude, bin.position.longitude), bin.type);
    }
  }


  void _addMarker(String id, LatLng latLng, int type) {
    final MarkerId markerId = MarkerId(id);
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      icon: pinMap[type],
    );

    // adding a new marker to map
    markers.add(marker);
  }

  Future addBin() async{
    print('press');
    await _databaseService.createBin(1, "v", LatLng(44.191548, 8.284462));

  }

  Future moveCameraToUserLocation() async {
    setBusy(true);
    if (await _locationService.getLocationPermissionStatus()) {

      LocationData location = await _locationService.getUserLocation();

      if (location == null) {
        //TODO: cant find user location, show error...
        setBusy(false);
        return;
      } else{

        CameraPosition _userCameraPosition = CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 14.4746,
        );
        setBusy(false);
        await mapsController
            .animateCamera(CameraUpdate.newCameraPosition(_userCameraPosition));
      }
    } else {
      //TODO: we dont have user permission to track location, show dialog explaining and asking to turn it on
    }
    setBusy(false);
  }


  void filterBin(int type){
    _databaseService.typeOfBinToFilter = type;
    notifySourceChanged(clearOldData: true);
  }

  @override
  Stream<List<Bin>> get stream => _databaseService.binStream();
}