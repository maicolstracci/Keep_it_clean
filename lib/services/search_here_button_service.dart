import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class SearchHereButtonService with ReactiveServiceMixin {
  RxValue<bool> _visibility = RxValue<bool>(true);

  SearchHereButtonService() {
    listenToReactiveValues([_visibility]);
  }

  bool get visibility => _visibility.value;

  void setVisibility(bool v) {
    _visibility.value = v;
  }
}
