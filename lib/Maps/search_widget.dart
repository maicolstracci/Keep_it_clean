import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/DatabaseServices/database_services.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';
import 'package:keep_it_clean/Utils/utils.dart';
import 'package:provider/provider.dart';


class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  int buttonTapped;

  Widget _buildButton(int type) {
    String icon, name;

    icon = 'assets/icons/icon_type_$type.png';
    name = AppTranslations.of(context).text("icon_string_$type");


    return Container(
      width: 120,
      decoration: BoxDecoration(
          border: Border.all(
              color: buttonTapped == type ? Colors.green : Colors.transparent,
              width: 2),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
            ),
          ]),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          RawMaterialButton(
            padding: EdgeInsets.all(5),
            onPressed: () {
              setState(() {
                if (buttonTapped == type) {
                  buttonTapped = 0;
                  Provider.of<TypeChanger>(context, listen: false).setType(0);
                } else {
                  buttonTapped = type;
                  Provider.of<TypeChanger>(context, listen: false)
                      .setType(type);
                }
              });
            },
            fillColor: Colors.white,
            splashColor: Colors.green[400],
            elevation: 0,
            highlightElevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(200.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Image.asset(
                    icon,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: buttonTapped == type,
            child: Positioned(
              bottom: -10,
              right: -10,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(40)),
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: new BoxConstraints(
        maxHeight: 60.0,
      ),
      child: ScrollConfiguration(
        behavior: FilterListBehavior(),
        child: ListView.separated(
          padding: EdgeInsets.all(10),
          shrinkWrap: false,
          itemBuilder: (_, index) {
            return _buildButton(index + 1);
          },
          separatorBuilder: (_, index) => Container(
            width: 5,
          ),
          itemCount: 11,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
