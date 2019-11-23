import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';

import 'camera_functions.dart';

class AddBin extends StatefulWidget {
  final Function createBin;

  const AddBin(this.createBin, {Key key}) : super(key: key);

  @override
  _AddBinState createState() => _AddBinState();
}

class _AddBinState extends State<AddBin> {
  int _selected = 0;
  String imgPath;
  bool imgUploaded = false;

  Future<void> takePicture() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    // launch TakePictureScreen and await for the picture path
    imgPath = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TakePictureScreen(
                camera: firstCamera,
              )),
    );

    if (imgPath != null) {
      imgUploaded = true;
    }
    setState(() {});
  }

  Future<String> _uploadImage(String imgPath) async {
    String _imgName = '${DateTime.now()}.png';
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(_imgName);

    //TODO: check for other results
    StorageUploadTask uploadTask = storageReference.putFile(File(imgPath));
    await uploadTask.onComplete;

    return _imgName;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.green[300],
      body: Stack(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selected = 1;
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
                                    color: _selected == 1
                                        ? Colors.green
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.asset(
                                    "assets/plastic_bottle.png",
                                  ),
                                ),
                              ),
                              Text(
                                  AppTranslations.of(context)
                                      .text("plastic_string"),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                  )),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selected = 2;
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
                                    color: _selected == 2
                                        ? Colors.green
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.asset(
                                    "assets/glass_bottle.png",
                                  ),
                                ),
                              ),
                              Text(
                                  AppTranslations.of(context)
                                      .text("glass_string"),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                  )),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selected = 3;
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
                                    color: _selected == 3
                                        ? Colors.green
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/paper.png",
                                  ),
                                ),
                              ),
                              Text(
                                  AppTranslations.of(context)
                                      .text("paper_string"),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                  )),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selected = 4;
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
                                    color: _selected == 4
                                        ? Colors.green
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.asset(
                                    "assets/indifferenziata.png",
                                  ),
                                ),
                              ),
                              Text(
                                  AppTranslations.of(context)
                                      .text("other_string"),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Text(
                        AppTranslations.of(context).text("other_type_string"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.normal,
                            fontSize: 24),
                      ),
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
                            ? FileImage(File(imgPath))
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
              onPressed: () {
                _uploadImage(imgPath).then((imgName) {
                  widget.createBin(_selected != 0 ? _selected : 1, imgName);
                  Navigator.pop(context);
                });
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
          )
        ],
      ),
    ));
  }
}
