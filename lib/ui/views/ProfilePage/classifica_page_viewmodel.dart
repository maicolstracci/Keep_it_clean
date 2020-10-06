import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/reporter_profile_page_view.dart';
import 'package:path/path.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ClassificaPageViewModel extends FutureViewModel<List<DocumentSnapshot>> {
  DatabaseService _databaseService = locator<DatabaseService>();
  NavigationService _navigationService = locator<NavigationService>();

  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void onData(List data) async {
    for (int index = 0; index < data.length; index++) {

      listKey.currentState.insertItem(index, duration: Duration(milliseconds: 400));

      await Future.delayed(
        Duration(milliseconds: 100),
      );
    }
  }

  navigateToUserPage(String userID) {
    _navigationService.navigateWithTransition(
        ReporterProfileView(
          reporterUid: userID,
        ),
        transition: NavigationTransition.RightToLeft);
  }

  @override
  Future<List<DocumentSnapshot>> futureToRun() =>
      _databaseService.retrieveRankings();
}
