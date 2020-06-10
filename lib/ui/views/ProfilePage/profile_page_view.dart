import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/profile_bin_report_container.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/profile_page_viewmodel.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';

class ProfilePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfilePageViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                title: Text(
                  "Profilo personale",
                  style: TextStyle(color: Colors.black),
                ),
                actions: [
                  PopupMenuButton<String>(
                    onSelected: choiceAction,
                    itemBuilder: (BuildContext context){
                      return choices.map((String choice){
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  )
                ],
                centerTitle: true,
                elevation: 0,
                backgroundColor: Theme.of(context).accentColor,
                brightness: Brightness.dark,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              body: SizedBox.expand(
                child: Column(
                  children: [
                    Flexible(
                      flex: 2,
                      child: ClipPath(
                        clipper: BottomCurveClipper(),
                        child: SizedBox.expand(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: model.isUserLoggedIn()
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        model.getUsername(),
                                        style:
                                            TextStyle(fontWeight: FontWeight.w600),
                                      ), model.isUserLoggedIn() ? IconButton(
                                        icon: Icon(Icons.exit_to_app, color: Colors.red,),
                                        onPressed: ()=> model.signOut(),
                                      ) : Container()
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                        color: Theme.of(context).backgroundColor,
                        child: model.isUserLoggedIn()
                            ? Swiper(
                                itemBuilder: (BuildContext context, int index) {
                                  int nOfReports =
                                      model.getNumberOfReportsForType(index);
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
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                margin: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  children: [SizedBox(height: 8,),
                                    Text(
                                      "Benvenuto nel tuo profilo personale!",
                                      textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600
                                        ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "In questa pagina potrai tenere traccia di tutte le segnalazioni che effettui!",
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Per poter cominciare pero', devi tornare alla pagina principale e accedere",
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    FlatButton.icon(
                                        onPressed: () =>model.navigateToLoginPage(),
                                        icon: Icon(
                                          Icons.perm_identity,
                                          color: Colors.green,
                                        ),
                                        label: Text("Accedi",style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600
                                        ),)),
                                  ],
                                ),
                              ))),
                      ),
                    )
                  ],
                ),
              ),
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


void choiceAction(String choice){
  if(choice == "Impostazioni"){
    print('Impostazioni');
  }else if(choice == "Chi siamo") {
    print('Chi siamo');
  }
}
const List<String> choices = <String>[
  "Impostazioni",
  "Chi siamo",
];