import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:keep_it_clean/models/user_model.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:http/http.dart' as http;

import 'database_services.dart';

@lazySingleton
class AuthService {
  User _currentUser;

  User get currentUser => _currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DatabaseService _databaseService = locator<DatabaseService>();

  Future googleLogin() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    DocumentSnapshot documentSnapshot = await _databaseService.setupUser(user);
    _currentUser = User.fromFirestore(documentSnapshot);
  }

  Future facebookLogin() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;

    final result = await facebookLogin.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;

        final AuthCredential cred =
            FacebookAuthProvider.getCredential(accessToken: token);

        final FirebaseUser user = (await _auth.signInWithCredential(cred)).user;

        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=picture.width(500).height(500)&access_token=$token');
        Map<String, dynamic> facebookData = jsonDecode(graphResponse.body);

        DocumentSnapshot documentSnapshot = await _databaseService
            .setupUser(user, fbPic: facebookData['picture']['data']['url']);
        _currentUser = User.fromFirestore(documentSnapshot);

        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        return null;
        break;
      case FacebookLoginStatus.error:
        print("Error");
        return null;
        break;
    }
    return null;
  }

  signOut() {
    _auth.signOut();
    _currentUser = null;
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _auth.currentUser();

    if (user != null) {
      DocumentSnapshot documentSnapshot =
          await _databaseService.setupUser(user);
      _currentUser = User.fromFirestore(documentSnapshot);
    }

    return user != null;
  }
}
