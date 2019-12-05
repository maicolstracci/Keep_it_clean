import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:keep_it_clean/Localization/app_translation_delegate.dart';
import 'package:keep_it_clean/Localization/application.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'Maps/maps_page.dart';

void main() => runApp(KeepItClean());

class KeepItClean extends StatefulWidget {
  @override
  _KeepItCleanState createState() {
    return new _KeepItCleanState();
  }
}

class _KeepItCleanState extends State<KeepItClean> {
  AppTranslationsDelegate _newLocaleDelegate;


  @override
  void initState() {
    super.initState();

    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keep it Clean',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          body1: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w100,
              color: Colors.black87),
        ),
      ),
      home: LoginPage(),
      localizationsDelegates: [
        _newLocaleDelegate,
        const AppTranslationsDelegate(),
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'EN'),
        const Locale('it', 'IT'),
        const Locale('de', 'DE')
      ],
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({
    Key key,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String fbUserProfilePic;


  Future<FirebaseUser> _fbLogin() async {
    final facebookLogin = FacebookLogin();
    //facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    final result = await facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print("Logged");
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.green[400],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: CircleAvatar(
                      backgroundImage:
                          ExactAssetImage('assets/keep_it_clean_logo.jpg'),
                      maxRadius: 40,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Keep it clean",
                    style: TextStyle(
                        fontSize: 48,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        //foreground: Paint()..shader = linearGradient,
                        letterSpacing: .6),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppTranslations.of(context).text("find_bin_string"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          letterSpacing: .6),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(50.0),
//                  width: double.infinity,
//                  height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 40),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _fbLogin().then((FirebaseUser user) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Maps(user: user, fbPic: fbUserProfilePic)),
                          );
                        }).catchError((e) => print(e));
                      },
                      child: Container(
                        height: 70,
                        width: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blueAccent,
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
                                IconData(0xe901, fontFamily: "CustomIcons"),
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              AppTranslations.of(context)
                                  .text("facebook_login_string"),
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
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
                      child: Container(
                        height: 70,
                        width: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.redAccent,
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
                                IconData(0xe902, fontFamily: "CustomIcons"),
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              AppTranslations.of(context)
                                  .text("google_login_string"),
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Maps()),
                        );
                      },
                      child: Container(
                        height: 70,
                        width: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blueGrey[500],
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
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                            Center(
                              child: Text(
                                AppTranslations.of(context)
                                    .text("login_string"),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

