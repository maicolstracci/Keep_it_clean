import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/bloc/startup_bloc.dart';
import 'package:shimmer/shimmer.dart';

class StartUpView extends StatefulWidget {
  @override
  _StartUpViewState createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView>
    with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController controllerContAnimation;
  AnimationController controllerTextOpacity;

  Animation<Offset> offsetAnimation;
  Animation<Offset> offsetContAnimation;
  Animation<double> textOpacityAnimation;

  StartupBloc _bloc;

  void _onFinishInitAnim(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      controllerContAnimation.forward();
      controllerTextOpacity.forward();
    }
  }

  void _onChangeStatusContAnim(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      controllerContAnimation.reverse();
    } else if (status == AnimationStatus.dismissed) {
      controllerContAnimation.forward();
    }
  }

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(milliseconds: 1500), vsync: this)
          ..addStatusListener(_onFinishInitAnim);
    controllerContAnimation =
        AnimationController(duration: Duration(seconds: 1), vsync: this)
          ..addStatusListener(_onChangeStatusContAnim);
    controllerTextOpacity =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    offsetAnimation = Tween<Offset>(
            begin: Offset(0, -10), end: Offset(0, 0.017))
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    offsetContAnimation =
        Tween<Offset>(begin: Offset(0, 0.15), end: Offset(0, -0.15)).animate(
            CurvedAnimation(
                parent: controllerContAnimation, curve: Curves.easeInOut));

    textOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: controllerTextOpacity,
            curve: Curves.fastLinearToSlowEaseIn));

    controller.forward();

    _bloc = BlocProvider.of<StartupBloc>(context, listen: false);

    _startupLogic();
  }

  void _startupLogic() async {
    await _bloc.handleStartUpLogic();

    if (mounted) controllerContAnimation.stop();
    if (mounted) controller.reverse();

    if (mounted)
      controllerTextOpacity.reverse().then(
        (value) async {
          if (await _bloc.hasLoggedInUser) {
            AutoRouter.of(context).replace(MapsPageViewRoute());
          } else {
            AutoRouter.of(context).replace(LoginPageViewRoute());
          }
        },
      );
  }

  @override
  void dispose() {
    controller.removeStatusListener(_onFinishInitAnim);
    controllerContAnimation.removeStatusListener(_onChangeStatusContAnim);
    controllerContAnimation.dispose();
    controllerTextOpacity.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartupBloc, void>(
      builder: (context, state) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: SlideTransition(
                      position: offsetContAnimation,
                      child: SizedBox(
                          width: 150,
                          child: Image.asset(
                              "assets/illustrations/happy-earth.png")),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 36,
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedBuilder(
                    animation: textOpacityAnimation,
                    builder: (_, child) => Opacity(
                      opacity: textOpacityAnimation.value,
                      child: child,
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Theme.of(context).accentColor.withOpacity(.6),
                      period: const Duration(milliseconds: 2000),
                      highlightColor: Theme.of(context).accentColor,
                      child: Text(
                        tr("Caricamento in corso..."),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
