

import 'package:auto_route/auto_route_annotations.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/add_bin_page_view.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/picture_selection_view.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/select_bin_position_view.dart';
import 'package:keep_it_clean/ui/views/BinDetailsPage/bin_details_view.dart';
import 'package:keep_it_clean/ui/views/IllegalWasteDisposalPage/illegal_waste_details_view.dart';
import 'package:keep_it_clean/ui/views/IllegalWasteDisposalPage/illegal_waste_disposal_view.dart';
import 'package:keep_it_clean/ui/views/LoginPage/login_page_view.dart';
import 'package:keep_it_clean/ui/views/MapsPage/maps_page_view.dart';
import 'package:keep_it_clean/ui/views/OnboardingPage/onboarding_view.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/profile_page_view.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/reporter_profile_page_view.dart';

@MaterialAutoRouter()
class $Router{
  @initial
  LoginPageView loginPage;
  OnboardingView onboardingPage;
  MapsPageView mapsPage;
  ProfilePageView profilePage;
  BinDetailsPageView binDetailsPage;
  AddBinPageView addBinPage;
  PictureSelectionView pictureSelectionPage;
  SelectBinPositionView selectBinPositionPage;
  ReporterProfileView reporterProfilePage;
  IllegalWasteDisposalView illegalWasteDisposalPage;
  IllegalWasteDetailsView illegalWasteDetailsPage;
}