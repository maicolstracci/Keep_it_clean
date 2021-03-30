import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/bloc/bloc_utils.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/services/bin_details_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/services/take_picture_service.dart';
import 'package:stacked_services/stacked_services.dart';

class BinImageView extends StatelessWidget {
  final String imgName;

  BinImageView({this.imgName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          BinImageBloc(BlocState(state: BlocStateEnum.INITIAL), imgName),
      child: BlocBuilder<BinImageBloc, BlocState<String>>(
          builder: (context, state) {
        switch (state.state) {
          case BlocStateEnum.LOADING:
            return Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.white),
            );
          case BlocStateEnum.INITIAL:
            context.watch<BinImageBloc>().loadImage();
            return Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.white),
            );
          case BlocStateEnum.DONE:
            return Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.white),
              child: state.data != null
                  ? state.data != 'NO IMAGE'
                      ? FadeInImage.assetNetwork(
                          placeholder: 'assets/loading.gif',
                          image: state.data,
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
                                onPressed: () => context
                                    .watch<BinImageBloc>()
                                    .showActionSheetIfAuthed(context),
                                icon: Icon(Icons.camera_alt),
                                label: Text(tr("Aggiungi una foto")))
                          ],
                        )
                  : Container(
                      color: Colors.transparent,
                    ),
            );
          default:
            return Center(
              child: Text("LOADING"),
            );
        }
      }),
    );
  }
}

class BinImageBloc extends Cubit<BlocState<String>> {
  DatabaseService _databaseService = locator<DatabaseService>();
  DialogService _dialogService = locator<DialogService>();
  TakePictureService _takePictureService = locator<TakePictureService>();
  AuthService _authService = locator<AuthService>();
  BinDetailsService _binDetailsService = locator<BinDetailsService>();

  String imgName;

  BinImageBloc(BlocState<String> state, this.imgName) : super(state);

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

  Future loadImage() async {
    if (imgName != null) {
      String result =
          await _databaseService.getDownloadUrlImageFromName(imgName);
      if (result == null)
        emit(BlocState(data: "NO IMAGE", state: BlocStateEnum.DONE));
      else
        emit(BlocState(data: result, state: BlocStateEnum.DONE));
    } else
      emit(BlocState(data: "NO IMAGE", state: BlocStateEnum.DONE));
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
