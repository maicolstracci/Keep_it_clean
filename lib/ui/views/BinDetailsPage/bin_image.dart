import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/services/bin_details_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/services/take_picture_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BinImageView extends StatelessWidget {
  final String imgName;

  BinImageView({this.imgName});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BinImageViewModel>.reactive(
      onModelReady: (model) {
        model.imgName = this.imgName;
        model.runFuture();
      },
      builder: (context, model, child) => Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: model.data != null
            ? model.data != 'NO IMAGE'
                ? FadeInImage.assetNetwork(
                    placeholder: 'assets/loading.gif',
                    image: model.data,
                    fit: BoxFit.fitWidth,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tr("Nessuna immagine presente")),
                      SizedBox(
                        height: 8,
                      ),
                      RaisedButton.icon(
                          onPressed: () =>
                              model.showActionSheetIfAuthed(context),
                          icon: Icon(Icons.camera_alt),
                          label: Text(tr("Aggiungi una foto")))
                    ],
                  )
            : Container(
                color: Colors.transparent,
              ),
      ),
      viewModelBuilder: () => BinImageViewModel(),
    );
  }
}

class BinImageViewModel extends FutureViewModel<String> {
  DatabaseService _databaseService = locator<DatabaseService>();
  DialogService _dialogService = locator<DialogService>();
  TakePictureService _takePictureService = locator<TakePictureService>();
  AuthService _authService = locator<AuthService>();
  BinDetailsService _binDetailsService = locator<BinDetailsService>();

  String imgName;

  showActionSheetIfAuthed(BuildContext context) {
    if (_authService.currentUser != null) {
      showCupertinoModalPopup(
              context: context, builder: (context) => ActionSheet())
          .then((value) => uploadImage(value));
    } else {
      _dialogService.showDialog(
          title: tr("Accesso non consentito agli utenti ospiti"),
          description: tr(
              "Solo gli utenti che hanno effettuato l'accesso possono effettuare segnalazioni"),
          buttonTitle: tr("Ho capito"));
    }
  }

  uploadImage(String value) async {
    if (value == null) return;

    if (value == "Camera") {
      File pic = await _takePictureService.takePicture("camera");
      if (pic != null) {
        String _imgName = '${_authService.currentUser.uid}-${DateTime.now()}';

        //Show feedback
        _dialogService.showDialog(
            title: tr("Grazie"),
            description: tr(
                "Stiamo elaborando la tua immagine, appena verra' caricata sui nostri server la mostreremo a tutto il mondo!"));

        var photoUrl =
            await _databaseService.uploadImage(imgFile: pic, imgName: _imgName);
        _databaseService.modifyPhotoUrl(_binDetailsService.binID, photoUrl);
      }
    } else if (value == "Galleria") {
      File pic = await _takePictureService.takePicture("galleria");

      if (pic != null) {
        String _imgName = '${_authService.currentUser.uid}-${DateTime.now()}';
        //Show feedback
        _dialogService.showDialog(
            title: tr("Grazie"),
            description: tr(
                "Stiamo elaborando la tua immagine, appena verra' caricata sui nostri server la mostreremo a tutto il mondo!"));

        var photoUrl =
            await _databaseService.uploadImage(imgFile: pic, imgName: _imgName);
        _databaseService.modifyPhotoUrl(_binDetailsService.binID, photoUrl);
      }
    }
  }

  @override
  Future<String> futureToRun() async {
    if (imgName != null) {
      String result =
          await _databaseService.getDownloadUrlImageFromName(imgName);
      if (result == null)
        return "NO IMAGE";
      else
        return result;
    }
  }
}

class ActionSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(
        tr("Scegli come proseguire"),
        style: TextStyle(fontSize: 20),
      ),
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          tr("Cancella"),
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () {
          Navigator.pop(context, null);
        },
      ),
      actions: [
        CupertinoActionSheetAction(
          child: Text(tr("Camera")),
          onPressed: () {
            Navigator.pop(context, "Camera");
          },
        ),
        CupertinoActionSheetAction(
          child: Text(tr("Galleria")),
          onPressed: () {
            Navigator.pop(context, "Galleria");
          },
        ),
      ],
    );
  }
}
