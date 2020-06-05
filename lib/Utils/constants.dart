import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


Color mainGreen = Color(0xff06442d);

// Starting Google Maps camera position targeting Finale Ligure, Italy <3
final CameraPosition initialCameraPosition = CameraPosition(
  target: LatLng(44.170147, 8.3438333),
  zoom: 14.4746,
);


