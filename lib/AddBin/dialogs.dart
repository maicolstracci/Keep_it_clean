
import 'package:flutter/material.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';

AlertDialog showNoImageDialog(BuildContext context){
  return AlertDialog(
    elevation: 20,
    title: new Text(
      AppTranslations.of(context).text("error_string"),
    ),
    content: new Text(
      AppTranslations.of(context).text("no_image_string"),
    ),
  );

}

AlertDialog showNoSelectedTypeDialog(BuildContext context){
  return AlertDialog(
    elevation: 20,
    title: new Text(
      AppTranslations.of(context).text("error_string"),
    ),
    content: new Text(
      AppTranslations.of(context).text("no_type_string"),
    ),
  );
}