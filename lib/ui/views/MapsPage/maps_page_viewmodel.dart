
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'file:///C:/Users/Maicol/AndroidStudioProjects/keep_it_clean/lib/services/database_services.dart';
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

  List<Bin> currentListOfBin = List<Bin>();
  String filterBinsForType;


  @override
  void onData(List<Bin> data) {
//    markers.clear();
//    for(Bin bin in data){
//      _addMarker(bin.id, new LatLng(bin.position.latitude, bin.position.longitude), bin.type);
//    }
  currentListOfBin = data;
  }

  void setFilterBinsForType(String filter){
    if(filterBinsForType == filter){
      filterBinsForType = null;
    } else filterBinsForType = filter;

    print('IN SET FILTER -> $filter FILTERBINS ->$filterBinsForType');

    notifyListeners();
  }

  void _addMarker(String id, LatLng latLng, String type) {
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

    await _databaseService.createBin("vetro", "v", LatLng(44.231548, 8.364462));

  }

  void setBinFilterType({String filterBinsForType}){

    this.filterBinsForType = filterBinsForType;
    print('${this.filterBinsForType}');
    notifyListeners();
  }

  Set<Marker> getMarkersSetWithFiltering(){
    markers.clear();
    for(Bin bin in currentListOfBin){
      if(filterBinsForType == null || bin.type == filterBinsForType){
        _addMarker(bin.id, new LatLng(bin.position.latitude, bin.position.longitude), bin.type);
      }
    }
    return markers;
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


  void filterBin(String type){
    _databaseService.typeOfBinToFilter = type;
    notifySourceChanged(clearOldData: true);
  }

  @override
  Stream<List<Bin>> get stream => _databaseService.binStream();
}