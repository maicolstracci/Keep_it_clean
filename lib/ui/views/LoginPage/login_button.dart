import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/ui/views/LoginPage/login_page_viewmodel.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class LoginButton extends HookViewModelWidget<LoginPageViewModel> {
  final String buttonTypeName;
  IconData _icon;
  MaterialColor _color;

  LoginButton({Key key, this.buttonTypeName})
      : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(
    BuildContext context,
    LoginPageViewModel model,
  ) {


    switch (buttonTypeName) {
      case 'facebook':
        _icon = const IconData(0xe901, fontFamily: "CustomIcons");
        _color = Colors.lightBlue;
        break;
      case 'google':
        _icon = const IconData(0xe902, fontFamily: "CustomIcons");
        _color = Colors.red;
        break;
      case 'guest':
        _icon = Icons.arrow_forward;
        _color = Colors.green;
        break;
    }

    return MaterialButton(
      onPressed: () {
        switch (buttonTypeName) {
          case 'facebook':
            model.facebookLogin();
            break;
          case 'google':
            model.googleLogin();
            break;
          case 'guest':
            model.guestLogin();
            break;
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 5,
      color: Theme.of(context).accentColor,
      minWidth: 240,
      height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(_icon,color: _color,),
          SizedBox(
            width: 28,
          ),
          Text(tr("${buttonTypeName}_login_string"),style: TextStyle(color: _color),),
        ],
      ),
    );
  }
}
