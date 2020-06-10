import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TakePictureService {

  File pic;

  Future<File> takePicture() async {
  pic = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 30)
        .catchError((e) {
      if (e.code == "camera_access_denied") {
        print(e.code);
      }
    });
  }

}