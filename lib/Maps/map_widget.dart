import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/DatabaseServices/database_services.dart';
import 'package:keep_it_clean/Models/bin_model.dart';
import 'package:provider/provider.dart';

import 'marker_dialog.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng _lastPosition;
  static LatLng _defaultPos = LatLng(44.170147, 8.3438333);
  Completer<GoogleMapController> _controller = Completer();

  // Two sets of markers are needed to perform the markers filtering on screen
  Set<Marker> markers = Set.from([]);
  Set<Marker> notFilteredMarkers = Set.from([]);
  GoogleMapController controller;

  // Starting Google Maps camera position targeting Finale Ligure, Italy <3
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: _defaultPos,
    zoom: 14.4746,
  );

  //TODO: Avoid hardcoded value
//  void _initMarkers() {
//    db
//        .collection('cestini')
//        .where("lat",
//        isGreaterThan: _defaultPos.latitude - 0.05,
//        isLessThan: _defaultPos.latitude + 0.05)
//        .snapshots()
//        .listen((data) => data.documents.forEach((cestino) {
//      if (cestino['lng'] > _defaultPos.longitude - 0.05 &&
//          cestino['lng'] < _defaultPos.longitude + 0.05) {
//        LatLng l = new LatLng(cestino['lat'], cestino['lng']);
//        _addMarker(cestino.documentID, l, cestino['type']);
//      }
//    }));
//  }
  void _onMarkerTapped(MarkerId markerId) {
    LatLng _pos;

    // On tap retrieve data directly from Firebase
    Firestore.instance
        .collection('cestini')
        .document(markerId.value)
        .get()
        .then((DocumentSnapshot ds) {
      _pos = new LatLng(ds['lat'], ds['lng']);
      // if photoUrl is not null then we recover the photo from Firebase Storage

      final StorageReference storageReference =
          FirebaseStorage().ref().child(ds['photoUrl']);
      storageReference.getDownloadURL().then((img) {
        showDialog(
            context: context,
            builder: (context) {
              return createDialog(
                context,
                ds.documentID,
                img,
                _pos,
                ds['type'],
                ds['username'],
                ds['reportDate'],
              );
            });
      });
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
    _lastPosition = position.target;
  }

  void initMarkers() {
    markers.clear();
    if (Provider.of<List<Bin>>(context) != null) {
      if (Provider.of<TypeChanger>(context).getType() == 0) {
        Provider.of<List<Bin>>(context).forEach((bin) {
          _addMarker(bin.id, new LatLng(bin.latitude, bin.longitude), bin.type);
        });
      } else {
        Provider.of<List<Bin>>(context).forEach((bin) {
          if (bin.type == Provider.of<TypeChanger>(context).getType()) {
            _addMarker(
                bin.id, new LatLng(bin.latitude, bin.longitude), bin.type);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initMarkers();

    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      mapToolbarEnabled: false,
      initialCameraPosition: _kGooglePlex,
      markers: markers,
      onMapCreated: (controller) {
        _controller.complete(controller);
      },
      onCameraMove: _onCameraMove,
    );
  }
}
