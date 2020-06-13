import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/select_bin_position_viewmodel.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';

class SelectBinPositionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectBinPositionViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: Stack(
                children: [
                  Column(
                    children: [
                      Flexible(
                        flex: 5,
                        child: GoogleMap(
                          // Padding only applies to iPhone X to avoid obscuring the Google logo

                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          mapToolbarEnabled: false,
                          markers: model.markers,
                          onCameraMove: (cameraPosition) =>
                              model.onCameraMove(cameraPosition),
                          initialCameraPosition: initialCameraPosition,
                          onMapCreated: (GoogleMapController controller) {
                            model.mapsController = controller;
                            model.moveCameraToUserLocation();
                          },
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            Container(
                              child: FlatButton.icon(
                                  onPressed: !model.uploadingBin ? () {model.moveCameraToUserLocation();} : null,
                                  color: Colors.white.withOpacity(0.3),
                                  icon: Icon(Icons.refresh),
                                  label: Text("Ricalcola posizione")),
                            ),
                            Expanded(
                              child: Container(
                                child: Center(
                                  child: Text(
                                    model.isBusy
                                        ? "Sto ricercando la tua posizione..."
                                        : model.errorLoadingLocation
                                            ? "ERRORE NEL CALCOLARE POSIZIONE"
                                            : "Sembra che questa sia la tua posizione attuale\nTrascina il cursore per modificarla",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: model.currentLatLng != null && !model.uploadingBin
                                  ? () => model.createBin()
                                  : null,
                              color: Colors.blue,
                              disabledColor: Colors.blueGrey,
                              child: Text("Invia"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: model.uploadingBin,
                    child: Center(
                      child: Container(
                        height: 150,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Theme.of(context).backgroundColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 8,left: 8),
                              child: Text(
                                "Stiamo caricando la tua segnalazione online",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            CircularProgressIndicator()
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
        viewModelBuilder: () => SelectBinPositionViewModel());
  }
}
