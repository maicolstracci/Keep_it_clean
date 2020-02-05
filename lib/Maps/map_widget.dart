import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/DatabaseServices/database_services.dart';
import 'package:keep_it_clean/Maps/searchbutton_widget.dart';
import 'package:keep_it_clean/Models/bin_model.dart';
import 'package:keep_it_clean/Utils/utils.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'marker_dialog.dart';

class MapWidget extends StatefulWidget {
  final List<Bin> binList;

  const MapWidget({Key key, this.binList}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static LatLng _defaultPos = LatLng(44.170147, 8.3438333);

  // Two sets of markers are needed to perform the markers filtering on screen
  Set<Marker> markers = Set.from([]);
  GoogleMapController mapsController;
  static LatLng _userLocation;
  LatLng _oldLocation;

  bool _showLoadingLocation = true;

  // Starting Google Maps camera position targeting Finale Ligure, Italy <3
  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: _defaultPos,
    zoom: 14.4746,
  );

  static final CameraPosition _userCameraPosition = CameraPosition(
    target: _userLocation,
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
  }

  void _onMarkerTapped(MarkerId markerId) async {
    Bin bin = await DatabaseService().getBinInfo(markerId);
    String img = await DatabaseService().getImageFromUrl(bin.photoUrl);

    showDialog(
        context: context,
        builder: (context) {
          return createDialog(
              context,
              bin.id,
              img,
              LatLng(bin.latitude, bin.longitude),
              bin.type,
              bin.username,
              bin.reportDate);
        });
  }

  void _addMarker(String id, LatLng latLng, int type) {
    bool positionChanged = false;
    LatLng alteredPos;

    var markerColor;
    switch (type) {
      case 1:
        markerColor = BitmapDescriptor.hueRed;
        break;
      case 2:
        markerColor = BitmapDescriptor.hueGreen;
        break;
      case 3:
        markerColor = BitmapDescriptor.hueYellow;
        break;
      case 4:
        markerColor = BitmapDescriptor.hueOrange;
        break;
      case 5:
        markerColor = BitmapDescriptor.hueBlue;
        break;
      case 6:
        markerColor = BitmapDescriptor.hueRose;
        break;
      case 7:
        markerColor = BitmapDescriptor.hueMagenta;
        break;
      case 8:
        markerColor = BitmapDescriptor.hueViolet;
        break;
    }

    final MarkerId markerId = MarkerId(id);

    // Offset marker position to avoid stacking
    markers.forEach((marker) {
      if (marker.position == latLng) {
        int rng = Random().nextInt(5);
        if (rng == 0) rng = 1;
        double offset = (rng / 100000);

        switch (rng) {
          case 1:
            alteredPos =
                new LatLng(latLng.latitude + offset, latLng.longitude + offset);
            break;
          case 2:
            alteredPos =
                new LatLng(latLng.latitude + offset, latLng.longitude - offset);
            break;
          case 3:
            alteredPos =
                new LatLng(latLng.latitude - offset, latLng.longitude + offset);
            break;
          case 4:
            alteredPos =
                new LatLng(latLng.latitude - offset, latLng.longitude - offset);
            break;
        }
        positionChanged = true;
      }
    });

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: positionChanged ? alteredPos : latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
      onTap: () {
        // markerId is used as a reference to the marker in the Firebase db
        _onMarkerTapped(markerId);
      },
    );

    // adding a new marker to map
    markers.add(marker);
  }

  void _onCameraMove(CameraPosition position) {
    LatLng currentPos;

    if (_oldLocation != null) {
      currentPos = _oldLocation;
    } else {
      currentPos = _userLocation;
    }

    if (_userLocation != null) {
      LatLng target = position.target;
      if (target.latitude >= currentPos.latitude + 0.5 ||
          target.latitude <= currentPos.latitude - 0.5 ||
          target.longitude >= currentPos.longitude + 0.5 ||
          target.longitude <= currentPos.longitude - 0.5) {
        Provider.of<SearchButtonChanger>(context, listen: false)
            .setVisibility(true);
      }
    }
  }

  Future<void> filterMarkers() async {
    Provider.of<TypeChanger>(context, listen: false)
        .setVisibleArea(await mapsController.getVisibleRegion());
    setState(() {});
  }

  void showMarkers(LatLngBounds area) {
    markers.clear();

    if (widget.binList != null && _userLocation != null) {
      if (Provider.of<TypeChanger>(context).getType() == 0) {
        widget.binList.forEach((bin) {
          if (area == null &&
              bin.latitude >= _userLocation.latitude - 0.5 &&
              bin.latitude <= _userLocation.latitude + 0.5 &&
              bin.longitude >= _userLocation.longitude - 0.5 &&
              bin.longitude <= _userLocation.longitude + 0.5) {
            _addMarker(
                bin.id, new LatLng(bin.latitude, bin.longitude), bin.type);
          } else {
            if (area != null &&
                bin.latitude >= area.southwest.latitude &&
                bin.latitude <= area.northeast.latitude &&
                bin.longitude >= area.southwest.longitude &&
                bin.longitude <= area.northeast.longitude) {
              _addMarker(
                  bin.id, new LatLng(bin.latitude, bin.longitude), bin.type);
            }
          }
        });
      } else {
        widget.binList.forEach((bin) {
          if (bin.type == Provider.of<TypeChanger>(context).getType()) {
            if (area == null &&
                bin.latitude >= _userLocation.latitude - 0.5 &&
                bin.latitude <= _userLocation.latitude + 0.5 &&
                bin.longitude >= _userLocation.longitude - 0.5 &&
                bin.longitude <= _userLocation.longitude + 0.5) {
              _addMarker(
                  bin.id, new LatLng(bin.latitude, bin.longitude), bin.type);
            } else {
              if (area != null &&
                  bin.latitude >= area.southwest.latitude &&
                  bin.latitude <= area.northeast.latitude &&
                  bin.longitude >= area.southwest.longitude &&
                  bin.longitude <= area.northeast.longitude) {
                _addMarker(
                    bin.id, new LatLng(bin.latitude, bin.longitude), bin.type);
              }
            }
          }
        });
      }
    }
  }

  Future<void> moveToUserLocation() async {
    if(await getLocationPermissionStatus()){
      LocationData location = await Location().getLocation();

      _userLocation = new LatLng(location.latitude, location.longitude);
    } else _userLocation = _defaultPos;


    await mapsController
        .animateCamera(CameraUpdate.newCameraPosition(_userCameraPosition));

    setState(() {
      _showLoadingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    showMarkers(
        Provider.of<TypeChanger>(context, listen: false).getVisibleArea());

    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          initialCameraPosition: _initialCameraPosition,
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            mapsController = controller;
            moveToUserLocation();

          },
          onCameraMove: _onCameraMove,
        ),
        SearchButtonWidget(filterMarkers),
        Visibility(
          visible: _showLoadingLocation,
          child: Center(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40)
                ),

                height: 180,
                width: MediaQuery.of(context).size.width*0.80,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Stiamo calcolando la tua posizione...", textAlign: TextAlign.center,),
                    CircularProgressIndicator(strokeWidth: 4,)
                  ],
                )),
          ),
        )
      ],
    );
  }
}
