
import 'package:flutter/material.dart';
import 'package:keep_it_clean/models/user_model.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfilePicture extends StatelessWidget {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    User currentUser = _authService.currentUser;
    return Align(
      alignment: Alignment.topLeft,

      child: Padding(

        padding: const EdgeInsets.only(left:8.0,top: 8),
        child: GestureDetector(
          onTap: () {
            _navigationService.navigateTo(Routes.profilePage);
          },
          child: Hero(
            tag: "profilePic",
            child: new Container(
              key: personalProfileKey,
              width: 70,
              height: 70,
              decoration: new BoxDecoration(

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 30.0,
                    ),
                  ]),
              child: CircleAvatar(
                backgroundImage: (currentUser != null && currentUser.profilePic != null)
                    ? NetworkImage(
                    currentUser.profilePic,
                    scale: 1)
                    : ExactAssetImage('assets/no-avatar.jpg'),
                maxRadius: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


