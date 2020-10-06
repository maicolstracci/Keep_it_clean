import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import 'classifica_page_viewmodel.dart';

class ClassificaPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ClassificaPageViewModel>.reactive(
        builder: (context, model, child) {
          return SizedBox.expand(
              child: AnimatedList(
            key: model.listKey,
            itemBuilder: (context, index, animation) {
              return SlideTransition(
                position: CurvedAnimation(parent: animation, curve: Curves.ease)
                    .drive(
                  Tween(
                    begin: Offset(-2, 0),
                    end: Offset(0, 0),
                  ),
                ),
                child: RankingProfileContainer(
                    ranking: index + 1, user: model.data[index]),
              );
            },
          ));
        },
        viewModelBuilder: () => ClassificaPageViewModel());
  }
}

class RankingProfileContainer
    extends HookViewModelWidget<ClassificaPageViewModel> {
  final int ranking;
  final DocumentSnapshot user;

  RankingProfileContainer({this.ranking, this.user});

  @override
  Widget buildViewModelWidget(
      BuildContext context, ClassificaPageViewModel viewModel) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => viewModel.navigateToUserPage(user.documentID),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context)
                              .backgroundColor
                              .withOpacity(.9)),
                      child: Text(
                        (ranking).toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: user.data['profilePic'] == null
                            ? Image.asset("assets/no-avatar.jpg")
                            : FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                placeholder: "assets/no-avatar.jpg",
                                image: user.data['profilePic'],
                              ))),
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        user.data['name'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      user.data['totalNumberOfReports'].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
