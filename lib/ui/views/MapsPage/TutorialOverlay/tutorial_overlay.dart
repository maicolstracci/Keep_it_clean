import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

List<TargetFocus> targets = [];

showTutorial(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  if (!sharedPreferences.containsKey("alreadyShowedTutorial")) {
    await sharedPreferences.setBool('alreadyShowedTutorial', true);

    targets.add(
      TargetFocus(identify: "Filter bar", keyTarget: filterBarKey, contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              padding: EdgeInsets.only(bottom: 180),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tr("tutorial_starter"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 26.0),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    tr("tutorial_title_filterBar"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    tr("tutorial_filterBar"),
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ],
              ),
            ))
      ]),
    );
    targets.add(
      TargetFocus(
          identify: "Move to user location target",
          keyTarget: moveToUserLocationKey,
          contents: [
            ContentTarget(
                align: AlignContent.bottom,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        tr("tutorial_title_moveToUserLocation"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          tr("tutorial_moveToUserLocation"),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ))
          ]),
    );
    targets.add(
      TargetFocus(
          identify: "Report illegal waste disposal",
          keyTarget: reportIllegalWasteDisposalKey,
          contents: [
            ContentTarget(
                align: AlignContent.bottom,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        tr("tutorial_title_reportIllegalWasteDisposal"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          tr("tutorial_reportIllegalWasteDisposal"),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ))
          ]),
    );
    targets.add(
      TargetFocus(identify: "Add new bin", keyTarget: addNewBinKey, contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tr("tutorial_title_addNewBin"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      tr("tutorial_addNewBin"),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ))
      ]),
    );
    targets.add(
      TargetFocus(
          identify: "Personal profile",
          keyTarget: personalProfileKey,
          contents: [
            ContentTarget(
                align: AlignContent.bottom,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        tr("tutorial_title_personalProfile"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          tr("tutorial_personalProfile"),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ))
          ]),
    );

    await Future.delayed(Duration(seconds: 2));

    TutorialCoachMark(context,
        targets: targets,
        opacityShadow: 0.9,
        colorShadow: Theme.of(context).backgroundColor,
        textStyleSkip:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textSkip: tr("SALTA"), finish: () {
      return;
    })
      ..show();
  } else {
    return;
  }
}
