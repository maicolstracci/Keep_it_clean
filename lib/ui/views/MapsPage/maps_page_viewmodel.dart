
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/models/bin_model.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/utils/utils.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/services/bin_details_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/services/location_service.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';



class MapsPageViewModel extends StreamViewModel<List<Bin>>{
  LocationService _locationService = locator<LocationService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  NavigationService _navigationService = locator<NavigationService>();
  BinDetailsService _binDetailsService = locator<BinDetailsService>();
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();

  GoogleMapController mapsController;
  Set<Marker> markers = Set.from([]);

  List<Bin> currentListOfBin = List<Bin>();
  String filterBinsForType;


  @override
  void onData(List<Bin> data) {
  currentListOfBin = data;
  }

  void setFilterBinsForType(String filter){
    if(filterBinsForType == filter){
      filterBinsForType = null;
    } else filterBinsForType = filter;

    notifyListeners();
  }

  bool isUserLoggedIn(){
    return _authService.currentUser != null;
  }

  void _addMarker(String id, LatLng latLng, String type) {


    final MarkerId markerId = MarkerId(id);
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      icon: pinMap[type],
      onTap: () => navigateToBinDetailsPage(id)
    );

    // adding a new marker to map
    markers.add(marker);
  }

  void navigateToBinDetailsPage(String binID){

    _binDetailsService.setBinID(binID);

    _navigationService.navigateTo(Routes.binDetailsPage);
  }

  void navigateToAddBinPage() {
    _navigationService.navigateTo(Routes.addBinPage);
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
      _locationService.requestPermission();
    }
    setBusy(false);
  }


  void filterBin(String type){
    _databaseService.typeOfBinToFilter = type;
    notifySourceChanged(clearOldData: true);
  }

  @override
  Stream<List<Bin>> get stream => _databaseService.binStream();

  showUserNoLoggedInDialog() {
    _dialogService.showDialog(
      title: "Accesso non consentito agli utenti ospiti",
      description: "Solo gli utenti che hanno effettuato l'accesso possono effettuare segnalazioni",

      buttonTitle: "Ho capito"
    );
  }




}