import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class LocationService {
  Map<PermissionGroup, PermissionStatus> permissions;



// Request permission method from permissions_handlers plugin
  void requestPermission() async {
    permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
  }

  Future<bool> getLocationPermissionStatus() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    return permission == PermissionStatus.granted;
  }

  Future<LocationData> getUserLocation() async {
    return await Location().getLocation().timeout(Duration(seconds: 15),
        onTimeout: () {
      return null;
    });
  }
}
