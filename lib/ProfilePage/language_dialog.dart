import 'package:flutter/material.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';


SimpleDialog languageDialog(BuildContext context) {
  return SimpleDialog(
    title: Text(AppTranslations.of(context).text("select_language"),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: "Montserrat",
        )),
    children: <Widget>[
      Image.asset(
        "assets/united-kingdom.png",
        height: 60,
      ),
      Text("English",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            fontFamily: "Montserrat",
          )),
      Image.asset(
        "assets/italy.png",
        height: 60,
      ),
      Text("Italiano",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            fontFamily: "Montserrat",
          )),
      Image.asset(
        "assets/germany.png",
        height: 60,
      ),
      Text("Deutsch",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            fontFamily: "Montserrat",
          )),
    ],
  );
}
