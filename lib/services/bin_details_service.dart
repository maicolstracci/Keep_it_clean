import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class BinDetailsService{
  String _binID;
  String get binID => _binID;


  void setBinID(String id){
    _binID = id;
  }


}
