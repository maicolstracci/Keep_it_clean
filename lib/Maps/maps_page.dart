import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/AddBin/add_bin_page.dart';
import 'package:keep_it_clean/Maps/marker_dialog.dart';
import 'package:keep_it_clean/ProfilePage/profile_page.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'search_widget.dart';



class Maps extends StatefulWidget {
  final FirebaseUser user;

  const Maps({Key key, this.user}) : super(key:key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {

  LatLng _lastPosition;
  Completer<GoogleMapController> _controller = Completer();
  // Two sets of markers are needed to perform the markers filtering on screen
  Set<Marker> markers = Set.from([]);
  Set<Marker> notFilteredMarkers = Set.from([]);

  GoogleMapController controller;

  @override
  void initState() {
    super.initState();
    _initMarkers();
    requestPermission();
  }

  // Request permission method from permissions_handlers plugin
  void requestPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
  }

  // Starting Google Maps camera position targeting Finale Ligure, Italy <3
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(44.170147, 8.3438333),
    zoom: 14.4746,
  );

  void _initMarkers() {
    Firestore.instance
        .collection('cestini')
        .snapshots()
        .listen((data) => data.documents.forEach((cestino) {
      LatLng l = new LatLng(cestino['lat'], cestino['lng']);
      _addMarker(cestino.documentID, l, cestino['type']);
    }));
  }

  void _onMarkerTapped(MarkerId markerId) {
    LatLng _pos;

    // On tap retrieve data directly from Firebase
    Firestore.instance
        .collection('cestini')
        .document(markerId.value)
        .get()
        .then((DocumentSnapshot ds) {
      _pos =  new LatLng(ds['lat'], ds['lng']);
      // if photoUrl is not null then we recover the photo from Firebase Storage
      if (ds['photoUrl'] != null) {
        final StorageReference storageReference =
        FirebaseStorage().ref().child(ds['photoUrl']);
        storageReference.getDownloadURL().then((img) {
          showDialog(
              context: context,
              builder: (context) {
                return createDialog(img,_pos);
              });
        });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return createDialog(null,_pos);
            });
      }
    });
  }


  void _addMarker(String id, LatLng latLng, int type) {
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
    }

    final MarkerId markerId = MarkerId(id);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
      onTap: () {
        // markerId is used as a reference to the marker in the Firebase db
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      // adding a new marker to map
      markers.add(marker);
    });
  }

  //TODO: change way of saving and filtering markers, need to refactor to avoid querying the db each time

  void showAllMarkers() {
    notFilteredMarkers.addAll(markers);
    setState(() {
      markers.clear();
      markers.addAll(notFilteredMarkers);
    });
  }

  void showFilteredMarkers(int type) async {
    if (type == 0) {
      showAllMarkers();
    } else {
      notFilteredMarkers.addAll(markers);
      markers.clear();

      Firestore.instance
          .collection('cestini')
          .where("type", isEqualTo: type)
          .snapshots()
          .listen((data) => data.documents.forEach((doc) {
        LatLng l = new LatLng(doc['lat'], doc['lng']);
        _addMarker(doc.documentID, l, doc['type']);
      }));
    }
    setState(() {});
  }

  void addBin(int type, String imgName) async {
    LocationData currentLocation;

    var location = new Location();

    currentLocation = await location.getLocation();

    await Firestore.instance.collection("cestini").add({
      'lat': _lastPosition.latitude,
      'lng': _lastPosition.longitude,
      'type': type,
      'photoUrl': imgName
    }).then((doc) {
      doc.get().then((c) {
        _addMarker(doc.documentID, LatLng(c['lat'], c['lng']), c['type']);
      });
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              mapToolbarEnabled: false,
              initialCameraPosition: _kGooglePlex,
              markers: markers,
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
              onCameraMove: _onCameraMove,
            ),
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                child: Hero(
                  tag: "profilePic",
                  child: new Container(
                    width: 60,
                    height: 60,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: CircleAvatar(
                      backgroundImage: ExactAssetImage('assets/profileTest.jpeg'),
                      maxRadius: 40,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 10,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SearchWidget(showFilteredMarkers)),
            ),
            Positioned(
              bottom: 30,
              left: 10,
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green[300],
                ),
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddBin(addBin)),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    size: 32,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
