import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/ui/views/IllegalWasteDisposalPage/illegal_waste_disposal_viewmodel.dart';
import 'package:stacked/stacked.dart';

class IllegalWasteDisposalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IllegalWasteDisposalViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text("Segnala abbandono rifiuti"),
                backgroundColor: Theme.of(context).backgroundColor,
                elevation: 0,
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              body: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                              child: Image.asset(
                            "assets/illustrations/pick-trash.png",
                            fit: BoxFit.contain,
                          ))),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: AutoSizeText(
                            tr("A nessuno piace vedere rifiuti abbandonati. Speriamo che qualcuno li venga a recuperare!"),
                            maxFontSize: 20,
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: AutoSizeText(
                            tr("Abbiamo bisogno di una foto del problema"),
                            textAlign: TextAlign.center,
                            maxFontSize: 20,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            AutoSizeText(
                              tr("Scegli come continuare"),
                              textAlign: TextAlign.center,
                              maxFontSize: 18,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(
                                  child: Text("Camera"),
                                  onPressed: () => model.takePicture("camera"),
                                  color: Theme.of(context).accentColor,
                                ),
                                RaisedButton(
                                  child: Text("Galleria"),
                                  onPressed: () =>
                                      model.takePicture("galleria"),
                                  color: Theme.of(context).accentColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => IllegalWasteDisposalViewModel());
  }
}
