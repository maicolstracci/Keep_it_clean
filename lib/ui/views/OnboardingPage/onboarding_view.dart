import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/ui/views/OnboardingPage/onboarding_page1.dart';
import 'package:keep_it_clean/ui/views/OnboardingPage/onboarding_page_viewmodel.dart';
import 'package:keep_it_clean/utils/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import 'onboarding_page2.dart';
import 'onboarding_page3.dart';

class OnboardingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnboardingPageViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: SafeArea(
                top: false,
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
                              controller: model.pageController,
                              onPageChanged: (index) {
                                model.changeCurrentPage(index.toDouble());
                              },
                              scrollDirection: Axis.horizontal,
                              physics: ClampingScrollPhysics(),
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
                                  padding: const EdgeInsets.only(
                                      bottom: 24.0, top: 18),
                                  child: SmoothPageIndicator(
                                    controller:
                                        model.pageController, // PageController
                                    count: 3,
                                    effect: ColorTransitionEffect(
                                        spacing: 16.0,
                                        dotWidth: 12.0,
                                        dotHeight: 12.0,
                                        activeDotColor: Colors.green[600]!,
                                        dotColor: Color(
                                            0xfff4f8f9)), // your preferred effect
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ProseguiButton(),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => OnboardingPageViewModel());
  }
}

class ProseguiButton extends HookViewModelWidget<OnboardingPageViewModel> {
  @override
  Widget buildViewModelWidget(
          BuildContext context, OnboardingPageViewModel viewModel) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).accentColor,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        onPressed: () async {
          await Future.delayed(Duration(milliseconds: 200));
          if (viewModel.currentPage == 2.0) {
            await requestPermission();
            AutoRouter.of(context)
                .pushAndPopUntil(MapsPageViewRoute(), predicate: (r) => false);
          } else {
            viewModel.navigateNextPage();
          }
        },
        child: Text(
          viewModel.currentPage != 2.0 ? tr("PROSEGUI") : tr("COMINCIAMO"),
          style:
              TextStyle(color: Theme.of(context).backgroundColor, fontSize: 20),
        ),
      );
}
