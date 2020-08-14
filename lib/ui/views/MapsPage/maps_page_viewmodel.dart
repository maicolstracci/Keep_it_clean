import 'package:easy_localization/easy_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/models/bin_model.dart';
import 'package:keep_it_clean/models/illegal_waste_disposal_model.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/services/bin_details_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/services/location_service.dart';
import 'package:keep_it_clean/services/search_here_button_service.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/add_bin_page_view.dart';
import 'package:keep_it_clean/ui/views/BinDetailsPage/bin_details_view.dart';
import 'package:keep_it_clean/ui/views/IllegalWasteDisposalPage/illegal_waste_details_view.dart';
import 'package:keep_it_clean/ui/views/IllegalWasteDisposalPage/illegal_waste_disposal_view.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:keep_it_clean/utils/utils.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

const String _binDataKey = 'bin-data';
const String _illegalWasteDisposalKey = 'illegal-waste-disposal-stream';

class MapsPageViewModel extends MultipleStreamViewModel {
  LocationService _locationService = locator<LocationService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  NavigationService _navigationService = locator<NavigationService>();
  BinDetailsService _binDetailsService = locator<BinDetailsService>();
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();

  GoogleMapController mapsController;
  CameraPosition currentCameraPosition;

  Set<Marker> markers = Set.from([]);

  List<Bin> currentListOfBin = List<Bin>();
  List<IllegalWasteDisposal> currentListOfWasteDisposalReports =
      List<IllegalWasteDisposal>();

  String filterBinsForType;

  @override
  void onData(key, data) {
    if (key == _binDataKey) currentListOfBin = data;
    if (key == _illegalWasteDisposalKey)
      currentListOfWasteDisposalReports = data;
  }

  void setFilterBinsForType(String filter) {
    if (filterBinsForType == filter) {
      filterBinsForType = null;
    } else
      filterBinsForType = filter;

    notifyListeners();
  }

  bool isUserLoggedIn() {
    return _authService.currentUser != null;
  }

  void _addMarker(String id, LatLng latLng, String type) {
    final MarkerId markerId = MarkerId(id);
    // creating a new MARKER
    final Marker marker = Marker(
        markerId: markerId,
        position: latLng,
        icon: pinMap[type],
        onTap: type != abbandonoRifiuto
            ? (() => navigateToBinDetailsPage(id))
            : () => navigateToIllegalWasteDetailsPage(id));

    // adding a new marker to map
    markers.add(marker);
  }

  void navigateToBinDetailsPage(String binID) {
    _binDetailsService.setBinID(binID);

    _navigationService.navigateWithTransition(BinDetailsPageView(),
        transition: NavigationTransition.RightToLeft);
  }

  void navigateToIllegalWasteDetailsPage(String reportID) {
    _binDetailsService.setReportID(reportID);

    _navigationService.navigateWithTransition(IllegalWasteDetailsView(),
        transition: NavigationTransition.RightToLeft);
  }

  void navigateToAddBinPage() {
    _navigationService.navigateWithTransition(AddBinPageView(),
        transition: NavigationTransition.RightToLeft);
  }

  void setBinFilterType({String filterBinsForType}) {
    this.filterBinsForType = filterBinsForType;
    notifyListeners();
  }

  Set<Marker> getMarkersSetWithFiltering() {
    markers.clear();
    for (Bin bin in currentListOfBin) {
      if (filterBinsForType == null || bin.type == filterBinsForType) {
        _addMarker(
            bin.id,
            new LatLng(bin.position.latitude, bin.position.longitude),
            bin.type);
      }
    }
    if (dataReady(_illegalWasteDisposalKey) && filterBinsForType == null) {
      for (IllegalWasteDisposal illegalWasteDisposal
          in currentListOfWasteDisposalReports) {
        _addMarker(
            illegalWasteDisposal.id,
            LatLng(illegalWasteDisposal.position.latitude,
                illegalWasteDisposal.position.longitude),
            abbandonoRifiuto);
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

        _dialogService.showDialog(
            title: tr("Si e' verificato un errore"),
            description: tr(
                "Non siamo riusciti a calcolare la tua posizione attuale.\nProbabilmente sei in un'area con un segnale debole."),
            buttonTitle: tr("Ho capito"));

        return;
      } else {
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
    notifySourceChanged();
  }

  void filterBin(String type) {
    _databaseService.typeOfBinToFilter = type;
    notifySourceChanged(clearOldData: true);
  }

  searchHereButtonAction() {
    if (currentCameraPosition == null) return;

    _locationService.setCurrentUserGeoFirePoint(
        latitude: currentCameraPosition.target.latitude,
        longitude: currentCameraPosition.target.longitude);

    locator<SearchHereButtonService>().setVisibility(false);

    notifySourceChanged(clearOldData: true);
  }

  @override
  Map<String, StreamData> get streamsMap => {
        _binDataKey: StreamData<List<Bin>>(
            _databaseService.binStreamFromPosition(
                currentUserPoint: _locationService.currentUserGeoFirePoint)),
        _illegalWasteDisposalKey: StreamData<List<IllegalWasteDisposal>>(
            _databaseService.illegalWasteDisposalStreamFromPosition(
                currentUserPoint: _locationService.currentUserGeoFirePoint)),
      };

  showUserNoLoggedInDialog() {
    _dialogService.showDialog(
        title: tr("Accesso non consentito agli utenti ospiti"),
        description: tr(
            "Solo gli utenti che hanno effettuato l'accesso possono effettuare segnalazioni"),
        buttonTitle: tr("Ho capito"));
  }

  showComingSoonReportFeatureDialog() {
    _dialogService.showDialog(
        title: tr("Funzionalita' in arrivo!"),
        description: tr(
            "A breve introdurremo la possibilita' di segnalare rifiuti abbandonati"),
        buttonTitle: tr("Ho capito"));
  }

  navigateToReportIllegalWasteDisposal() {
    _navigationService.navigateWithTransition(IllegalWasteDisposalView(),
        transition: NavigationTransition.RightToLeft);
  }

  setCameraPosition(CameraPosition cameraPosition) {
    this.currentCameraPosition = cameraPosition;
    searchHereButtonVisibility();
  }

  void searchHereButtonVisibility() {
    SearchHereButtonService _searchHereService =
        locator<SearchHereButtonService>();

    if (_locationService.currentUserGeoFirePoint == null) {
      if (_searchHereService.visibility != true)
        _searchHereService.setVisibility(true);
      return;
    }
    if (currentCameraPosition != null &&
        _locationService.currentUserGeoFirePoint.distance(
                lat: currentCameraPosition.target.latitude,
                lng: currentCameraPosition.target.longitude) >
            6) {
      if (_searchHereService.visibility != true)
        _searchHereService.setVisibility(true);
      return;
    }
    if (_searchHereService.visibility != false)
      _searchHereService.setVisibility(false);
    return;
  }
}
