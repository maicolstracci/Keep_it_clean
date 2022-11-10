import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart' as perm;
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class LocationService {
  GeoFirePoint? currentUserGeoFirePoint;

  void setCurrentUserGeoFirePoint(
      {required double latitude, required double longitude}) {
    currentUserGeoFirePoint =
        Geoflutterfire().point(latitude: latitude, longitude: longitude);
  }

// Request permission method from permissions_handlers plugin
  void requestPermission() async {
    await Permission.location.request();
  }

  Future<bool> getLocationPermissionStatus() async {
    PermissionStatus permission = await Permission.location.status;
    return permission == PermissionStatus.granted;
  }

  Future<perm.LocationData?> getUserLocation() async {
    perm.LocationData userPosition = await perm.getLocation();

    setCurrentUserGeoFirePoint(
        latitude: userPosition.latitude!, longitude: userPosition.longitude!);

    return userPosition;
  }
}
