import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/ui/views/BinDetailsPage/like_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LikeButton extends StatelessWidget {
  final int type;
  final String binID;
  final prevModel;

  LikeButton({required this.type, required this.binID, this.prevModel});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LikeButtonModel>.reactive(
        onModelReady: (model) {
          model.binID = this.binID;
          model.prevModel = prevModel;
        },
        builder: (context, model, child) => SizedBox.shrink(),
        // TweenAnimationBuilder(
        //   tween: Tween<double>(begin: 0, end: model.endValueScale),
        //   curve: Curves.fastLinearToSlowEaseIn,
        //   duration: Duration(milliseconds: 800),
        //   builder: (BuildContext context, double scale, Widget child) =>
        //       Container(
        //         child: Transform.scale(
        //           scale: sin(scale) + 1,
        //           child: TweenAnimationBuilder(
        //             tween: Tween<double>(begin: 0, end: model.endValue),
        //             duration: Duration(milliseconds: 900),
        //             curve: Curves.easeInOutQuad,
        //             builder:
        //                 (BuildContext context, double value, Widget child) {
        //               return Container(
        //                 child: Transform.rotate(
        //                   angle: sin(value) / 1.4,
        //                   child: IconButton(
        //                       disabledColor: Colors.white,
        //                       color: Colors.white,
        //                       splashColor: Colors.transparent,
        //                       highlightColor: Colors.transparent,
        //                       icon: child,
        //                       onPressed: model.authService.currentUser !=
        //                           null
        //                           ? () async {
        //                         model.clickButton(type);
        //                       }
        //                           : () => model.showNoLoggedInDialog()),
        //                 ),
        //               );
        //             },
        //             child: Icon(
        //                 type == 1 ? Icons.thumb_up : Icons.thumb_down),
        //           ),
        //         ),
        //       );
        //   ,
        // ),
        viewModelBuilder: () => LikeButtonModel());
  }
}

class LikeButtonModel extends BaseViewModel {
  DatabaseService _databaseService = locator<DatabaseService>();
  AuthService authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();

  late LikeBarModel prevModel;

  late String binID;

  double endValueScale = 0;
  double endValue = 0;

  clickButton(int type) async {
    if (endValue == 0) {
      endValue = pi * 5;
      endValueScale = pi;
    } else {
      endValue = 0;
      endValueScale = 0;
    }

    notifyListeners();

    await Future.delayed(Duration(seconds: 1));

    type == 1
        ? await _databaseService.addLikeBin(binID, authService.currentUser!)
        : await _databaseService.addDislikeBin(binID, authService.currentUser!);

    prevModel.notifySourceChanged(clearOldData: true);
  }

  showNoLoggedInDialog() {
    _dialogService.showDialog(
        title: tr("Utente non autenticato"),
        description:
            tr("Solo gli utenti autenticati possono lasciare like/dislike"),
        buttonTitle: tr("Ho capito"));
  }
}
