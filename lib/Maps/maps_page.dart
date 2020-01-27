import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keep_it_clean/AddBin/add_bin_page.dart';
import 'package:keep_it_clean/DatabaseServices/database_services.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:keep_it_clean/Models/bin_model.dart';
import 'package:keep_it_clean/ProfilePage/profile_page.dart';
import 'package:keep_it_clean/Utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  double firstTime = 0;


  @override
  void initState() {
    super.initState();
//    requestPermission();
  }



  Widget addBinButton(){
    return Container(
      margin: EdgeInsets.only(
        left: 10,
      ),
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        //border: Border.all(color: Colors.green[600],width: 2),

        color: Colors.blue[800].withOpacity(.98),
      ),
      child: RawMaterialButton(
        shape: CircleBorder(),
        onPressed: () {
          if (widget.user != null) {
            PermissionHandler()
                .checkPermissionStatus(
                PermissionGroup.location)
                .then((permission) {
              if (permission ==
                  PermissionStatus.granted) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddBin(
                              user: widget.user,
                            )));
              } else {
                showSnackBar(
                    context, 3, _scaffoldKey);
              }
            });
          } else {
            showSnackBar(context, 2, _scaffoldKey);
          }
        },
        child: Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    //
    return MultiProvider(
      providers: [
        StreamProvider<List<Bin>>.value(
          value: DatabaseService().streamBins(),
        ),
        ChangeNotifierProvider<TypeChanger>(
            create: (_) => TypeChanger(0, null)),
        ChangeNotifierProvider<SearchButtonChanger>(
            create: (_) => SearchButtonChanger(false)),
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
                      MapWidget(
                        binList: snapshot.data,
                      ),
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
                              showSnackBar(context, 1, _scaffoldKey);
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green[400].withOpacity(.85),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14))
                                  ),
                                  padding: EdgeInsets.only(left: 20,right: 10, bottom: 2, top:2),
                                  child: Text(
                                    "Seleziona un filtro",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ))
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                addBinButton(),
                                Expanded(
                                  child: SearchWidget(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
