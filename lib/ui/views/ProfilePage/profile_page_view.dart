import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/profile_bin_report_container.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/profile_page_viewmodel.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';

import 'classifica_page_view.dart';

class ProfilePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<ProfilePageViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                title: Text(
                  model.currentIndex == 0 ? tr("Profilo personale") : tr("Classifica"),
                  style: TextStyle(color:model.currentIndex == 0 ? Colors.black: Colors.white),
                ),
                actions: [
                  model.currentIndex == 0
                      ? PopupMenuButton<String>(
                          onSelected:(string)=> choiceAction(string),
                          itemBuilder: (BuildContext context) {
                            return <String>[
                              tr("Impostazioni"),
                              tr("Chi siamo"),
                            ].map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        )
                      : Container()
                ],
                centerTitle: true,
                elevation: 0,
                backgroundColor: model.currentIndex == 0 ? Theme.of(context).accentColor : Theme.of(context).backgroundColor,

                iconTheme: IconThemeData(color: model.currentIndex == 0 ? Colors.black : Colors.white),
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Theme.of(context).backgroundColor,
                elevation: 0,
                selectedItemColor: Colors.blue[400],
                unselectedItemColor: Colors.white,
                currentIndex: model.currentIndex,
                selectedFontSize: 16,
                unselectedFontSize: 16,

                onTap: (index) => model.changeCurrentIndex(index),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), title: Text( tr("Profilo personale") )),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.grade), title: Text(tr("Classifica")))
                ],
              ),
              body: model.currentIndex == 0
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
                                        CircleAvatar(
                                          backgroundImage: model
                                                  .isUserLoggedIn()
                                              ? NetworkImage(
                                                  model.getProfilePhotoUrl(),
                                                  scale: 1)
                                              : ExactAssetImage(
                                                  'assets/no-avatar.jpg'),
                                          maxRadius: 50,
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
                                              model.getUsername(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            model.isUserLoggedIn()
                                                ? IconButton(
                                                    icon: Icon(
                                                      Icons.exit_to_app,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () =>
                                                        model.signOut(),
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
                              child: model.isUserLoggedIn()
                                  ? model.isBusy
                                      ? CircularProgressIndicator()
                                      : Swiper(
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            int nOfReports =
                                                model.getNumberOfReportsForType(
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
                                              tr("Benvenuto nel tuo profilo personale!") ,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            AutoSizeText(
                                              tr("In questa pagina potrai tenere traccia di tutte le segnalazioni che effettui!")  ,
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            AutoSizeText(
                                              tr("Per poter cominciare pero', devi tornare alla pagina principale e accedere") ,

                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            FlatButton.icon(
                                                onPressed: () =>
                                                    model.navigateToLoginPage(),
                                                icon: Icon(
                                                  Icons.perm_identity,
                                                  color: Colors.green,
                                                ),
                                                label: Text(
                                                  tr("Accedi") ,
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
            ),
        viewModelBuilder: () => ProfilePageViewModel());
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
