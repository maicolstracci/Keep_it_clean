import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/search_here_button_service.dart';
import 'package:keep_it_clean/ui/views/MapsPage/maps_page_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class SearchHereButton extends HookViewModelWidget<MapsPageViewModel> {
  SearchHereButton({Key key}) : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(
      BuildContext context, MapsPageViewModel viewModel) {
    return ViewModelBuilder<SearchHereButtonViewModel>.reactive(
        builder: (context, model, child) => Align(
              alignment: Alignment.topCenter,
              child: TweenAnimationBuilder(
                tween:
                    Tween<double>(begin: 0, end: model.visibility ? 0 : -200),
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 1000),
                builder: (BuildContext context, double value, Widget child) {
                  return Transform.translate(
                    offset: Offset(0, value),
                    child: AnimatedOpacity(
                      opacity: model.visibility ? 1 : 0,
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).accentColor,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => viewModel.searchHereButtonAction(),
                        child: Text(tr("Cerca qui")),
                      ),
                    ),
                  );
                },
              ),
            ),
        viewModelBuilder: () => SearchHereButtonViewModel());
  }
}

class SearchHereButtonViewModel extends ReactiveViewModel {
  SearchHereButtonService _searchButtonService =
      locator<SearchHereButtonService>();

  bool get visibility => _searchButtonService.visibility;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_searchButtonService];
}
