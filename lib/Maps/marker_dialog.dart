import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

SimpleDialog createDialog(String img, LatLng pos) {
  return SimpleDialog(
    title: const Text(
      'Test',
      textAlign: TextAlign.center,
    ),
    children: <Widget>[

      Padding(
        padding: const EdgeInsets.only(bottom:20.0, left: 20, right: 20),
        child: Container(
          height: 300,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: img != null ? FadeInImage.assetNetwork(placeholder: 'assets/loading.gif', image: img ) : Image.asset('assets/default-avatar.png'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 60, right: 60),
        child: FlatButton(
          onPressed: () {
            _launchMapsUrl(pos.latitude, pos.longitude);
          },
          color: Colors.greenAccent,
          textColor: Colors.white,
          child: Text(
            "Portamici!",
          ),
        ),
      )
    ],
  );
}


void _launchMapsUrl(double lat, double lon) async {
  final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}