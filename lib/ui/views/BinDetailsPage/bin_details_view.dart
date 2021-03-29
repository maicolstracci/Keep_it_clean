import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_it_clean/models/bin_model.dart';
import 'package:keep_it_clean/ui/views/BinDetailsPage/bin_details_viewmodel.dart';
import 'package:keep_it_clean/ui/views/BinDetailsPage/bin_image.dart';
import 'package:keep_it_clean/ui/views/BinDetailsPage/like_bar.dart';
import 'package:keep_it_clean/utils/bloc_utils.dart';

class BinDetailsPageView extends StatefulWidget {
  @override
  _BinDetailsPageViewState createState() => _BinDetailsPageViewState();
}

class _BinDetailsPageViewState extends State<BinDetailsPageView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            BinDetailsBloc(BlocState(state: BlocStateEnum.IDLE))..getBinInfo(),
        child: BlocBuilder<BinDetailsBloc, BlocState<Bin>>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).backgroundColor,
                elevation: 0,
                title: state.state != BlocStateEnum.DONE
                    ? Text("")
                    : Text(tr(state.data.type)),
                centerTitle: true,
                actions: [
                  IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () => BlocProvider.of<BinDetailsBloc>(context)
                        .showReportDialog(),
                    icon: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              body: state.state != BlocStateEnum.DONE
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Flexible(
                            flex: 6,
                            child: Stack(
                              children: <Widget>[
                                ClipPath(
                                  clipper: BottomCurveClipper(),
                                  child: BinImageView(
                                    imgName: state.data.photoUrl,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 60,
                                    child: LikeBar(
                                      binID: state.data.id,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        tr('Segnalato da'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Flexible(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 4.0,
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white),
                                          padding: EdgeInsets.only(left: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Flexible(
                                                child: Container(
                                                  child: Text(
                                                    state.data.username,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () => BlocProvider
                                                        .of<BinDetailsBloc>(
                                                            context)
                                                    .navigateToReporterProfile(
                                                        context),
                                                icon: Icon(
                                                  Icons.launch,
                                                  color: Colors.blue,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        tr("In data"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4.0,
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white),
                                        padding: EdgeInsets.all(12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              state.data.reportDate
                                                  .substring(0, 10),
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: FlatButton.icon(
                                      padding: const EdgeInsets.all(10),
                                      onPressed:
                                          BlocProvider.of<BinDetailsBloc>(
                                                  context)
                                              .launchMaps,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(6.0),
                                      ),
                                      color: Colors.blue[400],
                                      textColor: Theme.of(context).accentColor,
                                      icon: Icon(Icons.public),
                                      label: Text(
                                        tr("Mostra su maps"),
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
            );
          },
        ));
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    var controlPoint = Offset(size.width / 2, size.height - 65);

    path.lineTo(0, size.height - 10);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, size.width, size.height - 10);
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
