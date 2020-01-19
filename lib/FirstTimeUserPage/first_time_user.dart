import 'package:flutter/material.dart';
import 'package:keep_it_clean/FirstTimeUserPage/FadeAnimation.dart';
import 'package:keep_it_clean/Maps/maps_page.dart';
import 'package:permission_handler/permission_handler.dart';

class FirstTimeUserWidget extends StatefulWidget {
  @override
  _FirstTimeUserWidgetState createState() => _FirstTimeUserWidgetState();
}

class _FirstTimeUserWidgetState extends State<FirstTimeUserWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _scaleController;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    _scaleAnimation = Tween<double>(begin: 0.0, end: 3.0)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(_scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Maps()),
              );
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green,
        body: Container(
          // Add box decoration
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.7, 0.9],
              colors: [
                Colors.green[800],Colors.green[500],Colors.green[400]
              ],
            ),
          ),
          child: Stack(
            children: <Widget>[

              Positioned(
                top: 10,
                child: FadeAnimation(
                  2,
                  Text(
                    "Ciao!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 94),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom:200.0),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: FadeAnimation(
                      4,
                      Text(
                        "Sembra sia la prima volta che ci vediamo",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 32),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom:200.0),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FadeAnimation(
                      6,
                      Text(
                        "Keep it Clean richiede la posizione del tuo dispositivo per poter funzionare.",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                      ),
                    )),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FadeAnimation(
                  6,
                  FlatButton(
                    color: Colors.transparent,
                    onPressed: () async {
                      await PermissionHandler()
                          .requestPermissions([PermissionGroup.location]);
                      setState(() {
                        _scaleController.forward();
                      });
                    },
                    child: Text("Fornisci permesso posizione",
                        style: TextStyle(
                            fontWeight: FontWeight.w100, fontSize: 18)),
                  ),
                ),
              ),
              Center(child: AnimatedBuilder(animation: _scaleController,
                builder: (context, child) => Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(.95)
                      ),
                    )
                ),

              )),
            ],
          ),
        ),
      ),
    );
  }
}
