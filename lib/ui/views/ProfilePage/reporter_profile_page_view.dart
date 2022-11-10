import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/profile_bin_report_container.dart';
import 'package:keep_it_clean/ui/views/ProfilePage/reporter_profile_page_viewmodel.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';

class ReporterProfileView extends StatelessWidget {
  final String? reporterUid;

  ReporterProfileView({this.reporterUid});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReporterProfilePageViewModel>.reactive(
        onModelReady: (model) {
          model.reporterUid = this.reporterUid;
          model.futureToRun();
        },
        builder: (context, model, child) => Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                title: Text(
                  tr("Profilo personale"),
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Theme.of(context).accentColor,
                brightness: Brightness.dark,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              body: SizedBox.expand(
                child: model.data == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              model.data.profilePic,
                                              scale: 1),
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
                                              model.data.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
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
                                child: Swiper(
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                )),
                          )
                        ],
                      ),
              ),
            ),
        viewModelBuilder: () => ReporterProfilePageViewModel());
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
