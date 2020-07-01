import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/reporter_profile_page_view.dart';
import 'package:stacked/stacked.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:stacked_services/stacked_services.dart';

class ClassificaPageViewModel extends FutureViewModel<List<DocumentSnapshot>>{

  DatabaseService _databaseService = locator<DatabaseService>();
  NavigationService _navigationService =locator<NavigationService>();

  navigateToUserPage(String userID){

    _navigationService.navigateWithTransition(ReporterProfileView(reporterUid: userID,),
        transition: NavigationTransition.RightToLeft);
  }

  @override
  Future<List<DocumentSnapshot>> futureToRun() => _databaseService.retrieveRankings();



}