import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class BinDetailsService{
  String _binID;
  String get binID => _binID;

  String _reportID;
  String get reportID => _reportID;

  void setBinID(String id){
    _binID = id;
  }

  void setReportID(String id){
    _reportID = id;
  }


}
