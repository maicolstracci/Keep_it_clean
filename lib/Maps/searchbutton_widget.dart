import 'package:flutter/material.dart';
import 'package:keep_it_clean/DatabaseServices/database_services.dart';
import 'package:provider/provider.dart';

class SearchButtonWidget extends StatelessWidget {
  final Function function;

  SearchButtonWidget(this.function);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: Provider.of<SearchButtonChanger>(context).getVisibility(),
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RawMaterialButton(
              onPressed: () {
                Provider.of<SearchButtonChanger>(context, listen: false)
                    .setVisibility(false);
                function();
              },
              fillColor: Colors.white,
              splashColor: Colors.green[400],
              elevation: 0,
              highlightElevation: 0,
              constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.55,
                  minHeight: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200.0),
              ),
              child: Text(
                "Ricerca in questa zona",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
