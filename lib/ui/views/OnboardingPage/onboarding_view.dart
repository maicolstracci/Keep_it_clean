import 'package:flutter/material.dart';
import 'package:keep_it_clean/Utils/utils.dart';
import 'package:keep_it_clean/ui/views/OnboardingPage/onboarding_page1.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'onboarding_page2.dart';
import 'onboarding_page3.dart';

class OnboardingView extends StatelessWidget {
  final _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4f8f9),
      body: SafeArea(
        bottom: false,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              ScrollConfiguration(
                behavior: FilterListBehavior(),
                child: PageView(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  physics: PageScrollPhysics(),
                  children: <Widget>[OnboardingPage1(), OnboardingPage2(), OnboardingPage3()],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SmoothPageIndicator(
                      controller: _controller, // PageController
                      count: 3,
                      effect: ColorTransitionEffect(
                          spacing: 16.0,
                          dotWidth: 12.0,
                          dotHeight: 12.0,
                          activeDotColor: Colors.green[600],
                          dotColor: Color(0xfff4f8f9)), // your preferred effect
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
