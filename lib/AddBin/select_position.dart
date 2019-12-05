import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:location/location.dart';

class SelectPosition extends StatefulWidget {
  @override
  _SelectPositionState createState() => _SelectPositionState();
}

class _SelectPositionState extends State<SelectPosition> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;
  Set<Marker> markers = Set.from([]);
  LatLng _lastPosition;
  GoogleMapController controller;

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  void getLocation() async {
    var location = new Location();

    currentLocation = await location.getLocation();

    final Marker marker = Marker(
      markerId: MarkerId("1337"),
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    _moveToPosition();

    setState(() {
      // adding a new marker to map
      markers.add(marker);
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(44.170147, 8.3438333),
    zoom: 14.4746,
  );

  Future<void> _moveToPosition() async {
    CameraPosition pos = CameraPosition(
        target: LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        ),
        zoom: 18);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(pos));
  }

  void _onCameraMove(CameraPosition position) {
    _lastPosition = position.target;

    final Marker marker = Marker(
      markerId: MarkerId("1337"),
      position: LatLng(_lastPosition.latitude, _lastPosition.longitude),
    );

    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green[300],
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Stack(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 40),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: false,
                          mapToolbarEnabled: false,
                          initialCameraPosition: _kGooglePlex,
                          markers: markers,
                          onMapCreated: (controller) {
                            _controller.complete(controller);
                          },
                          onCameraMove: _onCameraMove,
                        )),
                    Positioned(
                      top: 30,
                      left: 15,
                      right: 15,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 40),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),

                        ),
                        child: Text(
                            AppTranslations.of(context).text("position_string"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      AppTranslations.of(context).text("move_cursor_string"),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.pop(context, _lastPosition);
                      },
                      fillColor: Colors.white,
                      splashColor: Colors.green[400],
                      elevation: 0,
                      highlightElevation: 0,
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.85,
                          minHeight: 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200.0),
                      ),
                      child: Text(
                        AppTranslations.of(context)
                            .text("confirm_position_string"),
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
