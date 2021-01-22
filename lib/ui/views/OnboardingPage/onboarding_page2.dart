import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OnboardingPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
              child: SizedBox.expand(
                  child: Image.asset(
            "assets/illustrations/background.png",
            fit: BoxFit.cover,
          ))),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: CurveClipper(),
              child: Container(
                color: Color(0xff06442d).withOpacity(.90),
                height: MediaQuery.of(context).size.height / 2.2,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.ideographic,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      tr("Prosegui"),
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
                child: Container(
                    height: 310,
                    width: 310,                    child: Padding(
                      padding: const EdgeInsets.only(bottom:16.0),
                      child: Image.asset(
                        "assets/illustrations/page2.png",
                        fit: BoxFit.fitWidth,
                      ),
                    )),
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
                        tr("report"),
                        maxLines: 1,
                        maxFontSize: 100,
                        style: TextStyle(
                            fontSize: 100,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AutoSizeText(
                          tr("report_string"),
                          maxLines: 3,
                          minFontSize: 1,
                          maxFontSize: 50,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xfff4f8f9)),
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

    var controlPoint = Offset(size.width * 0.60, -10);

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
