import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'DatabaseServices/database_services.dart';
import 'Localization/app_translation.dart';
import 'Models/bin_model.dart';
import 'ProfilePage/profile_page.dart';

class BinPage extends StatefulWidget {
  final MarkerId markerId;
  final FirebaseUser user;

  const BinPage({this.markerId, this.user});

  @override
  _BinPageState createState() => _BinPageState();
}

class _BinPageState extends State<BinPage> with TickerProviderStateMixin {
  Bin _bin;
  String _img;
  int _likes, _dislikes;
  Animation<double> animationLike;
  Animation<double> animationDislike;
  AnimationController controllerLike;
  AnimationController controllerDislike;

  @override
  void initState() {
    super.initState();

    controllerLike = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    controllerDislike = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    final Animation curve =
        CurvedAnimation(parent: controllerLike, curve: Curves.easeInOut);

    animationLike = Tween<double>(begin: 1, end: 1.5).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controllerLike.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controllerLike.stop();
        }
      });

    animationDislike = Tween<double>(begin: 1, end: 1.5).animate(
        CurvedAnimation(parent: controllerDislike, curve: Curves.easeInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controllerDislike.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controllerDislike.stop();
        }
      });
  }

  Future<bool> recoverBinData(markerId) async {
    _bin = await DatabaseService().getBinInfo(markerId);

    _img = await DatabaseService()
        .getImageFromUrl(_bin.photoUrl)
        .timeout(Duration(seconds: 2), onTimeout: () {
      return null;
    });

    _likes = _bin.likes != null ? _bin.likes : 0;
    _dislikes = _bin.dislikes != null ? _bin.dislikes : 0;

    return (_bin != null && _img != null);
  }

  AlertDialog createAlertDialog(
      BuildContext context, String documentId, FirebaseUser user) {
    if (user == null) {
      return AlertDialog(
        elevation: 20,
        title: new Text(
          AppTranslations.of(context).text("only_auth_user"),
        ),
        actions: <Widget>[
          FlatButton(
            child: new Text(AppTranslations.of(context).text("i_understand")),
            textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else
      return AlertDialog(
        elevation: 20,
        title: new Text(
          AppTranslations.of(context).text("report_bin_string"),
        ),
        actions: <Widget>[
          FlatButton(
            child: new Text(AppTranslations.of(context).text("no")),
            textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: new Text(AppTranslations.of(context).text("yes")),
            color: Colors.red,
            textColor: Colors.black,
            onPressed: () {
              DatabaseService().reportBinProblem(documentId, user);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
  }

  void _launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    controllerLike.dispose();
    controllerDislike.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[400],
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<bool>(
              future: recoverBinData(widget.markerId),
              builder: (context, data) {
                if (data.hasData) {
                  return Column(
                    children: <Widget>[
                      Flexible(
                        flex: 6,
                        child: Stack(
                          children: <Widget>[
                            ClipPath(
                              clipper: BottomCurveClipper(),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: double.infinity,
                                decoration: BoxDecoration(color: Colors.white),
                                child: _img != null
                                    ? FadeInImage.assetNetwork(
                                        placeholder: 'assets/loading.gif',
                                        image: _img,
                                        fit: BoxFit.fitWidth,
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 12.0,
                                            left: 6.0,
                                            right: 6.0),
                                        child: Image.asset(
                                          'assets/default-bin-photo.png',
                                          fit: BoxFit.contain,
                                          alignment: Alignment.bottomCenter,
                                        ),
                                      ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: IconButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () =>
                                            {Navigator.pop(context)},
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(right: 24, left: 24),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4.0,
                                            ),
                                          ],
                                          color: Colors.white
                                              .withOpacity(.95),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Text(
                                        AppTranslations.of(context)
                                            .text("icon_string_${_bin.type}"),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                            fontSize: 24),
                                      ),
                                    ),
                                    Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return createAlertDialog(
                                                      context,
                                                      _bin.id,
                                                      widget.user);
                                                });
                                          },
                                          icon: Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4.0,
                                            ),
                                          ],
                                          shape: BoxShape.circle,
                                          color: Colors.green[700]
                                              .withOpacity(.98)),
                                      child: GestureDetector(
                                          onTap: () async {
                                            if (widget.user != null) {
                                              controllerLike.forward();
                                              await DatabaseService()
                                                  .addLikeBin(
                                                      widget.markerId.value,
                                                      widget.user);

                                              setState(() {});
                                            } else {
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text(AppTranslations
                                                              .of(context)
                                                          .text(
                                                              "no_auth_user_like"))));
                                            }
                                          },
                                          child: LikeButton(
                                              animation: animationLike,
                                              icon: Icons.thumb_up)),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4.0,
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            _likes.toString(),
                                            style: TextStyle(
                                                fontSize: 32,
                                                color: Colors.green),
                                          ),
                                          Text(
                                            " - ",
                                            style: TextStyle(fontSize: 32),
                                          ),
                                          Text(
                                            _dislikes.toString(),
                                            style: TextStyle(
                                                fontSize: 32,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4.0,
                                            ),
                                          ],
                                          shape: BoxShape.circle,
                                          color:
                                              Colors.red[800].withOpacity(.98)),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (widget.user != null) {
                                            controllerDislike.forward();
                                            await DatabaseService()
                                                .addDislikeBin(
                                                    widget.markerId.value,
                                                    widget.user);

                                            setState(() {});
                                          } else {
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(AppTranslations
                                                            .of(context)
                                                        .text(
                                                            "no_auth_user_like"))));
                                          }
                                        },
                                        child: LikeButton(
                                            animation: animationDislike,
                                            icon: Icons.thumb_down),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    AppTranslations.of(context)
                                        .text("reported_by"),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4.0,
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      padding: EdgeInsets.only(left: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Flexible(
                                            child: Container(
                                              child: Text(
                                                _bin.username,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfilePage(
                                                            uid: _bin.uidUser)),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.launch,
                                              color: Colors.blue,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    AppTranslations.of(context)
                                        .text("date_string"),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4.0,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white),
                                    padding: EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          _bin.reportDate.substring(0, 10),
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: FlatButton(
                                  padding: const EdgeInsets.all(10),
                                  onPressed: () {
                                    _launchMapsUrl(
                                        _bin.latitude, _bin.longitude);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(6.0),
                                  ),
                                  color: Colors.blue[400],
                                  textColor: Colors.white,
                                  child: Text(
                                    AppTranslations.of(context)
                                        .text("take_me_there_string"),
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else
                  return Container(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
              }),
        ),
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    var controlPoint = Offset(size.width / 2, size.height - 65);

    path.lineTo(0, size.height - 10);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, size.width, size.height - 10);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class LikeButton extends AnimatedWidget {
  final IconData icon;

  LikeButton({Key key, Animation<double> animation, this.icon})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.scale(
        scale: animation.value,
        child: Icon(
          icon,
          color: Colors.white,
        ));
  }
}
