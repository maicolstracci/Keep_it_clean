import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import 'classifica_page_viewmodel.dart';

class ClassificaPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ClassificaPageViewModel>.reactive(
        builder: (context, model, child) => SizedBox.expand(
              child: model.isBusy
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      scrollDirection: Axis.vertical,
                      children: List.generate(
                        model.data.length,
                        (index) => RankingProfileContainer(
                            ranking: index + 1, user: model.data[index]),
                      )),
            ),
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
                    child: Text(
                      (ranking).toString(),
                      textAlign: TextAlign.center,
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
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      user.data['totalNumberOfReports'].toString(),
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
