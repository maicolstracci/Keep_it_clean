import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:keep_it_clean/Maps/maps_page.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';

class OnboardingPage3 extends StatelessWidget {

  final FirebaseUser user;

  const OnboardingPage3({Key key, this.user}): super(key:key);

  @override
  Widget build(BuildContext context) {
    NavigationService _navigationService = locator<NavigationService>();

    return GestureDetector(
      onHorizontalDragEnd: (details){
        PermissionHandler()
            .requestPermissions([PermissionGroup.location]).then((v) {
          _navigationService.navigateTo(Routes.mapsPage);
        });
      },
      child: Container(
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
              child: Image.asset("assets/illustrations/page3.png"),
            ),
            Container(
              padding: EdgeInsets.only(left: 40, right: 40),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    flex: 8,
                    child: Container(),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
                      children: <Widget>[
                        AutoSizeText(
                          AppTranslations.of(context).text("permissions"),
                          maxLines: 1,
                          presetFontSizes: [58, 36, 22],
                          style: TextStyle(
                              color: Color(0xfff4f8f9),
                              fontSize: 58,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AutoSizeText(
                          AppTranslations.of(context).text("permissions_string"),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(color: Color(0xfff4f8f9), fontSize: 22),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: FlatButton(
                onPressed: () {
                  PermissionHandler()
                      .requestPermissions([PermissionGroup.location]).then((v) {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Maps()));
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textBaseline: TextBaseline.ideographic,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      AppTranslations.of(context).text("lets_go"),
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
            )
          ],
        ),
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
