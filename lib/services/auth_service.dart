import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
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

  bool appleSignInAvailable = false;

  //Show Apple Sign in only for iOS device
  Future retriveAppleSignInAvailable() async {
    appleSignInAvailable = (await AppleSignIn.isAvailable()) && (Platform.isIOS);
  }

  DatabaseService _databaseService = locator<DatabaseService>();



  Future appleSignIn() async {
    try {
      final AuthorizationResult appleResult = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        // handle errors from Apple here
      }

      final AppleIdCredential appleIdCredential = appleResult.credential;

        OAuthProvider oAuthProvider =
            new OAuthProvider(providerId: "apple.com");
        final AuthCredential credential = oAuthProvider.getCredential(
          idToken:
              String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );

        final AuthResult _res = await FirebaseAuth.instance
            .signInWithCredential(credential);

        FirebaseUser user = _res.user;

        UserUpdateInfo updateUser = UserUpdateInfo();
  updateUser.displayName =
      "${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}";
  //TODO: CHANGE LATER!
  updateUser.photoUrl =
      "https://support.plymouth.edu/kb_images/Yammer/default.jpeg"; 
  await user.updateProfile(updateUser);
  print("name: ${updateUser.displayName}");print("photoURL: ${updateUser.photoUrl}");

  await user.reload();

  user = await _auth.currentUser();

  print("USER: ${user.photoUrl} ${user.displayName}");
DocumentSnapshot documentSnapshot = await _databaseService.setupUser(user);
      _currentUser = User.fromFirestore(documentSnapshot);
     

      // final AuthCredential credential = OAuthProvider(providerId: 'apple.com').getCredential(
      //   accessToken: String.fromCharCodes(appleResult.credential.authorizationCode),
      //   idToken: String.fromCharCodes(appleResult.credential.identityToken),
      // );

      // AuthResult firebaseResult = await _auth.signInWithCredential(credential);
      // FirebaseUser user = firebaseResult.user;

      // DocumentSnapshot documentSnapshot = await _databaseService.setupUser(user);
      // _currentUser = User.fromFirestore(documentSnapshot);

    } catch (error) {
      print(error);
      return null;
    }
  }


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
