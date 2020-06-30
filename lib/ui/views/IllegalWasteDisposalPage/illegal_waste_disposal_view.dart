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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(tr("A nessuno piace vedere rifiuti abbandonati")),

                      RaisedButton(
                        child: Text("foto"),
                        onPressed: model.navigateToTakePicture,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => IllegalWasteDisposalViewModel());
  }
}
