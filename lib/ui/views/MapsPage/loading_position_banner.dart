import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                  tr("Stiamo calcolando la tua posizione"),
                  textAlign: TextAlign.center,
                ),
                LinearProgressIndicator()
              ],
            ),
          ),
        ),
      );
}
