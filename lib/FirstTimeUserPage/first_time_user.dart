import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keep_it_clean/FirstTimeUserPage/fade_animation.dart';
import 'package:keep_it_clean/FirstTimeUserPage/page1.dart';
import 'package:keep_it_clean/FirstTimeUserPage/page2.dart';
import 'package:keep_it_clean/FirstTimeUserPage/page3.dart';
import 'package:keep_it_clean/Maps/maps_page.dart';
import 'package:keep_it_clean/Maps/search_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:keep_it_clean/Utils/utils.dart';

class FirstTimeUserWidget extends StatefulWidget {
  @override
  _FirstTimeUserWidgetState createState() => _FirstTimeUserWidgetState();
}

class _FirstTimeUserWidgetState extends State<FirstTimeUserWidget>
    with SingleTickerProviderStateMixin {
//  AnimationController _scaleController;
//  Animation<double> _scaleAnimation;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff4f8f9),
        body: ScrollConfiguration(
          behavior: FilterListBehavior(),
          child: ListView(
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            physics: PageScrollPhysics(),
            children: <Widget>[
              Page1(),
              Page2(),
              Page3()
            ],
          ),
        ),
      ),
    );
  }

//  @override
//  void initState() {
//    super.initState();
//
//    _scaleController =
//        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
//
//    _scaleAnimation = Tween<double>(begin: 0.0, end: 3.0)
//        .chain(CurveTween(curve: Curves.easeIn))
//        .animate(_scaleController)
//          ..addStatusListener((status) {
//            if (status == AnimationStatus.completed) {
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => Maps()),
//              );
//            }
//          });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return SafeArea(
//      child: Scaffold(
//        backgroundColor: Colors.green,
//        body: Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              begin: Alignment.topLeft,
//              end: Alignment.bottomRight,
//              stops: [0.1, 0.7, 0.9],
//              colors: [
//                Colors.green[700],Colors.green[500],Colors.green[400]
//              ],
//            ),
//          ),
//          child: Stack(
//            children: <Widget>[
//
//              Positioned(
//                top: 10,
//                child: FadeAnimation(
//                  2,
//                  Text(
//                    "Ciao!",
//                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 94),
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(bottom:200.0),
//                child: Align(
//                    alignment: Alignment.centerRight,
//                    child: FadeAnimation(
//                      4,
//                      Text(
//                        "Sembra sia la prima volta che ci vediamo",
//                        textAlign: TextAlign.right,
//                        style: TextStyle(
//                            fontWeight: FontWeight.normal, fontSize: 32),
//                      ),
//                    )),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(bottom:200.0),
//                child: Align(
//                    alignment: Alignment.bottomCenter,
//                    child: FadeAnimation(
//                      6,
//                      Text(
//                        "Keep it Clean richiede la posizione del tuo dispositivo per poter funzionare.",
//                        textAlign: TextAlign.center,
//                        style:
//                            TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
//                      ),
//                    )),
//              ),
//              Align(
//                alignment: Alignment.bottomCenter,
//                child: FadeAnimation(
//                  6,
//                  FlatButton(
//                    color: Colors.transparent,
//                    onPressed: () async {
//                      await PermissionHandler()
//                          .requestPermissions([PermissionGroup.location]);
//                      setState(() {
//                        _scaleController.forward();
//                      });
//                    },
//                    child: Text("Fornisci permesso posizione",
//                        style: TextStyle(
//                            fontWeight: FontWeight.w100, fontSize: 18)),
//                  ),
//                ),
//              ),
//              Center(child: AnimatedBuilder(animation: _scaleController,
//                builder: (context, child) => Transform.scale(
//                    scale: _scaleAnimation.value,
//                    child: Container(
//                      decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          color: Colors.white.withOpacity(.95)
//                      ),
//                      child: Center(
//                        child: Image.asset("assets/loading.gif"),
//                      ),
//                    )
//                ),
//
//              )),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
}
