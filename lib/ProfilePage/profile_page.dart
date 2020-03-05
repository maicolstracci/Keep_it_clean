import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:keep_it_clean/ProfilePage/who_am_I_page.dart';
import 'package:keep_it_clean/DatabaseServices/database_services.dart';

class ProfilePage extends StatefulWidget {
  final FirebaseUser user;
  final String fbPic;
  final String uid;

  ProfilePage({Key key, this.user, this.fbPic, this.uid});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final PageController ctrl = PageController();
  double angle = 0;
  Animation<double> animation;
  AnimationController controller;
  List<String> userName;
  String photoUrl;
  Map<String, dynamic> userData;
  int reportSum = 0;

  @override
  void initState() {
    if (widget.user != null) {
      userName = widget.user.displayName.split(" ");
    }

    // init badge animation
    controller = AnimationController(
        duration: const Duration(milliseconds: 4000), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutQuint);
    animation = Tween<double>(begin: 0, end: pi * 4).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.stop();
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _createBox(double width, int index) {
    String img, name, n;
    index++;

    img = 'assets/icons/icon_type_$index.png';
    name = AppTranslations.of(context).text("icon_string_$index");

    if (userData['$index'] != null) {
      n = userData['$index'].toString();
    } else
      n = "0";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 40),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                img,
                height: 120,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(name,
                      maxLines: 2,
                      wrapWords: false,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      )),
                  Text(n,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void getSum() {
    reportSum = 0;
    userData.forEach((k, v) {
      if (v.runtimeType == int) {
        reportSum = reportSum + v;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.green[300],
        body: SafeArea(
          child: SingleChildScrollView(
            child: FutureBuilder(
                future: widget.user != null
                    ? retrieveUserInfo(widget.user)
                    : retrieveUserInfoString(widget.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    userName = userData['name'].split(" ");
                    photoUrl = userData['photoUrl'];
                    getSum();

                    return Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () => {Navigator.pop(context)},
                              icon: Icon(
                                Icons.arrow_back,
                                size: 32,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WhoAmIPage()),
                                )
                              },
                              icon: Icon(
                                Icons.info_outline,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Center(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.85,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 40),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              left: 10,
                              child: Hero(
                                tag: "profilePic",
                                child: CircleAvatar(
                                  backgroundImage: (photoUrl != null)
                                      ? NetworkImage(photoUrl,
//                                          widget.fbPic == null
//                                              ? widget.user.photoUrl
//                                              : widget.fbPic,
                                          scale: 1)
                                      : ExactAssetImage('assets/no-avatar.jpg'),
                                  maxRadius: 40,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              left: 100,
                              child:
                                  Text(userName != null ? userName[0] : "N/A",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat",
                                      )),
                            ),
                            Positioned(
                              top: 50,
                              left: 120,
                              child: Text(
                                  userName != null
                                      ? (userName.length >= 3
                                          ? userName[1] + " " + userName[2]
                                          : userName[1])
                                      : "N/A",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                  )),
                            ),
                            Positioned(
                              top: 10,
                              right: 50,
                              child: GestureDetector(
                                onTap: () {
                                  final snackBar = SnackBar(
                                    content: Text(AppTranslations.of(context)
                                        .text("badge_string")),
                                    duration: Duration(seconds: 8),
                                  );

                                  Scaffold.of(context).showSnackBar(snackBar);
                                },
                                onDoubleTap: () {
                                  controller.forward();
                                },
                                child: Visibility(
                                    visible: reportSum > 10 ? true : false,
                                    child: Badge(animation: animation)),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 35,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: Text(reportSum.toString(),
                                          style: TextStyle(
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Montserrat",
                                          )),
                                    ),
                                    Expanded(
                                      child: Text(
                                          " " +
                                              AppTranslations.of(context)
                                                  .text('report_string_short'),
                                          overflow: TextOverflow.clip,
                                          softWrap: false,
                                          style: TextStyle(
                                            fontSize: reportSum < 100 ? 26 : 22,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Montserrat",
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return _createBox(
                                    MediaQuery.of(context).size.width * 0.85,
                                    index);
                              },
                              itemCount: 11,
                              viewportFraction: 0.8,
                              scale: 0.8,
                            ))
                      ],
                    );
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }),
          ),
        ));
  }

  Future<void> retrieveUserInfo(FirebaseUser user) async {
    userData = await DatabaseService().retrieveUserInfo(user: user);
  }

  Future<void> retrieveUserInfoString(String userUid) async {
    userData = await DatabaseService().retrieveUserInfo(uid: userUid);
  }
}

class Badge extends AnimatedWidget {
  Badge({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.rotate(
      angle: animation.value,
      child: Image.asset(
        "assets/badge.png",
        width: 40,
      ),
    );
  }
}
