import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/models/user_model.dart';

import 'database_services.dart';

@lazySingleton
class AuthService {
  KeepItCleanUser? _currentUser;

  KeepItCleanUser? get currentUser => _currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseService _databaseService = locator<DatabaseService>();

  bool appleSignInAvailable = false;

  // //Show Apple Sign in only for iOS device
  // Future retriveAppleSignInAvailable() async {
  //   appleSignInAvailable =
  //       (await AppleSignIn.isAvailable()) && (Platform.isIOS);
  // }
  //
  // Future appleLogin() async {
  //   try {
  //     final AuthorizationResult appleResult =
  //         await AppleSignIn.performRequests([
  //       AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  //     ]);
  //
  //     if (appleResult.error != null) {
  //       print(appleResult.error);
  //     }
  //
  //     final AppleIdCredential appleIdCredential = appleResult.credential;
  //
  //     OAuthProvider oAuthProvider = new OAuthProvider("apple.com");
  //     final AuthCredential credential = oAuthProvider.credential(
  //       idToken: String.fromCharCodes(appleIdCredential.identityToken),
  //       accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
  //     );
  //
  //     final UserCredential _res =
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //     User user = _res.user;
  //
  //     await user.updateProfile(
  //         displayName:
  //             "${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}",
  //         photoURL:
  //             "https://firebasestorage.googleapis.com/v0/b/trova-cestino.appspot.com/o/A-img.png?alt=media&token=61e89908-435b-4b4e-8963-088bd8e784e7");
  //
  //     await user.reload();
  //
  //     user = _auth.currentUser;
  //
  //     DocumentSnapshot documentSnapshot =
  //         await _databaseService.setupUser(user);
  //     _currentUser = KeepItCleanUser.fromFirestore(documentSnapshot);
  //   } catch (error) {
  //     print(error);
  //     return null;
  //   }
  // }

  Future googleLogin() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    final User? user = (await _auth.signInWithCredential(credential)).user;

    DocumentSnapshot documentSnapshot = await _databaseService.setupUser(user!);
    _currentUser = KeepItCleanUser.fromFirestore(documentSnapshot);
  }

  logOut() {
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
