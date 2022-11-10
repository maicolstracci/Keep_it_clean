import 'package:injectable/injectable.dart';
import 'package:keep_it_clean/utils/constants.dart';

@lazySingleton
class TypeOfReportService {
  late Report _typeOfReport;

  Report get typeOfReport => _typeOfReport;

  setTypeOfReport({required Report type}) {
    _typeOfReport = type;
  }
}
