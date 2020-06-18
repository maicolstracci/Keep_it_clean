import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:stacked/stacked.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:stacked_services/stacked_services.dart';

class ClassificaPageViewModel extends FutureViewModel<List<DocumentSnapshot>>{

  DatabaseService _databaseService = locator<DatabaseService>();
  NavigationService _navigationService =locator<NavigationService>();

  navigateToUserPage(String userID){

    _navigationService.navigateTo(Routes.reporterProfilePage,arguments: ReporterProfileViewArguments(reporterUid: userID));
  }

  @override
  Future<List<DocumentSnapshot>> futureToRun() => _databaseService.retrieveRankings();



}