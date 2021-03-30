import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/bloc/bloc_utils.dart';
import 'package:keep_it_clean/bloc/login_bloc.dart';
import 'package:keep_it_clean/bloc/startup_bloc.dart';
import 'package:keep_it_clean/utils/theme.dart';

//TODO: Test Sign in with Apple
//TODO: Check Device preview package

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(EasyLocalization(
      supportedLocales: [Locale('it', 'IT'), Locale('en', 'US')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: KeepItClean()));
}

class KeepItClean extends StatefulWidget {
  @override
  _KeepItCleanState createState() {
    return new _KeepItCleanState();
  }
}

class _KeepItCleanState extends State<KeepItClean> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light));

    final _appRouter = AppRouter();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => LoginBloc(
            BlocState(state: BlocStateEnum.INITIAL),
          ),
        ),
        BlocProvider(
          create: (BuildContext context) => StartupBloc(null),
        )
      ],
      child: MaterialApp.router(
        routerDelegate: _appRouter.delegate(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Keep it clean',
        debugShowCheckedModeBanner: false,
        theme: KeepItCleanTheme().theme,
        routeInformationParser: _appRouter.defaultRouteParser(),
      ),
    );
  }
}
