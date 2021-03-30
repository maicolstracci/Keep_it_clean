import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:keep_it_clean/bloc/bloc_utils.dart';
import 'package:keep_it_clean/models/user_model.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/profile_bin_report_container.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/profile_page_viewmodel.dart';
import 'package:keep_it_clean/utils/constants.dart';

import 'classifica_page_view.dart';

class ProfilePageView extends StatefulWidget {
  @override
  _ProfilePageViewState createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  ProfilePageBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ProfilePageBloc>(context, listen: false);
    _bloc.initProfilePageBloc();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePageBloc, BlocState<KeepItCleanUser>>(
        builder: (context, state) {
      return StreamBuilder<int>(
          stream: context
              .watch<ProfilePageBloc>()
              .currentIndexStreamController
              .stream,
          builder: (context, snapshot) {
            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                title: Text(
                  (snapshot?.data ?? 0) == 0
                      ? tr("Profilo personale")
                      : tr("Classifica"),
                  style: TextStyle(
                      color: (snapshot?.data ?? 0) == 0
                          ? Colors.black
                          : Colors.white),
                ),
//                actions: [
//                  context.read<ProfilePageBloc>().currentIndex == 0
//                      ? PopupMenuButton<String>(
//                          onSelected:(string)=> choiceAction(string),
//                          itemBuilder: (BuildContext context) {
//                            return <String>[
//                              tr("Impostazioni"),
//                              tr("Chi siamo"),
//                            ].map((String choice) {
//                              return PopupMenuItem<String>(
//                                value: choice,
//                                child: Text(choice),
//                              );
//                            }).toList();
//                          },
//                        )
//                      : Container()
//                ],
                centerTitle: true,
                elevation: 0,
                backgroundColor: (snapshot?.data ?? 0) == 0
                    ? Theme.of(context).accentColor
                    : Theme.of(context).backgroundColor,

                iconTheme: IconThemeData(
                    color: (snapshot?.data ?? 0) == 0
                        ? Colors.black
                        : Colors.white),
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Theme.of(context).backgroundColor,
                elevation: 0,
                selectedItemColor: Colors.blue[400],
                unselectedItemColor: Colors.white,
                currentIndex: (snapshot?.data ?? 0),
                selectedFontSize: 16,
                unselectedFontSize: 16,
                onTap: (index) =>
                    _bloc.currentIndexStreamController.sink.add(index),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: tr("Profilo personale")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.grade), label: tr("Classifica"))
                ],
              ),
              body: (snapshot?.data ?? 0) == 0
                  ? SizedBox.expand(
                      child: Column(
                        children: [
                          Flexible(
                            flex: 3,
                            child: ClipPath(
                              clipper: BottomCurveClipper(),
                              child: SizedBox.expand(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag: "profilePic",
                                          child: CircleAvatar(
                                            backgroundImage: context
                                                    .watch<ProfilePageBloc>()
                                                    .isUserLoggedIn()
                                                ? NetworkImage(
                                                    context
                                                        .watch<
                                                            ProfilePageBloc>()
                                                        .getProfilePhotoUrl(),
                                                    scale: 1)
                                                : ExactAssetImage(
                                                    'assets/no-avatar.jpg'),
                                            maxRadius: 50,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              _bloc.getUsername(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            context
                                                    .watch<ProfilePageBloc>()
                                                    .isUserLoggedIn()
                                                ? IconButton(
                                                    icon: Icon(
                                                      Icons.exit_to_app,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () => context
                                                        .watch<
                                                            ProfilePageBloc>()
                                                        .signOut(context),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Container(
                              color: Theme.of(context).backgroundColor,
                              child: context
                                      .watch<ProfilePageBloc>()
                                      .isUserLoggedIn()
                                  ? state.state == BlocStateEnum.LOADING
                                      ? CircularProgressIndicator()
                                      : Swiper(
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            int nOfReports = context
                                                .watch<ProfilePageBloc>()
                                                .getNumberOfReportsForType(
                                                    index);
                                            return ProfileBinReportContainer(
                                              index: index,
                                              numberOfReports: nOfReports,
                                            );
                                          },
                                          itemCount: typesOfBin.length,
                                          viewportFraction: 0.8,
                                          scale: 0.8,
                                        )
                                  : Center(
                                      child: SizedBox.expand(
                                          child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      margin: EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              tr("Benvenuto nel tuo profilo personale!"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            AutoSizeText(
                                              tr("In questa pagina potrai tenere traccia di tutte le segnalazioni che effettui!"),
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            AutoSizeText(
                                              tr("Per poter cominciare pero', devi tornare alla pagina principale e accedere"),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            FlatButton.icon(
                                                onPressed: () =>
                                                    AutoRouter.of(context).push(
                                                        LoginPageViewRoute()),
                                                icon: Icon(
                                                  Icons.perm_identity,
                                                  color: Colors.green,
                                                ),
                                                label: Text(
                                                  tr("Accedi"),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ))),
                            ),
                          )
                        ],
                      ),
                    )
                  : ClassificaPageView(),
            );
          });
    });
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    var controlPoint = Offset(size.width / 2, size.height);

    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, size.width, size.height - 60);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

void choiceAction(String choice) {
  if (choice == tr("Impostazioni")) {
    print('Impostazioni');
  } else if (choice == tr("Chi siamo")) {
    print('Chi siamo');
  }
}
