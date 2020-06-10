import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/services/bin_details_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/ui/views/BinDetailsPage/bin_details_viewmodel.dart';
import 'package:keep_it_clean/ui/views/BinDetailsPage/like_bar.dart';
import 'package:stacked/stacked.dart';

class LikeButton extends StatelessWidget {
  final int type;
  final String binID;
  final prevModel;

  LikeButton({this.type, this.binID, this.prevModel });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LikeButtonModel>.reactive(
        onModelReady: (model){model.binID = this.binID; model.prevModel = prevModel;} ,
        builder: (context, model, child) => TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: model.endValueScale),
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 800),
              builder: (BuildContext context, double scale, Widget child) {
                return Transform.scale(
                  scale: sin(scale) + 1,
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: model.endValue),
                    duration: Duration(milliseconds: 900),
                    curve: Curves.easeInOutQuad,
                    builder:
                        (BuildContext context, double value, Widget child) {
                      return Transform.rotate(
                        angle: sin(value) / 1.4,
                        child: IconButton(
                            color: Colors.white,
                            icon: child,
                            onPressed: () async {
                              model.clickButton(type);
                            }),
                      );
                    },
                    child: Icon(type == 1 ? Icons.thumb_up : Icons.thumb_down),
                  ),
                );
              },
            ),
        viewModelBuilder: () => LikeButtonModel());
  }
}

class LikeButtonModel extends BaseViewModel {
  DatabaseService _databaseService = locator<DatabaseService>();
  AuthService _authService = locator<AuthService>();

  LikeBarModel prevModel;


  String binID;

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
    type == 1
        ? await _databaseService.addLikeBin(binID, _authService.currentUser)
        : await _databaseService.addDislikeBin(binID, _authService.currentUser);

    prevModel.notifySourceChanged(clearOldData: true);
  }
}
