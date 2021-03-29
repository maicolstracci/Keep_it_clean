import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/ui/views/MapsPage/maps_page_viewmodel.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class MoveToUserPosition extends HookViewModelWidget<MapsPageViewModel> {
  @override
  Widget buildViewModelWidget(
          BuildContext context, MapsPageViewModel viewModel) =>
      Align(
        alignment: Alignment.topRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 5),
              ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
              margin: EdgeInsets.only(top: 8, right: 8),
              child: IconButton(
                key: moveToUserLocationKey,
                onPressed: viewModel.moveCameraToUserLocation,
                icon: Icon(
                  Icons.my_location,
                  color: Colors.black54,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
              margin: EdgeInsets.only(top: 8, right: 8),
              child: IconButton(
                key: reportIllegalWasteDisposalKey,
                onPressed: viewModel.isUserLoggedIn()
                    ? () => AutoRouter.of(context)
                        .push(IllegalWasteDisposalViewRoute())
                    : () => viewModel.showUserNoLoggedInDialog(),
                icon: Icon(
                  Icons.warning,
                  color: Colors.red.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
      );
}
