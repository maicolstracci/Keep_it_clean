import 'package:keep_it_clean/FirstTimeUserPage/first_time_user.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:flutter/material.dart';

class LoginPage2 extends StatefulWidget {
  @override
  _LoginPage2State createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
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
      height: 60,
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
              Align(
                alignment: Alignment.topRight,
                child: ClipPath(
                  clipper: CurveClipper(),
                  child: Container(
                    color: Colors.green[400],
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Transform.rotate(
                  angle: 3.14,
                  child: Transform.translate(
                    offset: Offset(20, -15),
                    child: ClipPath(
                      clipper: CurveClipper(),
                      child: Container(
                        color: Colors.green[400],
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text("Keep it"), Text("clean")],
                  ),
                ),
              ),
//              Center(
//
//                child: Padding(
//                  padding: const EdgeInsets.only(bottom: 180.0),
//                  child: Image.asset("assets/illustrations/login.png", scale: 2.5,),
//                ),
//              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      flex: 4,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(
                            "assets/illustrations/login.png",
                            scale: 2.5,
                          )),
                    ),
                    Flexible(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Social Login"),
                          _createLoginContainer("fb"),
                          _createLoginContainer("google"),
                          GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => FirstTimeUserWidget()),
                                );
                              },
                              child: _createLoginContainer("guest"))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    var controlPoint = Offset(size.width * 0.8, size.height * 0.8);
    var controlPoint2 = Offset(size.width * 0.65, size.height * 0.52);
    var controlPoint3 = Offset(size.width * 0.52, size.height * 0.25);
    var controlPoint4 = Offset(size.width * 0.2, size.height * 0.2);
    var controlPoint5 = Offset(0, size.height * 0.16);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.8);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, controlPoint2.dx, controlPoint2.dy);
    path.quadraticBezierTo(
        controlPoint3.dx, controlPoint3.dy, controlPoint4.dx, controlPoint4.dy);
    path.quadraticBezierTo(controlPoint5.dx, controlPoint5.dy, 0, 0);
//    path.close();
//    path.lineTo(0, size.height);
//    path.lineTo(size.width, size.height);
//    path.lineTo(size.width, 40);
//    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, 0, 40);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
