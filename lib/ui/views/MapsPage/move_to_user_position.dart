import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/ui/views/MapsPage/maps_page_viewmodel.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class MoveToUserPosition extends HookViewModelWidget<MapsPageViewModel> {
  @override
  Widget buildViewModelWidget(
      BuildContext context, MapsPageViewModel viewModel) =>
      Align(
        alignment: Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 40),
          ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
          margin: EdgeInsets.only(top: 8, right: 8),
          child: IconButton(
            onPressed: viewModel.moveCameraToUserLocation,
            icon: Icon(
              Icons.my_location,
              color: Colors.black54,
            ),
          ),
        ),
      );
}
