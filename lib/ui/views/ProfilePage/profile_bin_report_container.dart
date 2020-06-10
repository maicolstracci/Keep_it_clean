
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/utils/constants.dart';

class ProfileBinReportContainer extends StatelessWidget {
  final int index;
  final int numberOfReports;

  ProfileBinReportContainer({this.index, this.numberOfReports});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 40),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                "assets/icons/icon_type_${index+1}.png",
                height: 120,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(typesOfBin[index],
                      maxLines: 2,
                      wrapWords: false,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      )),
                  Text(numberOfReports.toString(),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


//Widget _createBox(double width, int index) {
//    String img, name, n;
//    index++;
//
//    img = 'assets/icons/icon_type_$index.png';
//    name = AppTranslations.of(context).text("icon_string_$index");
//
//    if (userData['$index'] != null) {
//      n = userData['$index'].toString();
//    } else
//      n = "0";
//
//    return Padding(
//      padding: const EdgeInsets.symmetric(vertical: 40),
//      child: Container(
//        width: width,
//        decoration: BoxDecoration(
//          color: Colors.white,
//          borderRadius: BorderRadius.circular(25),
//          boxShadow: [
//            BoxShadow(color: Colors.black12, blurRadius: 40),
//          ],
//        ),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.only(left: 8.0),
//              child: Image.asset(
//                img,
//                height: 120,
//              ),
//            ),
//            Expanded(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  AutoSizeText(name,
//                      maxLines: 2,
//                      wrapWords: false,
//                      style: TextStyle(
//                        fontSize: 36,
//                        fontWeight: FontWeight.bold,
//                        fontFamily: "Montserrat",
//                      )),
//                  Text(n,
//                      style: TextStyle(
//                        fontSize: 48,
//                        fontWeight: FontWeight.bold,
//                        fontFamily: "Montserrat",
//                      )),
//                ],
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }