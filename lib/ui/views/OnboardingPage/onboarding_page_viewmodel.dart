import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class OnboardingPageViewModel extends BaseViewModel {
  late double currentPage;
  PageController pageController = PageController(initialPage: 0);

  changeCurrentPage(double page) {
    currentPage = page;
    notifyListeners();
  }

  navigateNextPage() {
    pageController.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    notifyListeners();
  }
}
