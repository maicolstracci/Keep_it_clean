import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keep_it_clean/AddBin/dialogs.dart';
import 'package:keep_it_clean/AddBin/select_position.dart';
import 'package:keep_it_clean/DatabaseServices/database_services.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:keep_it_clean/Models/bin_model.dart';
import 'package:permission_handler/permission_handler.dart';

class AddBinNew extends StatefulWidget {
  final FirebaseUser user;

  const AddBinNew({this.user, Key key}) : super(key: key);

  @override
  _AddBinNewState createState() => _AddBinNewState();
}

class _AddBinNewState extends State<AddBinNew> {
  List<int> _selected = [];
  String imgPath;
  bool imgUploaded = false;
  bool _uploadInProgress = false;
  File compressedImage;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> takePicture() async {
    compressedImage = await ImagePicker.pickImage(
            source: ImageSource.camera, imageQuality: 30)
        .catchError((e) {
      print(e.code);
      if (e.code == "camera_access_denied") {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 6),
          content: Text(AppTranslations.of(context).text("camera_error")),
          action: SnackBarAction(
            label: AppTranslations.of(context).text("settings_string"),
            onPressed: () {
              PermissionHandler().openAppSettings();
            },
          ),
        ));
      }
    });
    if (compressedImage != null) {
      LatLng lat = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SelectPosition()),
      );
      if (lat != null) {
        setState(() {
          _uploadInProgress = true;
        });
        _uploadImage(compressedImage).then((imgName) async {
          Bin bin = await addBin(_selected, imgName, lat);
          Navigator.pop(context, bin);
        });
      }
    }
  }

  Future<Bin> addBin(List<int> types, String imgName, LatLng binPos) async {
    Bin _bin;

    types.forEach((type) async {
      _bin =
          await DatabaseService().createBin(type, imgName, binPos, widget.user);
    });
    DatabaseService().addPoints(widget.user, types);

    return _bin;
  }

  Future<String> _uploadImage(File img) async {
    String _imgName = '${DateTime.now()}';
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(_imgName);

    //TODO: check for other results
    StorageUploadTask uploadTask = storageReference.putFile(img);
    await uploadTask.onComplete;
    _uploadInProgress = false;

    img.delete();
    return _imgName;
  }

  Widget _buildButton(String imgButton, String nameButton, int type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selected.contains(type)) {
            _selected.remove(type);
          } else {
            _selected.add(type);
          }
        });
      },
      child: AnimatedContainer(
        height: 150,
        width: 150,
        duration: Duration(milliseconds: 2),
        decoration: BoxDecoration(
            color: Colors.white,
            border: new Border.all(
              width: 3.0,
              color:
                  _selected.contains(type) ? Colors.blue : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0,
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  AutoSizeText(
                    AppTranslations.of(context).text(nameButton),
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      imgButton,
                      fit: BoxFit.contain,
                    ),
                  ))
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Visibility(
                  visible: _selected.contains(type) ? true : false,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                    size: 34,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (compressedImage != null) {
          compressedImage.delete();
        }

        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.green[400],
        appBar: AppBar(
          elevation: 0,
          title: Text("Segnala un bidone"),
          backgroundColor: Colors.green[400],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      AutoSizeText(
                        "Puoi selezionare piu' di una tipologia!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600),
                        maxFontSize: 28,
                        maxLines: 2,
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Wrap(
                            runAlignment: WrapAlignment.spaceAround,
                            spacing: 15,
                            runSpacing: 15,
                            children: <Widget>[
                              _buildButton("assets/icons/icon_type_1.png",
                                  "icon_string_1", 1),
                              _buildButton("assets/icons/icon_type_2.png",
                                  "icon_string_2", 2),
                              _buildButton("assets/icons/icon_type_3.png",
                                  "icon_string_3", 3),
                              _buildButton("assets/icons/icon_type_4.png",
                                  "icon_string_4", 4),
                              _buildButton("assets/icons/icon_type_5.png",
                                  "icon_string_5", 5),
                              _buildButton("assets/icons/icon_type_6.png",
                                  "icon_string_6", 6),
                              _buildButton("assets/icons/icon_type_7.png",
                                  "icon_string_7", 7),
                              _buildButton("assets/icons/icon_type_8.png",
                                  "icon_string_8", 8),
                              _buildButton("assets/icons/icon_type_9.png",
                                  "icon_string_9", 9),
                              _buildButton("assets/icons/icon_type_10.png",
                                  "icon_string_10", 10),
                              _buildButton("assets/icons/icon_type_11.png",
                                  "icon_string_11", 11),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4.0,
                            ),
                          ]),
                      child: GestureDetector(
                        onTap: () async {
                          if (_selected.isNotEmpty) {
                            takePicture();
                          } else {
                            if (_selected.isEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return showNoSelectedTypeDialog(context);
                                  });
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Prosegui",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Center(
              child: Visibility(
                  visible: _uploadInProgress,
                  child: Container(
                      height: 300,
                      width: 250,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 40),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border:
                          Border.all(color: Colors.black12, width: 2)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context)
                                .text("houston_string"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            AppTranslations.of(context)
                                .text("uploading_report_online"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
