import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_it_clean/bloc/bloc_utils.dart';
import 'package:keep_it_clean/bloc/login_bloc.dart';
import 'package:keep_it_clean/ui/views/LoginPage/login_button.dart';

class LoginPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, BlocState>(
      builder: (context, data) => Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
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
                              child: Image.asset(
                                "assets/keep_it_clean_only_logo.png",
                              ),
                            ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32.0),
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
                            if (context.watch<LoginBloc>().appleSignInAvailable)
                              SizedBox(
                                width: 240,
                                height: 60,
                                child: AppleSignInButton(
                                    cornerRadius: 20,
                                    onPressed: () async => context
                                        .read<LoginBloc>()
                                        .performLogin(
                                            context, LoginButtonType.APPLE)),
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
    );
  }
}
