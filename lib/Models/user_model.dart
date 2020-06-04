import 'package:cloud_firestore/cloud_firestore.dart';

class User{

  final String uid;
  final String name;
  final String profilePic;
  Map<String, int> binReportMap;

  User(
      {this.uid,
        this.name,
        this.profilePic,
        this.binReportMap,
        });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return User(
      uid: doc.documentID,
      name: data['name'],
      profilePic: data['profilePic'],
      binReportMap: data['binReportMap'] ?? null,
    );
  }

}