import 'package:cloud_firestore/cloud_firestore.dart';

class KeepItCleanUser {
  final String uid;
  final String name;
  final String profilePic;
  Map<String?, int?>? reports;

  KeepItCleanUser({
    required this.uid,
    required this.name,
    required this.profilePic,
    this.reports,
  });

  factory KeepItCleanUser.fromFirestore(DocumentSnapshot doc) {
    Map? data = doc.data();

    return KeepItCleanUser(
      uid: doc.id,
      name: data?['name'],
      profilePic: data?['profilePic'],
      reports: data?['reports'] != null
          ? Map<String, int>.from(data?['reports'])
          : null,
    );
  }
}
