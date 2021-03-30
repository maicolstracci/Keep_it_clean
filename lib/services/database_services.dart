import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:keep_it_clean/models/bin_model.dart';
import 'package:keep_it_clean/models/illegal_waste_disposal_model.dart';
import 'package:keep_it_clean/models/user_model.dart';
import 'package:keep_it_clean/utils/constants.dart';

@lazySingleton
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Geoflutterfire _geoflutterfire = Geoflutterfire();
  String typeOfBinToFilter;

  // Default geoFirePoint
  GeoFirePoint defaultPoint =
      Geoflutterfire().point(latitude: 44.170147, longitude: 8.3438333);

  List<Bin> _binListFromSnap(List<DocumentSnapshot> list) {
    return list.map((doc) {
      return Bin.fromFirestore(doc);
    }).toList();
  }

  List<IllegalWasteDisposal> _wasteDisposalListFromSnap(
      List<DocumentSnapshot> list) {
    return list.map((doc) {
      return IllegalWasteDisposal.fromFirestore(doc);
    }).toList();
  }

  Stream<List<Bin>> binStreamFromPosition({GeoFirePoint currentUserPoint}) {
    // get the collection reference or query
    var collectionReference = _db.collection('cestini');

    String field = 'position';

    return _geoflutterfire
        .collection(collectionRef: collectionReference)
        .within(
            center: currentUserPoint ?? defaultPoint,
            radius: 10,
            field: field,
            strictMode: true)
        .map(_binListFromSnap);
  }

  Stream<List<IllegalWasteDisposal>> illegalWasteDisposalStreamFromPosition(
      {GeoFirePoint currentUserPoint}) {
    // get the collection reference or query
    var collectionReference = _db.collection('segnalazioniAbbandonoRifiuti');

    String field = 'position';

    return _geoflutterfire
        .collection(collectionRef: collectionReference)
        .within(
            center: currentUserPoint ?? defaultPoint,
            radius: 10,
            field: field,
            strictMode: true)
        .map(_wasteDisposalListFromSnap);
  }

  Future createBin(
      {@required String type,
      @required String imgName,
      @required LatLng binPos,
      @required KeepItCleanUser user}) async {
    GeoFirePoint binLocation = _geoflutterfire.point(
        latitude: binPos.latitude, longitude: binPos.longitude);

    await _db.collection("cestini").add({
      'position': binLocation.data,
      'type': type,
      'photoUrl': imgName,
      'username': user.name,
      'reportDate': new DateTime.now().toString(),
      'uidUser': user.uid,
      'likes': 0,
      'dislikes': 0,
      'userListLikes': [],
      'userListDislikes': []
    });
  }

  Future modifyPhotoUrl(String binID, String photoUrl) async {
    var bin = await getBinInfo(binID);

    var querySnap = await _db
        .collection("cestini")
        .where("photoUrl", isEqualTo: bin.photoUrl)
        .get();

    for (DocumentSnapshot doc in querySnap.docs) {
      doc.reference.update({'photoUrl': photoUrl});
    }
  }

  Future<String> uploadImage(
      {@required File imgFile, @required String imgName}) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(imgName);

    //TODO: check for other results
    storageReference.putFile(imgFile);

    imgFile.delete();
    return imgName;
  }

  Stream<Map<String, int>> streamLikesFromBin(String binID) {
    return _db.collection("cestini").doc(binID).snapshots().map((doc) {
      Map<String, int> map = Map();
      Map review = doc.data()['review'];
      if (review != null) {
        map["likes"] = review['like'];
        map["dislikes"] = review['dislike'];
      } else {
        map["likes"] = 0;
        map["dislikes"] = 0;
      }
      return map;
    });
  }

  Future<Bin> getBinInfo(String binID) async {
    DocumentSnapshot ds =
        await FirebaseFirestore.instance.collection('cestini').doc(binID).get();
    return Bin.fromFirestore(ds);
  }

  Future<String> getDownloadUrlImageFromName(String imageName) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child(imageName);

    return await storageReference.getDownloadURL().catchError((e) {
      return null;
    });
  }

  Future<KeepItCleanUser> retrieveUserInfo({String reporterUid}) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('users')
        .doc(reporterUid)
        .get();

    return KeepItCleanUser.fromFirestore(ds);
  }

  Future<List<DocumentSnapshot>> retrieveRankings() async {
    Query query = _db
        .collection("users")
        .where("totalNumberOfReports", isGreaterThan: 0)
        .orderBy("totalNumberOfReports", descending: true)
        .limit(50);

    QuerySnapshot snapshot = await query.get();

    return snapshot.docs;
  }

  Future<DocumentSnapshot> setupUser(User user, {String fbPic}) async {
    // Check if user already in firestore db, if not create an entry
    DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    DocumentSnapshot documentSnapshot = await ref.get();

    if (!documentSnapshot.exists) {
      await ref.set({
        'name': user.displayName,
        'profilePic': fbPic != null ? fbPic : user.photoURL
      });
      return await ref.get();
    } else
      return documentSnapshot;
  }

  Future addPoints(KeepItCleanUser user, List<int> types) async {
    final DocumentReference documentReference =
        _db.collection("users").doc(user.uid);

    DocumentSnapshot doc = await documentReference.get();

    // Map is equal to the map retrieved from Firebase if that exist or a new map if it does not exist
    Map<String, int> map = doc.data()['reports'] != null
        ? Map<String, int>.from(doc.data()['reports'])
        : Map<String, int>();
    int totalReports = doc.data()['totalNumberOfReports'] ?? 0;

    for (int type in types) {
      map.update(typesOfBin[type], (value) => value + 1, ifAbsent: () => 1);
      totalReports++;
    }

    documentReference
        .update({'reports': map, 'totalNumberOfReports': totalReports});
  }

  Future<bool> addLikeBin(String documentId, KeepItCleanUser user) async {
    DocumentReference documentReference =
        _db.collection("cestini").doc(documentId);
    bool result = true;

    DocumentSnapshot doc = await documentReference.get();

    Map<String, dynamic> map = doc.data()['review'] != null
        ? Map<String, dynamic>.from(doc.data()['review'])
        : Map<String, dynamic>();

    if (map.isNotEmpty) {
      List<String> userThatLiked = (map['userThatLiked'] as List)
              ?.map((item) => item as String)
              ?.toList() ??
          [];

      if (!userThatLiked.contains(user.uid)) {
        map.update('like', (value) => value + 1);
        userThatLiked.add(user.uid);
        map.update("userThatLiked", (value) => userThatLiked);
      } else {
        map.update('like', (value) => value - 1);

        userThatLiked.remove(user.uid);
        map.update("userThatLiked", (value) => userThatLiked);
      }
    } else {
      map.putIfAbsent("like", () => 1);
      map.putIfAbsent("dislike", () => 0);
      map.putIfAbsent("userThatLiked", () => [user.uid]);
      map.putIfAbsent("userThatDisliked", () => []);
    }

    documentReference.update({'review': map});

    return result;
  }

  Future<bool> addDislikeBin(String documentId, KeepItCleanUser user) async {
    DocumentReference documentReference =
        _db.collection("cestini").doc(documentId);

    bool result = true;

    DocumentSnapshot doc = await documentReference.get();

    Map<String, dynamic> map = doc.data()['review'] != null
        ? Map<String, dynamic>.from(doc.data()['review'])
        : Map<String, dynamic>();

    if (map.isNotEmpty) {
      List<String> userThatLiked = (map['userThatDisliked'] as List)
              ?.map((item) => item as String)
              ?.toList() ??
          [];

      if (!userThatLiked.contains(user.uid)) {
        map.update('dislike', (value) => value + 1);
        userThatLiked.add(user.uid);
        map.update("userThatDisliked", (value) => userThatLiked);
      } else {
        map.update('dislike', (value) => value - 1);
        userThatLiked.remove(user.uid);
        map.update("userThatDisliked", (value) => userThatLiked);
      }
    } else {
      map.putIfAbsent("like", () => 0);
      map.putIfAbsent("dislike", () => 1);
      map.putIfAbsent("userThatLiked", () => []);
      map.putIfAbsent("userThatDisliked", () => [user.uid]);
    }

    documentReference.update({'review': map});

    return result;
  }

  void reportBinProblem(String documentId, KeepItCleanUser user) async {
    DocumentReference documentReference =
        _db.collection("cestini").doc(documentId);

    DocumentSnapshot doc = await documentReference.get();

    Map<String, dynamic> map = doc.data()['reports'] != null
        ? Map<String, dynamic>.from(doc.data()['reports'])
        : Map<String, dynamic>();

    if (map.isNotEmpty) {
      List<String> userThatReportedThisBin =
          (map['userThatReportedThisBin'] as List)
                  ?.map((item) => item as String)
                  ?.toList() ??
              [];

      if (!userThatReportedThisBin.contains(user.uid)) {
        map.update('numberOfReports', (value) => value + 1);
        userThatReportedThisBin.add(user.uid);
        map.update(
            "userThatReportedThisBin", (value) => userThatReportedThisBin);
      } else {
        return;
      }
    } else {
      map.putIfAbsent("numberOfReports", () => 1);
      map.putIfAbsent("userThatReportedThisBin", () => [user.uid]);
    }

    documentReference.update({'reports': map});
  }

  void reportSolvedWasteDisposal(
      String documentId, KeepItCleanUser user) async {
    DocumentReference documentReference =
        _db.collection("segnalazioniAbbandonoRifiuti").doc(documentId);

    DocumentSnapshot doc = await documentReference.get();

    Map<String, dynamic> map = doc.data()['reports'] != null
        ? Map<String, dynamic>.from(doc.data()['reports'])
        : Map<String, dynamic>();

    if (map.isNotEmpty) {
      List<String> userThatReportedThisBin =
          (map['userThatReportedThis'] as List)
                  ?.map((item) => item as String)
                  ?.toList() ??
              [];

      if (!userThatReportedThisBin.contains(user.uid)) {
        map.update('numberOfReports', (value) => value + 1);
        userThatReportedThisBin.add(user.uid);
        map.update("userThatReportedThis", (value) => userThatReportedThisBin);
      } else {
        return;
      }
    } else {
      map.putIfAbsent("numberOfReports", () => 1);
      map.putIfAbsent("userThatReportedThis", () => [user.uid]);
    }

    documentReference.update({'reports': map});
  }

  void createIllegalWasteDisposalReport(
      {@required String imgName,
      @required LatLng binPos,
      @required KeepItCleanUser user}) async {
    GeoFirePoint binLocation = _geoflutterfire.point(
        latitude: binPos.latitude, longitude: binPos.longitude);

    await _db.collection("segnalazioniAbbandonoRifiuti").add({
      'position': binLocation.data,
      'photoUrl': imgName,
      'username': user.name,
      'reportDate': new DateTime.now().toString(),
      'uidUser': user.uid,
    });
  }

  Future<IllegalWasteDisposal> getIllegalWasteDisposalInfo(String binID) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('segnalazioniAbbandonoRifiuti')
        .doc(binID)
        .get();
    return IllegalWasteDisposal.fromFirestore(ds);
  }
}
