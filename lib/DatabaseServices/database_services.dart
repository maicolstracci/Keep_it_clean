import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/Models/bin_model.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<List<Bin>> streamBins() {
    var ref = _db.collection('cestini');

    return ref.snapshots().map(
        (list) => list.documents.map((doc) => Bin.fromFirestore(doc)).toList());
  }

  void createBin(int type, String imgName, LatLng binPos, FirebaseUser user) {
    _db.collection("cestini").add({
      'lat': binPos.latitude,
      'lng': binPos.longitude,
      'type': type,
      'photoUrl': imgName,
      'username': user.displayName,
      'reportDate': new DateTime.now().toString()
    });
  }

  Future<Bin> getBinInfo(MarkerId markerId) async {

    DocumentSnapshot ds = await Firestore.instance
        .collection('cestini')
        .document(markerId.value)
        .get();
    return Bin.fromFirestore(ds);
  }

  Future<String> getImageFromUrl(String photoUrl) async {
    final StorageReference storageReference =
    FirebaseStorage().ref().child(photoUrl);
    String img = await storageReference.getDownloadURL();
    return img;
  }

  void addPoints(FirebaseUser user, List<int> types) {
    final DocumentReference postRef =
        _db.collection("users").document(user.uid);
    _db.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        types.forEach((type) async {
          await tx.update(postRef,
              <String, dynamic>{'$type': postSnapshot.data['$type'] + 1});
        });
      }
    });
  }
}

class TypeChanger with ChangeNotifier {
  int _type = 0;
  LatLngBounds _visibleArea;

  TypeChanger(this._type, this._visibleArea);

  int getType() => _type;

  setType(int type) {
    _type = type;
    notifyListeners();
  }

  LatLngBounds getVisibleArea() => _visibleArea;

  setVisibleArea(LatLngBounds visibleArea) {
    _visibleArea = visibleArea;
  }
}

class SearchButtonChanger with ChangeNotifier {
  bool _visible = false;

  SearchButtonChanger(this._visible);

  bool getVisibility() => _visible;

  setVisibility(bool vis) {
    _visible = vis;
    notifyListeners();
  }
}
