import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/Utils/utils.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/ui/views/MapsPage/maps_page_viewmodel.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            height: 50,
            width: 260,
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child: Center(
                child: AutoSizeText(
              tr("Cosa stai cercando?"),
              maxLines: 1,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            )),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 28),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AddBinButton(),
                Expanded(
                  child: ConstrainedBox(
                    key: filterBarKey,
                    constraints: new BoxConstraints(
                      maxHeight: 60.0,
                    ),
                    child: ScrollConfiguration(
                      behavior: FilterListBehavior(),
                      child: ListView.separated(
                        padding: EdgeInsets.all(10),
                        shrinkWrap: false,
                        itemBuilder: (_, index) {
                          return FilterButton(index + 1);
                        },
                        separatorBuilder: (_, index) => Container(
                          width: 5,
                        ),
                        itemCount: typesOfBin.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends HookViewModelWidget<MapsPageViewModel> {
  final int index;

  FilterButton(this.index);

  @override
  Widget buildViewModelWidget(
      BuildContext context, MapsPageViewModel viewModel) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
          border: Border.all(
              color: viewModel.filterBinsForType == typesOfBin[index - 1]
                  ? Theme.of(context).backgroundColor.withOpacity(0.6)
                  : Colors.transparent,
              width: 2),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
            ),
          ]),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          RawMaterialButton(
            padding: EdgeInsets.all(5),
            onPressed: () async {
//              await Future.delayed(Duration(milliseconds: 50));
              viewModel.setFilterBinsForType(typesOfBin[index - 1]);
            },
            fillColor: Colors.white,
            splashColor: Colors.green[400],
            elevation: 0,
            highlightElevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(200.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Image.asset(
                    "assets/icons/icon_type_$index.png",
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      tr(typesOfBin[index - 1]),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: viewModel.filterBinsForType == typesOfBin[index - 1]
                ? true
                : false,
            child: Positioned(
              bottom: -10,
              right: -10,
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(40)),
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class AddBinButton extends HookViewModelWidget<MapsPageViewModel> {
  AddBinButton({Key key}) : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(
      BuildContext context, MapsPageViewModel viewModel) {
    return FlatButton(
      key: addNewBinKey,
      color: Colors.blue[800].withOpacity(.98),
      onPressed: viewModel.isUserLoggedIn()
          ? () => AutoRouter.of(context).push(AddBinPageViewRoute())
          : () => viewModel.showUserNoLoggedInDialog(),
      padding: EdgeInsets.symmetric(vertical: 14),
      shape: CircleBorder(),
      child: Icon(
        Icons.add,
        size: 36,
        color: Colors.white,
      ),
    );
  }
}
