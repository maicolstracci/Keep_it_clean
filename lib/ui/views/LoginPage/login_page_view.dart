import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/ui/views/LoginPage/login_button.dart';
import 'package:keep_it_clean/ui/views/LoginPage/login_page_viewmodel.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';

class LoginPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginPageViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: Color(0xff06442d),
              resizeToAvoidBottomInset: true,
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
                                      child: Hero(
                                        tag: HeroTag.KEEP_IT_CLEAN_LOGO_LOADER,
                                        child: Image.asset(
                                          "assets/keep_it_clean_only_logo.png",
                                        ),
                                      )),
                                  Text(
                                    "Keep it clean",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600),
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32.0),
                                    child: Text(
                                      tr("login_desc_string"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  LoginButton(
                                    buttonType: LoginButtonType.FACEBOOK,
                                  ),
                                  LoginButton(
                                    buttonType: LoginButtonType.GOOGLE,
                                  ),
                                  if (model.appleSignInAvailable)
                                    SizedBox(
                                      width: 240,
                                      height: 60,
                                      child: AppleSignInButton(
                                          cornerRadius: 20,
                                          onPressed: () async =>
                                              model.performLogin(context,
                                                  LoginButtonType.APPLE)),
                                    ),
                                  LoginButton(
                                    buttonType: LoginButtonType.GUEST,
                                  ),
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
