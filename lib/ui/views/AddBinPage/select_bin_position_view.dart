import 'package:easy_localization/easy_localization.dart';
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
              body: SafeArea(
                top: false,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Flexible(
                          flex: 5,
                          child: GoogleMap(
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
                                    onPressed: !model.uploading ? () {model.moveCameraToUserLocation();} : null,
                                    color: Colors.white.withOpacity(0.3),
                                    icon: Icon(Icons.refresh),
                                    label: Text(tr("Ricalcola posizione"))),
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      model.isBusy
                                          ? tr("Sto ricercando la tua posizione")
                                          : model.errorLoadingLocation
                                              ? tr("ERRORE NEL CALCOLARE POSIZIONE")
                                              : tr("Sembra che questa sia la tua posizione attuale\nTrascina il cursore per modificarla"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              MaterialButton(
                                onPressed: model.currentLatLng != null && !model.uploading
                                    ? () => model.uploadReport()
                                    : null,
                                color: Colors.blue,
                                disabledColor: Colors.blueGrey,
                                child: Text(tr("Invia")),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: model.uploading,
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
                                  tr("Stiamo caricando la tua segnalazione online"),
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
            ),
        viewModelBuilder: () => SelectBinPositionViewModel());
  }
}
