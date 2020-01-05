
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keep_it_clean/AddBin/add_bin_page.dart';
import 'package:keep_it_clean/DatabaseServices/database_services.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:keep_it_clean/Models/bin_model.dart';
import 'package:keep_it_clean/ProfilePage/profile_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'map_widget.dart';
import 'search_widget.dart';

class Maps extends StatefulWidget {
  final FirebaseUser user;
  final String fbPic;

  const Maps({Key key, this.user, this.fbPic}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final db = Firestore.instance;
  List<Bin> binList;

  Map<PermissionGroup, PermissionStatus> permissions;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  // Request permission method from permissions_handlers plugin
  void requestPermission() async {
    permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
  }

  void _showSnackBar(BuildContext context, int variant) {
    String s;
    switch (variant) {
      case 1:
        s = "you_are_guest_profile_string";
        break;
      case 2:
        s = "you_are_guest_add_string";
        break;
      case 3:
        s = "location_requested_string";
        break;
    }

    final snackBar = SnackBar(
      content: Text(AppTranslations.of(context).text(s)),
      action: (variant == 1 || variant == 2)
          ? SnackBarAction(
              label: "LOGIN",
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : SnackBarAction(
              label: AppTranslations.of(context).text("settings_string"),
              onPressed: () {
                PermissionHandler().openAppSettings();
              },
            ),
      behavior: SnackBarBehavior.fixed,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Bin>>.value(
          value: DatabaseService().streamBins(),
        ),
        ChangeNotifierProvider<TypeChanger>(create: (_) => TypeChanger(0))
      ],
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            key: _scaffoldKey,
            body: StreamBuilder<List<Bin>>(
                stream: DatabaseService().streamBins(),
                builder: (context, snapshot) {
                  return Stack(
                    children: <Widget>[
                      MapWidget(),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: () {
                            if (widget.user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfilePage(widget.user, widget.fbPic)),
                              );
                            } else {
                              _showSnackBar(context, 1);
                            }
                          },
                          child: Hero(
                            tag: "profilePic",
                            child: new Container(
                              width: 60,
                              height: 60,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10.0,
                                    ),
                                  ]),
                              child: CircleAvatar(
                                backgroundImage: (widget.user != null)
                                    ? NetworkImage(
                                        widget.fbPic == null
                                            ? widget.user.photoUrl
                                            : widget.fbPic,
                                        scale: 1)
                                    : ExactAssetImage('assets/no-avatar.jpg'),
                                maxRadius: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        right: 10,
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: SearchWidget()),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 10,
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green[300],
                          ),
                          child: RawMaterialButton(
                            shape: CircleBorder(),
                            onPressed: () {
                              if (widget.user != null) {
                                PermissionHandler()
                                    .checkPermissionStatus(
                                        PermissionGroup.location)
                                    .then((permission) {
                                  if (permission == PermissionStatus.granted) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddBin(
                                                  user: widget.user,
                                                )));
                                  } else {
                                    _showSnackBar(context, 3);
                                  }
                                });
                              } else {
                                _showSnackBar(context, 2);
                              }
                            },
                            child: Icon(
                              Icons.add,
                              size: 32,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
