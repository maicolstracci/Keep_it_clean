import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/ui/views/LoginPage/login_page_viewmodel.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

enum LoginButtonType {
  FACEBOOK,
  GOOGLE,
  APPLE,
  GUEST,
}

class LoginButton extends HookViewModelWidget<LoginPageViewModel> {
  final LoginButtonType buttonType;

  LoginButton({Key key, this.buttonType}) : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(
    BuildContext context,
    LoginPageViewModel model,
  ) {
    IconData _icon;
    MaterialColor _color;
    switch (buttonType) {
      case LoginButtonType.FACEBOOK:
        _icon = const IconData(0xe901, fontFamily: "CustomIcons");
        _color = Colors.lightBlue;

        break;
      case LoginButtonType.GOOGLE:
        _icon = const IconData(0xe902, fontFamily: "CustomIcons");
        _color = Colors.red;
        break;
      case LoginButtonType.GUEST:
        _icon = Icons.arrow_forward;
        _color = Colors.green;
        break;
      case LoginButtonType.APPLE:
        break;
    }

    String fromEnumToString(LoginButtonType buttonType) {
      switch (buttonType) {
        case LoginButtonType.FACEBOOK:
          return "facebook";
        case LoginButtonType.GOOGLE:
          return "google";
        case LoginButtonType.GUEST:
          return "guest";
        case LoginButtonType.APPLE:
        default:
          return "";
      }
    }

    return MaterialButton(
      onPressed: () => model.performLogin(context, buttonType),
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
          Icon(
            _icon,
            color: _color,
          ),
          SizedBox(
            width: 28,
          ),
          Text(
            tr("${fromEnumToString(buttonType)}_login_string"),
            style: TextStyle(color: _color),
          ),
        ],
      ),
    );
  }
}
