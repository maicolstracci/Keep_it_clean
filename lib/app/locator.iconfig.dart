// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:keep_it_clean/services/add_bin_types_list_service.dart';
import 'package:keep_it_clean/services/auth_service.dart';
import 'package:keep_it_clean/services/bin_details_service.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:keep_it_clean/services/third_party_services_module.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:keep_it_clean/services/location_service.dart';
import 'package:keep_it_clean/services/search_here_button_service.dart';
import 'package:keep_it_clean/services/take_picture_service.dart';
import 'package:keep_it_clean/services/type_of_report_service.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  g.registerLazySingleton<AddBinTypesListService>(
      () => AddBinTypesListService());
  g.registerLazySingleton<AuthService>(() => AuthService());
  g.registerLazySingleton<BinDetailsService>(() => BinDetailsService());
  g.registerLazySingleton<DatabaseService>(() => DatabaseService());
  g.registerLazySingleton<DialogService>(
      () => thirdPartyServicesModule.dialogService);
  g.registerLazySingleton<LocationService>(() => LocationService());
  g.registerLazySingleton<NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  g.registerLazySingleton<SearchHereButtonService>(
      () => SearchHereButtonService());
  g.registerLazySingleton<TakePictureService>(() => TakePictureService());
  g.registerLazySingleton<TypeOfReportService>(() => TypeOfReportService());
}

class _$ThirdPartyServicesModule extends ThirdPartyServicesModule {
  @override
  DialogService get dialogService => DialogService();
  @override
  NavigationService get navigationService => NavigationService();
}
