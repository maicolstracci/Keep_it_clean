import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:stacked_services/stacked_services.dart';

class OnboardingPage3 extends StatelessWidget {
  final FirebaseUser user;

  const OnboardingPage3({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NavigationService _navigationService = locator<NavigationService>();

    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: Image.asset("assets/illustrations/background.png"),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: CurveClipper(),
              child: Container(
                color: Color(0xff06442d).withOpacity(.90),
                height: MediaQuery.of(context).size.height / 2,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.ideographic,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      tr("Cominciamo"),
                      style: TextStyle(
                          color: Colors.green[400],
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.green[600],
                      size: 28.0,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Image.asset("assets/illustrations/page3.png",fit: BoxFit.fitWidth,),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: AutoSizeText(
                        tr("PERMESSI"),
                        maxLines: 1,
                        presetFontSizes: [50,36, 22],
                        style: TextStyle(
                            color: Color(0xfff4f8f9),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: AutoSizeText(
                          tr("permessi_string"),
                          maxLines: 4,
                          minFontSize: 1,
                          maxFontSize: 50,

                          textAlign: TextAlign.center,
                          style:
                          TextStyle(color: Color(0xfff4f8f9)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    var controlPoint = Offset(size.width / 2.6, 80);

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 40);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, 0, 40);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
