import 'package:cloud_firestore/cloud_firestore.dart';

class IllegalWasteDisposal {
  final String id;
  final GeoPoint position;
  final String photoUrl;
  final String reportDate;
  final String username;
  final String uidUser;


  IllegalWasteDisposal(
      {this.id,
        this.position,
        this.photoUrl,
        this.reportDate,
        this.username,
        this.uidUser
        });

  factory IllegalWasteDisposal.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return IllegalWasteDisposal(
      id: doc.documentID,
      position: data['position']['geopoint'],
      photoUrl: data['photoUrl'],
      reportDate: data['reportDate'],
      username: data['username'],
      uidUser: data['uidUser'],
    );
  }
}
