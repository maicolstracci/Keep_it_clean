import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/ui/views/AddBinPage/add_bin_page_viewmodel.dart';
import 'package:keep_it_clean/utils/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

final int kAnimationDuration = 1100;

class AddBinPageView extends StatefulWidget {
  @override
  _AddBinPageViewState createState() => _AddBinPageViewState();
}

class _AddBinPageViewState extends State<AddBinPageView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: kAnimationDuration), vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
    });

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
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      mainGreen,
                      Theme.of(context).backgroundColor,
                    ], stops: [
                      0.1,
                      0.7
                    ], begin: Alignment.bottomCenter, end: Alignment.topRight),
                  ),
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
                                        (index) => _BuildButton(index,
                                            controller: animationController),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SlideTransition(
                                      position: Tween<Offset>(
                                              begin: Offset(-30, 0),
                                              end: Offset(0, 0))
                                          .animate(CurvedAnimation(
                                              curve: Interval(0.75, 1.0,
                                                  curve: Curves
                                                      .fastLinearToSlowEaseIn),
                                              parent: animationController)),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 16),
                                        child: Text(
                                          "${model.getTypesSelectedLength} " +
                                              tr("selezionate"),
                                          style: TextStyle(
                                              color:
                                                  model.getTypesSelectedLength !=
                                                          0
                                                      ? Colors.white
                                                      : Colors.red),
                                        ),
                                      ),
                                    ),
                                    SlideTransition(
                                      position: Tween<Offset>(
                                              begin: Offset(-30, 0),
                                              end: Offset(0, 0))
                                          .animate(CurvedAnimation(
                                              curve: Interval(0.0, 0.7,
                                                  curve: Curves
                                                      .fastLinearToSlowEaseIn),
                                              parent: animationController)),
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          disabledBackgroundColor:
                                              Colors.blueGrey,
                                          elevation: 4,
                                          padding: EdgeInsets.only(
                                              top: 8,
                                              bottom: 8,
                                              left: 10,
                                              right: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        onPressed:
                                            model.getTypesSelectedLength != 0
                                                ? () async {
                                                    model
                                                        .navigateToPictureSelection(
                                                            context);
                                                  }
                                                : null,
                                        icon: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                        label: Text(
                                          tr("Prosegui"),
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
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
            ),
        viewModelBuilder: () => AddBinPageViewModel());
  }
}

class _BuildButton extends HookViewModelWidget<AddBinPageViewModel> {
  final int index;
  final AnimationController controller;

  _BuildButton(this.index, {required this.controller});

  @override
  Widget buildViewModelWidget(
      BuildContext context, AddBinPageViewModel viewModel) {
    final Animation<Offset> animation = Tween<Offset>(
            begin: Offset(0, 20), end: Offset(0, 0))
        .animate(CurvedAnimation(
            curve: Interval(
                (((1 / typesOfBin.length) * (index)) - 0.45).clamp(0.0, 0.95),
                (((1 / typesOfBin.length) * (index + 1)) + 0.45)
                    .clamp(0.0, 0.95),
                curve: Curves.easeOutCirc),
            parent: controller));

    return SlideTransition(
      position: animation,
      child: GestureDetector(
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
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
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
                    visible: viewModel.binTypesListContainsIndex(index)
                        ? true
                        : false,
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
      ),
    );
  }
}
