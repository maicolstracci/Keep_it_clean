import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TakePictureService {

  File pic;

  Future<File> takePicture(String from) async {
  pic = await ImagePicker.pickImage(
        source: from == "camera" ? ImageSource.camera : ImageSource.gallery, imageQuality: 100, maxHeight: 1000, maxWidth: 1000)
        .catchError((e) {
      if (e.code == "camera_access_denied") {
        print(e.code);
      }
    });
  }

}