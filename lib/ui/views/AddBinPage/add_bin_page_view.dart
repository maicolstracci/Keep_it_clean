import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/add_bin_page_viewmodel.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class AddBinPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddBinPageViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                backgroundColor: Theme.of(context).backgroundColor,
                elevation: 0,
                title: Text(tr("Invia una segnalazione")),
                centerTitle: true,
              ),
              body: SafeArea(
                top: false,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Text(
                            tr("Quali tipologie?"),
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    runAlignment: WrapAlignment.start,
                                    spacing: 10,
                                    runSpacing: 15,
                                    children: List.generate(
                                      typesOfBin.length,
                                      (index) => _BuildButton(index),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      "${model.getTypesSelectedLength} " +  tr("selezionate"),
                                      style: TextStyle(
                                          color: model.getTypesSelectedLength != 0
                                              ? Colors.white
                                              : Colors.red),
                                    ),
                                  ),
                                  RaisedButton.icon(
                                    color: Colors.blue,
                                    onPressed: model.getTypesSelectedLength != 0
                                        ? () async {
                                            model.navigateToPictureSelection();
                                          }
                                        : null,
                                    disabledColor: Colors.blueGrey,
                                    disabledElevation: 4,
                                    elevation: 4,
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                    label: Text(
                                        tr("Prosegui")
                                      ,
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => AddBinPageViewModel());
  }
}

class _BuildButton extends HookViewModelWidget<AddBinPageViewModel> {
  int index;

  _BuildButton(this.index);

  @override
  Widget buildViewModelWidget(
      BuildContext context, AddBinPageViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.addOrRemoveTypeToList(index),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            border: new Border.all(
              width: 3.0,
              color: viewModel.binTypesListContainsIndex(index)
                  ? Colors.blue
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      typesOfBin[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/icons/icon_type_${index + 1}.png",
                      fit: BoxFit.contain,
                    ),
                  ))
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Visibility(
                  visible:
                      viewModel.binTypesListContainsIndex(index) ? true : false,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                    size: 34,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
