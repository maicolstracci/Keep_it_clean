import 'package:blobs/blobs.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:keep_it_clean/ui/views/LoginPage/login_button.dart';
import 'package:keep_it_clean/ui/views/LoginPage/login_page_viewmodel.dart';
import 'package:stacked/stacked.dart';

class LoginPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              resizeToAvoidBottomPadding: false,
              body: SafeArea(
                bottom: false,
                child: Builder(builder: (context) {
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                        "assets/keep_it_clean_only_logo.png",
                                      )),
                                  Text(
                                    "Keep it clean",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 28),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 7,
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    AppTranslations.of(context)
                                        .text("login_desc_string"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).accentColor),
                                  ),
                                  LoginButton(
                                    buttonTypeName: "facebook",
                                  ),
                                  LoginButton(buttonTypeName: "google"),
                                  LoginButton(buttonTypeName: "guest"),
                                ],
                              ),
                            ),
                          )
                        ],
                      ));
                }),
              ),
            ),
        viewModelBuilder: () => LoginPageViewModel());
  }
}

//
//class oldLoginPageView extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return ViewModelBuilder.reactive(
//        builder: (context, model, child) => Scaffold(
//              resizeToAvoidBottomPadding: false,
//              body: SafeArea(
//                bottom: false,
//                child: Builder(builder: (context) {
//                  return SizedBox(
//                    width: MediaQuery.of(context).size.width,
//                    height: MediaQuery.of(context).size.height,
//                    child: Stack(
//                      children: <Widget>[
//                        FlareActor(
//                          'assets/login_splash.flr',
//                          fit: BoxFit.cover,
//                          animation: 'idle',
//                        ),
//                        Column(
//                          children: <Widget>[
//                            Expanded(
//                              flex: 1,
//                              child: Container(
//                                width: MediaQuery.of(context).size.width,
//                                child: Stack(
//                                  overflow: Overflow.visible,
//                                  children: <Widget>[
//                                    Positioned(
//                                      top: 10,
//                                      right: 10,
//                                      child: Text(
//                                        "Keep it",
//                                        style: TextStyle(
//                                          fontSize: 38,
//                                          fontFamily: "Montserrat",
//                                          fontWeight: FontWeight.w600,
//                                          color: Colors.white,
//                                        ),
//                                      ),
//                                    ),
//                                    Positioned(
//                                      top: 45,
//                                      right: 10,
//                                      child: Text(
//                                        "clean",
//                                        style: TextStyle(
//                                          fontSize: 38,
//                                          fontFamily: "Montserrat",
//                                          fontWeight: FontWeight.w600,
//                                          color: Colors.white54,
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            ),
//                            Expanded(
//                              flex: 3,
//                              child: Padding(
//                                padding: const EdgeInsets.only(left: 30.0),
//                                child: Column(
//                                  mainAxisAlignment: MainAxisAlignment.end,
//                                  crossAxisAlignment:
//                                      CrossAxisAlignment.stretch,
//                                  children: <Widget>[
//                                    Text(
//                                      "LOGIN",
//                                      style: TextStyle(
//                                        fontSize: 42,
//                                        fontFamily: "Montserrat",
//                                        fontWeight: FontWeight.w600,
//                                        color: Colors.white,
//                                        letterSpacing: 2,
//                                      ),
//                                    ),
//                                    Text(
//                                      AppTranslations.of(context)
//                                          .text("login_desc_string"),
//                                      style: TextStyle(
//                                        fontSize: 18,
//                                        fontFamily: "Montserrat",
//                                        fontWeight: FontWeight.w600,
//                                        color: Colors.white70,
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            ),
//                            Expanded(
//                              flex: 5,
//                              child: Container(
//                                margin: EdgeInsets.all(16),
//                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(16),
//                                  color: Colors.white.withOpacity(0.6),
//
//                                ),
//                                width: double.infinity,
//                                child: Column(
//                                  mainAxisAlignment:
//                                      MainAxisAlignment.spaceEvenly,
//                                  children: <Widget>[
//                                    LoginButton(buttonTypeName: "facebook"),
//                                    LoginButton(buttonTypeName: "google"),
//                                    LoginButton(buttonTypeName: "guest"),
//                                  ],
//                                ),
//                              ),
//                            )
//                          ],
//                        ),
//                      ],
//                    ),
//                  );
//                }),
//              ),
//            ),
//        viewModelBuilder: () => LoginPageViewModel());
//  }
//}
