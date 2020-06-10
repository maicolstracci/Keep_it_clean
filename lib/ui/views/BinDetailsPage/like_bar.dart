import 'package:flutter/material.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:stacked/stacked.dart';

import 'like_button.dart';

class LikeBar extends StatelessWidget {
  final String binID;

  LikeBar({this.binID});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LikeBarModel>.reactive(
        onModelReady: (model) {
          model.binID = this.binID;
          model.notifySourceChanged();
        },
        builder: (context, model, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                        ),
                      ],
                      shape: BoxShape.circle,
                      color: Colors.green[700].withOpacity(.98)),
                  child: LikeButton(
                    type: 1,
                    binID: binID,
                    prevModel: model,
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.0,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            model.dataReady ? model.data['likes'].toString() : "",
                            style: TextStyle(fontSize: 32, color: Colors.green),
                              textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "-",
                            textAlign: TextAlign.center,

                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            model.dataReady
                                ? model.data['dislikes'].toString()
                                : "",
                            textAlign: TextAlign.center,

                            style: TextStyle(fontSize: 32, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                        ),
                      ],
                      shape: BoxShape.circle,
                      color: Colors.red[800].withOpacity(.98)),
                  child: LikeButton(
                    type: 2,
                    binID: binID,
                    prevModel: model,
                  ),
                ),
              ],
            ),
        viewModelBuilder: () => LikeBarModel());
  }
}

class LikeBarModel extends StreamViewModel {
  DatabaseService _databaseService = locator<DatabaseService>();

  String binID;

  @override
  Stream get stream => _databaseService.streamLikesFromBin(binID);
}
