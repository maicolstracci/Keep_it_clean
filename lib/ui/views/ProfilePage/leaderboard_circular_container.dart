import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/app/router.gr.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import 'classifica_page_viewmodel.dart';

class LeaderboardCircularContainer
    extends HookViewModelWidget<ClassificaPageViewModel> {
  final int ranking;
  final DocumentSnapshot user;

  LeaderboardCircularContainer({required this.ranking, required this.user});

  @override
  Widget buildViewModelWidget(
      BuildContext context, ClassificaPageViewModel viewModel) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(
          begin: Offset(0, (ranking * -500).toDouble()), end: Offset(0, 0)),
      curve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(milliseconds: ranking * 350),
      builder: (context, offset, child) => Transform.translate(
        offset: offset,
        child: child,
      ),
      child: GestureDetector(
        onTap: () => AutoRouter.of(context)
            .push(ReporterProfileViewRoute(reporterUid: user.reference.id)),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (ranking).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                height: ranking == 1 ? 100 : 80,
                width: ranking == 1 ? 100 : 80,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff98FB98), width: 2),
                    borderRadius: BorderRadius.circular(300.0),
                    color: Theme.of(context).backgroundColor,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xff98FB98).withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 35)
                    ]),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(300.0),
                    child: user['profilePic'] == null
                        ? Image.asset("assets/no-avatar.jpg")
                        : FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: "assets/no-avatar.jpg",
                            image: user['profilePic'],
                          )),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: 100,
                child: Text(
                  user['name'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).accentColor),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                user['totalNumberOfReports'].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Color(0xff98FB98)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
