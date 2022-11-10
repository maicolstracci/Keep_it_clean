import 'package:cloud_firestore/cloud_firestore.dart';

class IllegalWasteDisposal {
  final String id;
  final GeoPoint position;
  final String photoUrl;
  final String reportDate;
  final String username;
  final String uidUser;

  IllegalWasteDisposal(
      {required this.id,
      required this.position,
      required this.photoUrl,
      required this.reportDate,
      required this.username,
      required this.uidUser});

  factory IllegalWasteDisposal.fromFirestore(DocumentSnapshot doc) {
    Map? data = doc.data();

    return IllegalWasteDisposal(
      id: doc.id,
      position: data?['position']['geopoint'],
      photoUrl: data?['photoUrl'],
      reportDate: data?['reportDate'],
      username: data?['username'],
      uidUser: data?['uidUser'],
    );
  }
}
