import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/AddBin/add_bin_page.dart';
import 'package:keep_it_clean/AddBin/select_position.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:keep_it_clean/Maps/marker_dialog.dart';
import 'package:keep_it_clean/ProfilePage/profile_page.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'search_widget.dart';

class Maps extends StatefulWidget {
  final FirebaseUser user;
  final String fbPic;

  const Maps({Key key, this.user, this.fbPic}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng _lastPosition;
  Completer<GoogleMapController> _controller = Completer();

  // Two sets of markers are needed to perform the markers filtering on screen
  Set<Marker> markers = Set.from([]);
  Set<Marker> notFilteredMarkers = Set.from([]);
  GoogleMapController controller;

  Map<PermissionGroup, PermissionStatus> permissions;

  @override
  void initState() {
    super.initState();
    _initMarkers();
    requestPermission();
  }

  // Request permission method from permissions_handlers plugin
  void requestPermission() async {
    permissions =
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
      _pos = new LatLng(ds['lat'], ds['lng']);
      // if photoUrl is not null then we recover the photo from Firebase Storage
      if (ds['photoUrl'] != null) {
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
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return createDialog(
                context,
                null,
                _pos,
                ds['type'],
                ds['username'],
                ds['reportDate'],
              );
            });
      }
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

    setState(() {
      // adding a new marker to map
      markers.add(marker);
    });
  }

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

  void addBin(List<int> types, String imgName, LatLng binPos) async {
    types.forEach((type) async {
      await Firestore.instance.collection("cestini").add({
        'lat': binPos.latitude,
        'lng': binPos.longitude,
        'type': type,
        'photoUrl': imgName,
        'username': widget.user.displayName,
        'reportDate': new DateTime.now().toString()
      }).then((doc) {
        doc.get().then((c) {
          _addMarker(doc.documentID, LatLng(c['lat'], c['lng']), c['type']);
        });
      });
    });

    final DocumentReference postRef =
        Firestore.instance.collection("users").document(widget.user.uid);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        types.forEach((type) async {
          await tx.update(postRef,
              <String, dynamic>{'$type': postSnapshot.data['$type'] + 1});
        });
      }
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  void _showSnackBar(BuildContext context, int variant) {
    String s;
    switch(variant){
      case 1: s = "you_are_guest_profile_string"; break;
      case 2: s = "you_are_guest_add_string"; break;
      case 3: s = "location_requested_string"; break;
    }

    final snackBar = SnackBar(
        content: Text(AppTranslations.of(context).text(s)),
      action: (variant == 1 || variant == 2) ? SnackBarAction(
        label: "LOGIN",
        onPressed: (){
          Navigator.of(context).pop();
        },
      ) : SnackBarAction(
        label: AppTranslations.of(context).text("settings_string"),
        onPressed: (){
          PermissionHandler().openAppSettings();
        },
      ),
      behavior: SnackBarBehavior.fixed,

    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _scaffoldKey,
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
                    if (widget.user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(widget.user, widget.fbPic)),
                      );
                    } else {
                      _showSnackBar(context, 1);
                    }
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
                        backgroundImage: (widget.user != null)
                            ? NetworkImage(
                                widget.fbPic == null
                                    ? widget.user.photoUrl
                                    : widget.fbPic,
                                scale: 1)
                            : ExactAssetImage('assets/no-avatar.jpg'),
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
                      if (widget.user != null) {
                        //TODO: check location permission
                        PermissionHandler().checkPermissionStatus(PermissionGroup.location).then((permission){
                          if(permission == PermissionStatus.granted){
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddBin(addBin)
                            ));
                          } else{
                            _showSnackBar(context, 3);
                          }
                        });

                      } else {
                        _showSnackBar(context, 2);
                      }
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
      ),
    );
  }
}
