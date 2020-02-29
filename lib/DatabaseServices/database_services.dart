import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/Models/bin_model.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Future<List<Bin>> streamBins() async {
    QuerySnapshot ref = await _db.collection('cestini').getDocuments();

   return ref.documents.map((doc) => Bin.fromFirestore(doc)).toList();

  }

  Future<Bin> createBin(int type, String imgName, LatLng binPos, FirebaseUser user) async {
    DocumentReference doc = await _db.collection("cestini").add({
      'lat': binPos.latitude,
      'lng': binPos.longitude,
      'type': type,
      'photoUrl': imgName,
      'username': user.displayName,
      'reportDate': new DateTime.now().toString(),
      'uidUser' : user.uid,
      'likes' : 0,
      'dislikes' : 0,
      'userListLikes' : [], 'userListDislikes' : []

    });



//    DocumentSnapshot ds = await Firestore.instance
//        .collection('cestini')
//        .document(doc.documentID)
//        .get();

    return Bin.fromFirestore(await doc.get());

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

    return await storageReference.getDownloadURL().catchError((e) {
      return null;
    });
  }

  Future<Map<String, dynamic>> retrieveUserInfo({FirebaseUser user, String uid}) async {

    String userUid;
    if(user == null){
      userUid = uid;
    } else userUid = user.uid;
    DocumentSnapshot ds =
        await Firestore.instance.collection('users').document(userUid).get();
    return ds.data;
  }

  void setupUser(FirebaseUser user, {String fbPic}) {
    // Check if user already in firestore db, if not create an entry
    DocumentReference ref =
        Firestore.instance.collection('users').document(user.uid);
    ref.get().then((ds) {
      if (!ds.exists) {
        ref.setData({
          'name' : user.displayName,
          'photoUrl' : fbPic != null ? fbPic : user.photoUrl
        });
      }
    });
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

  Future<void> addLikeBin(String documentId, FirebaseUser user) async {
    DocumentReference postRef = _db.collection("cestini").document(documentId);
    List<String> l = [user.uid];


    await _db.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      List<dynamic> userList = postSnapshot.data['userListLikes'];


        if(!userList.contains(user.uid)){
          await tx.update(postRef, <String, dynamic>{
            'likes': postSnapshot.data['likes'] + 1,
            'userListLikes': FieldValue.arrayUnion(l)

          });
        } else {
          await tx.update(postRef, <String, dynamic>{
            'likes': postSnapshot.data['likes'] - 1,
            'userListLikes': FieldValue.arrayRemove(l)

          });
        }

    }).catchError((e){print(e);});
  }

  Future<void> addDislikeBin(String documentId, FirebaseUser user) async{

    DocumentReference postRef = _db.collection("cestini").document(documentId);
    List<String> l = [user.uid];


    await _db.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      List<dynamic> userList = postSnapshot.data['userListDislikes'];


      if(!userList.contains(user.uid)){
        await tx.update(postRef, <String, dynamic>{
          'dislikes': postSnapshot.data['dislikes'] + 1,
          'userListDislikes': FieldValue.arrayUnion(l)

        });
      } else {
        await tx.update(postRef, <String, dynamic>{
          'dislikes': postSnapshot.data['dislikes'] - 1,

          'userListDislikes': FieldValue.arrayRemove(l)

        });
      }

    }).catchError((e){print(e);});
  }

  void reportBinProblem(String documentId, FirebaseUser user) {
    DocumentReference postRef = _db.collection("reports").document(documentId);
    List<String> l = [user.uid];


    _db.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);

      if (postSnapshot.exists) {
        List<dynamic> userList = postSnapshot.data['userList'];
        if(!userList.contains(user.uid)){
          print("enter");
          await tx.update(postRef, <String, dynamic>{
            'nOfReports': postSnapshot.data['nOfReports'] + 1,
            'userList': FieldValue.arrayUnion(l)

          });
        }

      } else {
        await tx.set(postRef, <String, dynamic>{'nOfReports': 1, 'userList': FieldValue.arrayUnion(l)});
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
