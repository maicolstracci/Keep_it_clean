import 'package:cloud_firestore/cloud_firestore.dart';

class Bin {
  final String id;
  final double latitude;
  final double longitude;
  final String photoUrl;
  final String reportDate;
  final int type;
  final String username;
  final String uidUser;
  final int likes;
  final int dislikes;

  Bin(
      {this.id,
      this.latitude,
      this.longitude,
      this.photoUrl,
      this.reportDate,
      this.type,
      this.username,
      this.uidUser,
      this.likes,
      this.dislikes});

  factory Bin.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Bin(
      id: doc.documentID,
      latitude: data['lat'],
      longitude: data['lng'],
      photoUrl: data['photoUrl'],
      reportDate: data['reportDate'],
      type: data['type'],
      username: data['username'],
      uidUser: data['uidUser'],
      likes: data['likes'],
      dislikes: data['dislikes'],
    );
  }
}
