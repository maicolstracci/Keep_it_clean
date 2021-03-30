import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:stacked/stacked.dart';

class ClassificaPageViewModel extends FutureViewModel<List<DocumentSnapshot>> {
  DatabaseService _databaseService = locator<DatabaseService>();

  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  AnimationController animationController;

  @override
  void onData(List data) async {
    for (int index = 0; index < data.length - 3; index++) {
      listKey.currentState
          .insertItem(index, duration: Duration(milliseconds: 500));

      await Future.delayed(
        Duration(milliseconds: 100),
      );
    }
  }

  @override
  Future<List<DocumentSnapshot>> futureToRun() =>
      _databaseService.retrieveRankings();
}
