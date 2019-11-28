import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'dialogs.dart';
import 'camera_functions.dart';

class AddBin extends StatefulWidget {
  final Function createBin;

  const AddBin(this.createBin, {Key key}) : super(key: key);

  @override
  _AddBinState createState() => _AddBinState();
}

class _AddBinState extends State<AddBin> {
  List<int> _selected = [];
  String imgPath;
  bool imgUploaded = false;
  bool _uploadInProgress = false;

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
    _uploadInProgress = false;

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
          Text(AppTranslations.of(context).text(nameButton),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat",
              )),
        ],
      ),
    );
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
                    Wrap(
                      spacing: 15,
                      runSpacing: 30,
                      children: <Widget>[
                        _buildButton(
                            "assets/plastic_bottle.png", "plastic_string", 1),
                        _buildButton(
                            "assets/glass_bottle.png", "glass_string", 2),
                        _buildButton("assets/paper.png", "paper_string", 3),
                        _buildButton(
                            "assets/indifferenziata.png", "other_string", 4),
                        _buildButton("assets/battery.png", "battery_string", 5),
                        _buildButton("assets/drugs.png", "drugs_string", 6),
                        _buildButton("assets/leaf.png", "leaf_string", 7),
                        _buildButton(
                            "assets/clothing.png", "clothing_string", 8),


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
                if (imgPath != null && _selected.isNotEmpty) {
                  setState(() {
                    _uploadInProgress = true;
                  });
                  _uploadImage(imgPath).then((imgName) {
                    widget.createBin(_selected, imgName);
                    Navigator.pop(context);
                  });
                } else {
                  if (imgPath == null) {
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
                        border: Border.all(color: Colors.black12,width: 2)),
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
    ));
  }
}
