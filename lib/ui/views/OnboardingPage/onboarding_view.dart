import 'package:flutter/material.dart';
import 'package:keep_it_clean/Utils/utils.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/ui/views/OnboardingPage/onboarding_page1.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked_services/stacked_services.dart';

import 'onboarding_page2.dart';
import 'onboarding_page3.dart';

class OnboardingView extends StatelessWidget {
  final _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Color(0xfff4f8f9),
                  child: ScrollConfiguration(
                    behavior: FilterListBehavior(),
                    child: PageView(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      physics: PageScrollPhysics(),
                      children: <Widget>[
                        OnboardingPage1(),
                        OnboardingPage2(),
                        OnboardingPage3()
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: SmoothPageIndicator(
                            controller: _controller, // PageController
                            count: 3,
                            effect: ColorTransitionEffect(
                                spacing: 16.0,
                                dotWidth: 12.0,
                                dotHeight: 12.0,
                                activeDotColor: Colors.green[600],
                                dotColor:
                                    Color(0xfff4f8f9)), // your preferred effect
                          )),
                      ProseguiButton(_controller)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProseguiButton extends StatefulWidget {
  final PageController pageController;

  ProseguiButton(this.pageController);

  @override
  _ProseguiButtonState createState() => _ProseguiButtonState();
}

class _ProseguiButtonState extends State<ProseguiButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      splashColor: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      onPressed: () async {
        await Future.delayed(Duration(milliseconds: 200));
        if (widget.pageController.page == 2.0) {
          locator<NavigationService>().replaceWith(Routes.mapsPage);
        } else {
          setState(() {
            widget.pageController.nextPage(
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          });
        }
      },
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
      child: Text(
        widget.pageController.page != 1.0 ? "PROSEGUI" : "COMINCIAMO!",
        style:
            TextStyle(color: Theme.of(context).backgroundColor, fontSize: 20),
      ),
    );
  }
}
