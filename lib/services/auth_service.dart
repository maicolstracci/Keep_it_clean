import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/models/user_model.dart';

import 'database_services.dart';

@lazySingleton
class AuthService {
  KeepItCleanUser _currentUser;

  KeepItCleanUser get currentUser => _currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool appleSignInAvailable = false;

  //Show Apple Sign in only for iOS device
  Future retriveAppleSignInAvailable() async {
    appleSignInAvailable =
        (await AppleSignIn.isAvailable()) && (Platform.isIOS);
  }

  DatabaseService _databaseService = locator<DatabaseService>();

  Future appleSignIn() async {
    try {
      final AuthorizationResult appleResult =
          await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        print(appleResult.error);
      }

      final AppleIdCredential appleIdCredential = appleResult.credential;

      OAuthProvider oAuthProvider = new OAuthProvider("apple.com");
      final AuthCredential credential = oAuthProvider.credential(
        idToken: String.fromCharCodes(appleIdCredential.identityToken),
        accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
      );

      final UserCredential _res =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User user = _res.user;

      await user.updateProfile(
          displayName:
              "${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}",
          photoURL:
              "https://firebasestorage.googleapis.com/v0/b/trova-cestino.appspot.com/o/A-img.png?alt=media&token=61e89908-435b-4b4e-8963-088bd8e784e7");

      await user.reload();

      user = _auth.currentUser;

      DocumentSnapshot documentSnapshot =
          await _databaseService.setupUser(user);
      _currentUser = KeepItCleanUser.fromFirestore(documentSnapshot);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future googleLogin() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final User user = (await _auth.signInWithCredential(credential)).user;

    DocumentSnapshot documentSnapshot = await _databaseService.setupUser(user);
    _currentUser = KeepItCleanUser.fromFirestore(documentSnapshot);
  }

  Future facebookLogin() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;

    final result = await facebookLogin.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;

        final AuthCredential cred = FacebookAuthProvider.credential(token);

        final User user = (await _auth.signInWithCredential(cred)).user;

        final graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=picture.width(500).height(500)&access_token=$token'));
        Map<String, dynamic> facebookData = jsonDecode(graphResponse.body);

        DocumentSnapshot documentSnapshot = await _databaseService
            .setupUser(user, fbPic: facebookData['picture']['data']['url']);
        _currentUser = KeepItCleanUser.fromFirestore(documentSnapshot);

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
    var user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot documentSnapshot =
          await _databaseService.setupUser(user);
      _currentUser = KeepItCleanUser.fromFirestore(documentSnapshot);
    }

    return user != null;
  }
}
