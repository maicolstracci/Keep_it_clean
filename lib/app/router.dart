
import 'package:auto_route/auto_route_annotations.dart';
import 'package:keep_it_clean/ui/views/LoginPage/login_page_view.dart';
import 'package:keep_it_clean/ui/views/OnboardingPage/onboarding_view.dart';


@MaterialAutoRouter()
class $Router{
@initial
  LoginPageView loginPage;
  OnboardingView onboardingPage;
}