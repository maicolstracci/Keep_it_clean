import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/models/user_model.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ReporterProfilePageViewModel extends FutureViewModel<User> {
  DatabaseService _databaseService = locator<DatabaseService>();

  String reporterUid;

  int getNumberOfReportsForType(int index) {
    Map<String, int> map = data.reports;
    if (map == null) return 0;

    return map[typesOfBin[index]] ?? 0;
  }

  @override
  Future<User> futureToRun() {
    if (reporterUid != null) return _databaseService.retrieveUserInfo(reporterUid: reporterUid);
  }
}
