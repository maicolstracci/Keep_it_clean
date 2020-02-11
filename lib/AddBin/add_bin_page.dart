import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keep_it_clean/AddBin/select_position.dart';
import 'package:keep_it_clean/DatabaseServices/database_services.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'dialogs.dart';

/*
      Type  name
      1 plastic
      2 glass
      3 paper
      4 dry
      5 battery
      6 drugs
      7 leaf
      8 clothing

 */

class AddBin extends StatefulWidget {
  final FirebaseUser user;

  const AddBin({this.user, Key key}) : super(key: key);

  @override
  _AddBinState createState() => _AddBinState();
}

class _AddBinState extends State<AddBin> {
  List<int> _selected = [];
  String imgPath;
  bool imgUploaded = false;
  bool _uploadInProgress = false;
  File compressedImage;

  Future<void> takePicture() async {
    compressedImage = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 40);
    if (compressedImage != null) {
      imgUploaded = true;
    }
    setState(() {});
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

  GestureDetector _buildButton(String imgButton, String nameButton, int type) {
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
      child: Column(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 60,
            height: 60,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: new Border.all(
                width: 2.0,
                color: _selected.contains(type)
                    ? Colors.green
                    : Colors.transparent,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                imgButton,
              ),
            ),
          ),
          Text(AppTranslations.of(this.context).text(nameButton),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat",
              )),
        ],
      ),
    );
  }

  void addBin(List<int> types, String imgName, LatLng binPos) async {
    types.forEach((type) async {
      DatabaseService().createBin(type, imgName, binPos, widget.user);
    });
    DatabaseService().addPoints(widget.user, types);
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
        backgroundColor: Colors.green[300],
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 10,
            child: IconButton(
              onPressed: () => {Navigator.of(context).pop()},
              icon: Icon(
                Icons.arrow_back,
                size: 32,
              ),
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 40),
                  ],
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                //TODO: In small screens fix bottom overflow
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Text(
                        AppTranslations.of(context).text("type_string") + "?",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                    Wrap(
                      spacing: 15,
                      runSpacing: 30,
                      children: <Widget>[
                        _buildButton(
                            "assets/icons/icon_type_1.png", "icon_string_1", 1),
                        _buildButton(
                            "assets/icons/icon_type_2.png", "icon_string_2", 2),
                        _buildButton("assets/icons/icon_type_3.png", "icon_string_3", 3),
                        _buildButton(
                            "assets/icons/icon_type_4.png", "icon_string_4", 4),
                        _buildButton(
                            "assets/icons/icon_type_5.png", "icon_string_5", 5),
                        _buildButton("assets/icons/icon_type_6.png", "icon_string_6", 6),
                        _buildButton("assets/icons/icon_type_7.png", "icon_string_7", 7),
                        _buildButton(
                            "assets/icons/icon_type_8.png", "icon_string_8", 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            //left: MediaQuery.of(context).size.width * 0.27,
            top: 20,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    takePicture();
                  },
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.green[100],
                        backgroundImage: imgUploaded
                            ? FileImage(compressedImage)
                            : ExactAssetImage('assets/gallery-icon.png'),
                        maxRadius: 80,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green[300],
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.photo_camera,
                              size: 40,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width * 0.075,
            child: RawMaterialButton(
              onPressed: () async {
                if (compressedImage != null && _selected.isNotEmpty) {
                  // Ask the user if position is correct otherwise let them change it
                  LatLng lat = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectPosition()),
                  );
                  if (lat != null) {
                    setState(() {
                      _uploadInProgress = true;
                    });
                    _uploadImage(compressedImage).then((imgName) {
                      addBin(_selected, imgName, lat);
                      Navigator.pop(context);
                    });
                  }
                } else {
                  if (compressedImage == null) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return showNoImageDialog(context);
                        });
                  } else if (_selected.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return showNoSelectedTypeDialog(context);
                        });
                  }
                }
              },
              fillColor: Colors.white,
              splashColor: Colors.green[400],
              elevation: 0,
              highlightElevation: 0,
              constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.85,
                  minHeight: 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200.0),
              ),
              child: Text(
                AppTranslations.of(context).text("send_string"),
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                        border: Border.all(color: Colors.black12, width: 2)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Houston...\n richiediamo contatto al server, mi sentite?\n\nSperiamo vada tutto bene!",
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
                          "Stiamo caricando la tua segnalazione online.",
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
      ),
    );
  }
}
