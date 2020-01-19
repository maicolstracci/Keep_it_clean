import 'package:flutter/material.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';



void showSnackBar(BuildContext context, int variant, var scaffoldKey) {
  String s;
  switch (variant) {
    case 1:
      s = "you_are_guest_profile_string";
      break;
    case 2:
      s = "you_are_guest_add_string";
      break;
    case 3:
      s = "location_requested_string";
      break;
  }

  final snackBar = SnackBar(
    content: Text(AppTranslations.of(context).text(s)),
    action: (variant == 1 || variant == 2)
        ? SnackBarAction(
            label: "LOGIN",
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        : SnackBarAction(
            label: AppTranslations.of(context).text("settings_string"),
            onPressed: () {
              PermissionHandler().openAppSettings();
            },
          ),
    behavior: SnackBarBehavior.fixed,
  );
  scaffoldKey.currentState.showSnackBar(snackBar);
}
