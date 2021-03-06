import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'picture_selection_viewmodel.dart';

class PictureSelectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PictureSelectionViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text(tr("Scegli una immagine")),
                centerTitle: true,
                backgroundColor: Theme.of(context).backgroundColor,
                elevation: 0,
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child:
                        Image.asset("assets/illustrations/take-picture.png", fit: BoxFit.contain,),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(tr("Carica una bella foto, tutti vedranno la tua opera d'arte!")
                        ,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      )),
                  SizedBox(height: 16,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(tr("Scegli come continuare"),style: TextStyle(color: Colors.white),),
                      SizedBox(height: 8,),
                      Row(
                        children: [SizedBox(width: 16,),
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              onPressed: () => model.takePicture("galleria"),
                              child: Text(tr("galleria")),
                            ),
                          ),
                          SizedBox(width: 16,),
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              onPressed: () => model.takePicture("camera"),
                              child: Text(tr("camera")),
                            ),
                          ),SizedBox(width: 16,),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
        viewModelBuilder: () => PictureSelectionViewModel());
  }
}
