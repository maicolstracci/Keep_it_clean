import 'dart:math';

import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/models/bin_model.dart';
import 'package:keep_it_clean/services/bin_details_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class BinDetailsPageViewModel extends FutureViewModel<Bin>{

  DatabaseService _databaseService = locator<DatabaseService>();
  BinDetailsService _binDetailsService = locator<BinDetailsService>();
  NavigationService _navigationService = locator<NavigationService>();

  String imageUrl;



  @override
  void onData(Bin data) async {
    super.onData(data);
    imageUrl = await _databaseService.getDownloadUrlImageFromName(data.photoUrl);
    notifyListeners();

  }



  launchMaps() async{

    final url = 'https://www.google.com/maps/search/?api=1&query=${data.position.latitude},${data.position.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

  }

  @override
  Future<Bin> futureToRun() => _databaseService.getBinInfo(_binDetailsService.binID);

  navigateToReporterProfile() {
    print(data.uidUser);
    _navigationService.navigateTo(Routes.reporterProfilePage,arguments: ReporterProfileViewArguments(reporterUid: data.uidUser));
  }

}