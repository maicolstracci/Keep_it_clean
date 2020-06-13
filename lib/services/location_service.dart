import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class LocationService {

// Request permission method from permissions_handlers plugin
  void requestPermission() async {
    await Permission.location.request();
  }

  Future<bool> getLocationPermissionStatus() async {
    PermissionStatus permission = await Permission.location.status;
    return permission == PermissionStatus.granted;
  }

  Future<LocationData> getUserLocation() async {
    return await Location().getLocation().timeout(Duration(seconds: 15),
        onTimeout: () {
      return null;
    });
  }
}
