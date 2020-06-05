import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:keep_it_clean/ui/views/MapsPage/maps_page_viewmodel.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class LoadingPositionBanner extends HookViewModelWidget<MapsPageViewModel> {
  @override
  Widget buildViewModelWidget(
          BuildContext context, MapsPageViewModel viewModel) =>
      Visibility(
        visible: viewModel.isBusy,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            height: 180,
            width: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  AppTranslations.of(context).text("loading_position_string"),
                  textAlign: TextAlign.center,
                ),
                LinearProgressIndicator()
              ],
            ),
          ),
        ),
      );
}
