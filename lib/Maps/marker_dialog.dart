import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:url_launcher/url_launcher.dart';

SimpleDialog createDialog(BuildContext context, String img, LatLng pos, int type) {
  String name;
  switch (type) {
    case 1:
      name = AppTranslations.of(context).text("plastic_string");
      break;
    case 2:
      name = AppTranslations.of(context).text("glass_string");
      break;
    case 3:
      name = AppTranslations.of(context).text("paper_string");
      break;
    case 4:
      name = AppTranslations.of(context).text("other_string");
  }



  return SimpleDialog(
    backgroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.w600, fontSize: 24),
        ),
        Column(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
            ),Text(
              "SEGNALA",
              textAlign: TextAlign.center,
              style: TextStyle(color:Colors.red,fontFamily: "Montserrat", fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ],
        )
      ],
    ),
    children: <Widget>[

      Padding(
        padding: const EdgeInsets.only(bottom:20.0, left: 20, right: 20),
        child: Container(
          height: 300,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: img != null ? FadeInImage.assetNetwork(placeholder: 'assets/loading.gif', image: img, fit: BoxFit.fitWidth, ) : Image.asset('assets/trees.png',fit: BoxFit.fitWidth),
        ),
      ),
      Center(
        child: FlatButton(

          padding: const EdgeInsets.all(10) ,
          onPressed: () {
            _launchMapsUrl(pos.latitude, pos.longitude);
          },
          color: Colors.green[400],
          textColor: Colors.white,
          child: Text(
            AppTranslations.of(context).text("take_me_there_string"),
            style: TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.w600, fontSize: 22),
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