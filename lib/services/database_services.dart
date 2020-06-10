import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:keep_it_clean/models/bin_model.dart';
import 'package:keep_it_clean/models/user_model.dart';

@lazySingleton
class DatabaseService {
//  AuthService _authService = locator<AuthService>();

  final Firestore _db = Firestore.instance;
  Geoflutterfire _geoflutterfire = Geoflutterfire();
  String typeOfBinToFilter;

  List<Bin> _binListFromSnap(List<DocumentSnapshot> list) {

   return list.map((doc) {

      return Bin.fromFirestore(doc);
    }).toList();


  }

  Stream<List<Bin>> binStream() {

    // Create a geoFirePoint
    GeoFirePoint center = _geoflutterfire.point(latitude:44.170147, longitude: 8.3438333);

// get the collection reference or query
    var collectionReference = _db.collection('cestini');
    double radius = 10;
    String field = 'position';

    return _geoflutterfire.collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field, strictMode: true).map(_binListFromSnap);


  }


  Future<void> createBin(
      String type, String imgName, LatLng binPos) async {

    GeoFirePoint binLocation = _geoflutterfire.point(latitude: binPos.latitude, longitude: binPos.longitude);

    DocumentReference doc = await _db.collection("cestini").add({
      'position': binLocation.data,
      'type': type,
      'photoUrl': imgName,
      'username': "Test",
      'reportDate': new DateTime.now().toString(),
      'uidUser': "Test",
      'likes': 0,
      'dislikes': 0,
      'userListLikes': [],
      'userListDislikes': []
    });


//    return Bin.fromFirestore(await doc.get());
  }

  Future<String> uploadImage(File img) async {
    //TODO: Add user to img name
    String _imgName = '${DateTime.now()}';
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(_imgName);

    //TODO: check for other results
    StorageUploadTask uploadTask = storageReference.putFile(img);
    await uploadTask.onComplete;

    img.delete();
    return _imgName;
  }

  Stream<Map<String,int>> streamLikesFromBin(String binID){
    return _db.collection("cestini").document(binID).snapshots().map((doc) {
      Map<String,int> map = Map();
      map["likes"] = doc['likes'];
      map["dislikes"] = doc['dislikes'];
      return map;
    });
  }

  Future<Bin> getBinInfo(String binID) async {
    DocumentSnapshot ds = await Firestore.instance
        .collection('cestini')
        .document(binID)
        .get();
    return Bin.fromFirestore(ds);
  }

  Future<String> getDownloadUrlImageFromName(String imageName) async {
    final StorageReference storageReference =
        FirebaseStorage().ref().child(imageName);

    return await storageReference.getDownloadURL().catchError((e) {
      return null;
    });
  }

  Future<Map<String, dynamic>> retrieveUserInfo(
      {FirebaseUser user, String uid}) async {
    String userUid;
    if (user == null) {
      userUid = uid;
    } else
      userUid = user.uid;
    DocumentSnapshot ds =
        await Firestore.instance.collection('users').document(userUid).get();
    return ds.data;
  }

  Future<DocumentSnapshot> setupUser(FirebaseUser user, {String fbPic}) async {
    // Check if user already in firestore db, if not create an entry
    DocumentReference ref =
        Firestore.instance.collection('users').document(user.uid);

    DocumentSnapshot documentSnapshot = await ref.get();

    if (!documentSnapshot.exists) {
      await ref.setData({
        'name': user.displayName,
        'profilePic': fbPic != null ? fbPic : user.photoUrl
      });
      return await ref.get();
    } else
      return documentSnapshot;
  }

  void addPoints(FirebaseUser user, List<int> types) {
    final DocumentReference postRef =
        _db.collection("users").document(user.uid);
    _db.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        types.forEach((type) async {
          if (postSnapshot.data['$type'] != null) {
            await tx.update(postRef,
                <String, dynamic>{'$type': postSnapshot.data['$type'] + 1});
          } else {
            await tx.update(postRef, <String, dynamic>{'$type': 1});
          }
        });
      }
    });
  }

  Future<bool> addLikeBin(String documentId, User user) async {
    DocumentReference postRef = _db.collection("cestini").document(documentId);
    List<String> l = [user.uid];
    bool result = true;

    await _db.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      List<dynamic> userList = postSnapshot.data['userListLikes'];

      if (!userList.contains(user.uid)) {
        await tx.update(postRef, <String, dynamic>{
          'likes': postSnapshot.data['likes'] + 1,
          'userListLikes': FieldValue.arrayUnion(l)
        });
        result = true;
      } else {
        await tx.update(postRef, <String, dynamic>{
          'likes': postSnapshot.data['likes'] - 1,
          'userListLikes': FieldValue.arrayRemove(l)
        });
        result = false;
      }
    }).catchError((e) {
      print(e);
    });

    return result;
  }

  Future<bool> addDislikeBin(String documentId, User user) async {
    DocumentReference postRef = _db.collection("cestini").document(documentId);
    List<String> l = [user.uid];
    bool result = true;

    await _db.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      List<dynamic> userList = postSnapshot.data['userListDislikes'];

      if (!userList.contains(user.uid)) {
        await tx.update(postRef, <String, dynamic>{
          'dislikes': postSnapshot.data['dislikes'] + 1,
          'userListDislikes': FieldValue.arrayUnion(l)
        });
        result = true;
      } else {
        await tx.update(postRef, <String, dynamic>{
          'dislikes': postSnapshot.data['dislikes'] - 1,
          'userListDislikes': FieldValue.arrayRemove(l)
        });
        result = false;
      }
    }).catchError((e) {
      print(e);
    });
    return result;
  }

  void reportBinProblem(String documentId, FirebaseUser user) {
    DocumentReference postRef = _db.collection("reports").document(documentId);
    List<String> l = [user.uid];

    _db.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);

      if (postSnapshot.exists) {
        List<dynamic> userList = postSnapshot.data['userList'];
        if (!userList.contains(user.uid)) {
          print("enter");
          await tx.update(postRef, <String, dynamic>{
            'nOfReports': postSnapshot.data['nOfReports'] + 1,
            'userList': FieldValue.arrayUnion(l)
          });
        }
      } else {
        await tx.set(postRef, <String, dynamic>{
          'nOfReports': 1,
          'userList': FieldValue.arrayUnion(l)
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

class LikesInfoChanger with ChangeNotifier {
  int likes = 0;
  int dislikes = 0;

  LikesInfoChanger(this.likes, this.dislikes);

  int getLikes() => likes;

  int getDislikes() => dislikes;

  setLike(int like) {
    likes = likes + like;
    notifyListeners();
  }

  setDislike(int dislike) {
    dislikes = dislikes + dislike;
    notifyListeners();
  }
}
