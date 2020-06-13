import 'package:injectable/injectable.dart';

@lazySingleton
class AddBinTypesListService {
  List<int> _typesSelected = List<int>();
  List<int> get typesSelected => _typesSelected;

  void addOrRemoveTypeToList(int type){
    _typesSelected.contains(type) ? _typesSelected.remove(type) : _typesSelected.add(type);

  }
}