import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/ui/views/MapsPage/maps_page_viewmodel.dart';
import 'package:keep_it_clean/ui/views/MapsPage/profile_picture.dart';
import 'package:keep_it_clean/ui/views/MapsPage/search_here_button.dart';
import 'package:keep_it_clean/ui/views/MapsPage/search_widget.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';

import 'TutorialOverlay/tutorial_overlay.dart';
import 'loading_position_banner.dart';
import 'move_to_user_position.dart';

class MapsPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => showTutorial(context));
    return ViewModelBuilder<MapsPageViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: SafeArea(
                bottom: false,
                top: false,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      GoogleMap(
                        // Padding only applies to iPhone X to avoid obscuring the Google logo
                        padding: EdgeInsets.only(left: 10),
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        mapToolbarEnabled: false,
                        zoomControlsEnabled: false,
                        onCameraMove: (cameraPosition) {
                          model.setCameraPosition(cameraPosition);
                        },
                        markers: model.getMarkersSetWithFiltering(),
                        initialCameraPosition: initialCameraPosition,
                        onMapCreated: (GoogleMapController controller) {
                          model.mapsController = controller;
                          model.moveCameraToUserLocation();
                        },
                      ),
                      SafeArea(
                        child: Stack(
                          children: [
                            LoadingPositionBanner(),
                            MoveToUserPosition(),
                            ProfilePicture(),
                            FilterBar(),
                            SearchHereButton()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => MapsPageViewModel());
  }
}
