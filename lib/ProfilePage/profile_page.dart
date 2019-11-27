import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';

import 'language_dialog.dart';

class ProfilePage extends StatefulWidget {
  final FirebaseUser user;

  ProfilePage(this.user,{Key key});

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

  @override
  void initState() {
    if(widget.user != null) {
      userName = widget.user.displayName.split(" ");
    }
    super.initState();
    // init badge animation
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    final Animation curve =
    CurvedAnimation(parent: controller, curve: Curves.easeInOutQuint);
    animation = Tween<double>(begin: 0, end: pi * 6).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.stop();
        }
      });

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  Widget _createBox(double width, int index) {
    String img, name, n;

    switch (index) {
      case 0:
        img = "assets/plastic_bottle.png";
        name = AppTranslations.of(context).text("plastic_string");
        n = "10";
        break;
      case 1:
        img = "assets/glass_bottle.png";
        name = AppTranslations.of(context).text("glass_string");
        n = "4";
        break;
      case 2:
        img = "assets/paper.png";
        name = AppTranslations.of(context).text("paper_string");
        n = "6";
        break;
      case 3:
        img = "assets/indifferenziata.png";
        name = AppTranslations.of(context).text("other_string");
        n = "5";
        break;
    }

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
            Image.asset(
              img,
              height: 120,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(name,
                      overflow: TextOverflow.ellipsis,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.green[300],
          body: SingleChildScrollView(
            child: Column(
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
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return languageDialog(context);
                            });
                      },
                      child: Image.asset(
                        "assets/italy.png",
                        width: 30,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () => {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(builder: (context) => WhoAmIPage()),
//                        )
                      },
                      icon: Icon(
                        Icons.info_outline,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 40),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: -20,
                      child: Hero(
                        tag: "profilePic",
                        child: CircleAvatar(
                          backgroundImage: (widget.user != null) ? NetworkImage(widget.user.photoUrl,scale: 1 ) : ExactAssetImage('assets/trees.jpeg'),

                        maxRadius: 40,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 70,
                      child: Text(userName != null ? userName[0] : "N/A",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                          )),
                    ),
                    Positioned(
                      top: 50,
                      left: 90,
                      child: Text(userName != null ? userName[1] : "N/A",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                          )),
                    ),
                    Positioned(
                      top: 10,
                      right: 30,
                      child: GestureDetector(
                        onTap: () {
                          controller.forward();
                        },
                        child: Badge(animation: animation),
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      left: 10,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          verticalDirection: VerticalDirection.down,
                          children: <Widget>[
                            Text("25",
                                style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Montserrat",
                                )),
                            Text(" " + AppTranslations.of(context).text('report_string'),

                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Montserrat",
                                )),
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
                  child: new Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return _createBox(
                          MediaQuery.of(context).size.width * 0.85, index);
                    },
                    itemCount: 4,
                    viewportFraction: 0.8,
                    scale: 0.8,
                  ),
                )
              ],
            ),
          )),
    );
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
