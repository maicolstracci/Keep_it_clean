import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
          Center(
            child: Image.asset("assets/illustrations/page1.png"),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 50, left: 40, right: 40),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("CERCA", style: TextStyle(color: Color(0xfff4f8f9), fontSize: 52, fontWeight: FontWeight.w600),),
                SizedBox(
                  height: 20,
                ),
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet", textAlign: TextAlign.center, style: TextStyle(color: Color(0xfff4f8f9), fontSize: 18),),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                textBaseline: TextBaseline.ideographic,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("Swipe", style: TextStyle(color: Colors.green[300],fontSize: 18,fontWeight: FontWeight.bold),),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.green[500],
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ],
              ),
            ),
          )
        ],
      ) ,
    );
  }

}

class CurveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path =  new Path();

    var controlPoint = Offset(size.width/2,70);
    var endPoint = Offset(0,size.width);

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