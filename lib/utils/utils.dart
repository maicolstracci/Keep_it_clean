import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

Map<String, BitmapDescriptor> pinMap = Map();

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
      .buffer
      .asUint8List();
}


Future<bool> setCustomMapPin() async {
  for (int i = 1; i <= typesOfBin.length; i++) {
    Uint8List val =
    await getBytesFromAsset('assets/maps_markers/marker_$i.png', (400/3).floor());
    BitmapDescriptor pinLocationIcon = BitmapDescriptor.fromBytes(val);

    pinMap[typesOfBin[i-1]] = pinLocationIcon;
  }
  return true;
}




// Request permission method from permissions_handlers plugin
Future requestPermission() async {
  await Permission.location.request();
}

Future<bool> getLocationPermissionStatus() async {
  PermissionStatus permission = await Permission.location.status;
  return permission == PermissionStatus.granted;
}


class FilterListBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}


