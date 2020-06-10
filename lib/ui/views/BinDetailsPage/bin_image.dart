import 'package:flutter/material.dart';
import 'package:keep_it_clean/app/locator.dart';
import 'package:keep_it_clean/services/database_services.dart';
import 'package:stacked/stacked.dart';

class BinImageView extends StatelessWidget {
  final String imgName;

  BinImageView({this.imgName});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BinImageViewModel>.reactive(
      onModelReady: (model) {
        model.imgName = this.imgName;
        model.runFuture();
      },
      builder: (context, model, child) => Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: model.data != null
            ? model.data != 'NO IMAGE'
                ? FadeInImage.assetNetwork(
                    placeholder: 'assets/loading.gif',
                    image: model.data,
                    fit: BoxFit.fitWidth,
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                        bottom: 12.0, left: 6.0, right: 6.0),
                    child: Image.asset(
                      'assets/default-bin-photo.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                    ),
                  )
            : Container(
                color: Colors.transparent,
              ),
      ),
      viewModelBuilder: () => BinImageViewModel(),
    );
  }
}

class BinImageViewModel extends FutureViewModel<String> {
  DatabaseService _databaseService = locator<DatabaseService>();

  String imgName;

  @override
  Future<String> futureToRun() async {
    if (imgName != null) {
      String result =
          await _databaseService.getDownloadUrlImageFromName(imgName);
      if (result == null)
        return "NO IMAGE";
      else
        return result;
    }
  }
}
