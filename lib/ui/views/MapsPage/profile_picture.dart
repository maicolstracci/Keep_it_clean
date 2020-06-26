
import 'package:flutter/material.dart';
import 'package:keep_it_clean/models/user_model.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/services/auth_service.dart';
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
        padding: const EdgeInsets.only(left:8.0),
        child: GestureDetector(
          onTap: () {
            _navigationService.navigateTo(Routes.profilePage);
          },
          child: Hero(
            tag: "profilePic",
            child: new Container(
              width: 60,
              height: 60,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                    ),
                  ]),
              child: CircleAvatar(
                backgroundImage: (currentUser != null)
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


