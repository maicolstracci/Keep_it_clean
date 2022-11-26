import 'package:cloud_firestore/cloud_firestore.dart';

class Bin {
  final String id;
  final GeoPoint position;
  final String photoUrl;
  final String reportDate;
  final String type;
  final String username;
  final String uidUser;
  final int likes;
  final int dislikes;

  Bin(
      {required this.id,
      required this.position,
      required this.photoUrl,
      required this.reportDate,
      required this.type,
      required this.username,
      required this.uidUser,
      required this.likes,
      required this.dislikes});

  factory Bin.fromFirestore(DocumentSnapshot doc) {
    Map? data = doc.data() as Map?;
    Map? review = data!['review'];

    return Bin(
      id: doc.id,
      position: data?['position']['geopoint'],
      photoUrl: data?['photoUrl'],
      reportDate: data?['reportDate'],
      type: data?['type'],
      username: data?['username'],
      uidUser: data?['uidUser'],
      likes: review != null ? review['like'] : 0,
      dislikes: review != null ? review['dislike'] : 0,
    );
  }
}
