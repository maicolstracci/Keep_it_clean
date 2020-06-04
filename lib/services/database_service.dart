import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

//@lazySingleton
//class DatabaseService{
//  final Firestore _db = Firestore.instance;
//
//  void setupUser(FirebaseUser user, {String fbPic}) {
//    // Check if user already in firestore db, if not create an entry
//    DocumentReference ref =
//    Firestore.instance.collection('users').document(user.uid);
//    ref.get().then((ds) {
//      if (!ds.exists) {
//        ref.setData({
//          'name' : user.displayName,
//          'photoUrl' : fbPic != null ? fbPic : user.photoUrl
//        });
//      }
//    });
//  }
//
//}