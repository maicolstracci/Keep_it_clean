import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keep_it_clean/FirstTimeUserPage/first_time_user.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:keep_it_clean/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Maps/maps_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String fbUserProfilePic;
  //TODO: change to false and checkIfFirstTimeUser()
  bool firstTimeUser = true;

  @override
  void initState() {
    super.initState();
//    checkIfFirstTimeUser();
  }

  void checkIfFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double firstTime = prefs.getDouble("firstTime");
    if (firstTime == null) {
      prefs.setDouble("firstTime", 1);
      firstTimeUser = true;
    } else {
      firstTimeUser = false;
    }
  }

  Future<FirebaseUser> _fbLogin() async {
    final facebookLogin = FacebookLogin();
    //facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    final result = await facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;

        final AuthCredential cred =
            FacebookAuthProvider.getCredential(accessToken: token);

        final FirebaseUser user = (await _auth.signInWithCredential(cred)).user;

        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=picture.width(500).height(500)&access_token=${token}');
        Map<String, dynamic> pic = jsonDecode(graphResponse.body);
        fbUserProfilePic = pic['picture']['data']['url'];
        setupUser(user);
        return user;
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
  }

  Future<FirebaseUser> _googleLogin() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    setupUser(user);

    return user;
  }

  void setupUser(FirebaseUser user) {
    // Check if user already in firestore db, if not create an entry and initialize keys
    DocumentReference ref =
        Firestore.instance.collection('users').document(user.uid);
    ref.get().then((ds) {
      if (!ds.exists) {
        ref.setData({
          '1': 0,
          '2': 0,
          '3': 0,
          '4': 0,
          '5': 0,
          '6': 0,
          '7': 0,
          '8': 0,
        });
      }
    });
  }

  Widget _createLoginContainer(String type) {
    IconData icon;
    String string;
    MaterialColor color;

    switch (type) {
      case 'fb':
        icon = IconData(0xe901, fontFamily: "CustomIcons");
        string = "facebook_login_string";
        color = Colors.blue;
        break;
      case 'google':
        icon = IconData(0xe902, fontFamily: "CustomIcons");
        string = "google_login_string";
        color = Colors.red;
        break;
      case 'guest':
        icon = Icons.arrow_forward;
        string = "login_string";
        color = Colors.green;
        break;
    }

    return Container(
      height: 70,
      width: 250,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          Expanded(
            child: Text(
              AppTranslations.of(context).text(string),
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: color),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              FlareActor(
                'assets/login_splash.flr',
                fit: BoxFit.fitWidth,
                animation: 'idle',
              ),
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Text(
                              "Keep it",
                              style: TextStyle(
                                fontSize: 38,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 45,
                            right: 10,
                            child: Text(
                              "clean",
                              style: TextStyle(
                                fontSize: 38,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
//                          SizedBox(height: 80,),
                          Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 42,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            AppTranslations.of(context)
                                .text("login_desc_string"),
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _fbLogin().then((FirebaseUser user) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Maps(
                                        user: user, fbPic: fbUserProfilePic)),
                              );
                            }).catchError((e) => print(e));
                          },
                          child: _createLoginContainer("fb"),
                        ),
                        GestureDetector(
                          onTap: () {
                            _googleLogin().then((FirebaseUser user) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Maps(user: user)),
                              );
                            }).catchError((e) => print(e));
                          },
                          child: _createLoginContainer("google"),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (firstTimeUser) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Maps()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Maps()),
                              );
                            }
                          },
                          child: _createLoginContainer("guest"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
