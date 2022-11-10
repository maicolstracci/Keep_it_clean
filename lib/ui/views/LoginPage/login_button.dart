import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_it_clean/bloc/login_bloc.dart';

enum LoginButtonType {
  GOOGLE,
  APPLE,
  GUEST,
}

class LoginButton extends StatelessWidget {
  final LoginButtonType buttonType;
  final IconData icon;
  final Color color;

  LoginButton.facebook({this.icon, this.color, this.buttonType});

  LoginButton.google({this.icon, this.color, this.buttonType});

  LoginButton.guest({this.icon, this.color, this.buttonType});

  factory LoginButton({LoginButtonType buttonType}) {
    switch (buttonType) {
      case LoginButtonType.FACEBOOK:
        return LoginButton.facebook(
          icon: IconData(0xe901, fontFamily: "CustomIcons"),
          color: Colors.lightBlue,
          buttonType: LoginButtonType.FACEBOOK,
        );

      case LoginButtonType.GOOGLE:
        return LoginButton.facebook(
          icon: IconData(0xe902, fontFamily: "CustomIcons"),
          color: Colors.red,
          buttonType: LoginButtonType.GOOGLE,
        );
      case LoginButtonType.GUEST:
        return LoginButton.guest(
          icon: Icons.arrow_forward,
          color: Colors.green,
          buttonType: LoginButtonType.GUEST,
        );
      case LoginButtonType.APPLE:
      default:
        return LoginButton.guest(
          icon: Icons.arrow_forward,
          color: Colors.green,
          buttonType: LoginButtonType.GUEST,
        );
    }
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

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () =>
          BlocProvider.of<LoginBloc>(context).performLogin(context, buttonType),
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
            icon,
            color: color,
          ),
          SizedBox(
            width: 28,
          ),
          Text(
            tr("${fromEnumToString(buttonType)}_login_string"),
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
