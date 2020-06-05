import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'file:///C:/Users/Maicol/AndroidStudioProjects/keep_it_clean/lib/services/database_services.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:url_launcher/url_launcher.dart';

SimpleDialog createDialog(BuildContext context, String documentID, String img,
    LatLng pos, int type, String username, String date, FirebaseUser user) {
  String _name = AppTranslations.of(context).text("icon_string_$type");

  return SimpleDialog(
    titlePadding: EdgeInsets.only(left: 10, right: 5),
    backgroundColor: Colors.white,
    title: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                _name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 24),
              ),
            ),

            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return createAlertDialog(context, documentID, user);
                    });
              },
              icon: Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
            )
          ],
        ),
      ],
    ),
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 300,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: img != null
                ? FadeInImage.assetNetwork(
                    placeholder: 'assets/loading.gif',
                    image: img,
                    fit: BoxFit.fitWidth,
                  )
                : Image.asset('assets/default-bin-photo.png', fit: BoxFit.fitWidth),
          ),
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: Theme.of(context).textTheme.body1,
                text: AppTranslations.of(context).text("reported_by"),
                children: <TextSpan>[
                  TextSpan(
                      text: username + '\n',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: AppTranslations.of(context).text("date_string"),
                      style: Theme.of(context).textTheme.body1),
                  TextSpan(
                      text: date.substring(0, 10),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Center(
        child: FlatButton(
          padding: const EdgeInsets.all(10),
          onPressed: () {
            _launchMapsUrl(pos.latitude, pos.longitude);
          },
          color: Colors.green[400],
          textColor: Colors.white,
          child: Text(
            AppTranslations.of(context).text("take_me_there_string"),
            style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,
                fontSize: 22),
          ),
        ),
      )
    ],
  );
}

AlertDialog createAlertDialog(BuildContext context, String documentId, FirebaseUser user) {
  if(user == null){
    return AlertDialog(
      elevation: 20,
         title: new Text(
           "Solo gli utenti autenticati possono segnalare problemi",
         ),
      actions: <Widget>[FlatButton(
        child: new Text("Ho capito"),
        textColor: Colors.black,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),],
    );
  } else return AlertDialog(
    elevation: 20,
    title: new Text(
      AppTranslations.of(context).text("report_bin_string"),
    ),
    actions: <Widget>[
      FlatButton(
        child: new Text(AppTranslations.of(context).text("no")),
        textColor: Colors.black,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      FlatButton(
        child: new Text(AppTranslations.of(context).text("yes")),
        color: Colors.red,
        textColor: Colors.black,
        onPressed: () {
          DatabaseService().reportBinProblem(documentId, user);
          Navigator.of(context).pop();
        },
      ),
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
