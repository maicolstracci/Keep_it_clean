import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keep_it_clean/Localization/app_translation.dart';

class SearchWidget extends StatefulWidget {
  final Function showFilteredMarkers;

  SearchWidget(this.showFilteredMarkers);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  double bottom = 0, right = 0, bottomR = 0;
  bool open = false, openMore = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildButton(65, 65, 5, Colors.lightBlue[400], horizontalButton: true),
        _buildButton(65, 130, 6, Colors.pink[300], horizontalButton: true),
        _buildButton(65, 195, 7, Colors.yellow[400],  horizontalButton: true),
        _buildButton(65, 260, 8, Colors.deepPurpleAccent[100],  horizontalButton: true),
        _buildButton(65, 0, 0, Colors.green[700],  horizontalButton: false),
        _buildButton(145, 0, 2, Colors.green[400],  horizontalButton: false),
        _buildButton(225, 0, 3, Colors.amber[400],  horizontalButton: false),
        _buildButton(300, 0, 1, Colors.red[400],  horizontalButton: false),
        _buildButton(380, 0, 4, Colors.grey[400],  horizontalButton: false),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.green[300]),
            child: AutoAnimatedIconButton(
              icon: AnimatedIcons.search_ellipsis,
              onPressed: () {
                setState(() {
                  if (open) {
                    bottom = 0;
                    bottomR = 0;
                    right = 0;
                    openMore = false;
                    widget.showFilteredMarkers(0);
                  } else {
                    _openButton();
                  }
                  open = !open;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
      double max, double right, int type, Color color1, {bool horizontalButton}) {
    String icon, name;

    switch (type) {
      case 0:
        icon = "icon_back";
        name = AppTranslations.of(context).text("more_string");
        break;
      case 1:
        icon = 'assets/plastic_bottle.png';
        name = AppTranslations.of(context).text("plastic_string");
        break;
      case 2:
        icon = 'assets/glass_bottle.png';
        name = AppTranslations.of(context).text("glass_string");
        break;
      case 3:
        icon = 'assets/paper.png';
        name = AppTranslations.of(context).text("paper_string");
        break;
      case 4:
        icon = 'assets/indifferenziata.png';
        name = AppTranslations.of(context).text("other_string");
        break;
      case 5:
        icon = 'assets/battery.png';
        name = AppTranslations.of(context).text("battery_string");
        break;
      case 6:
        icon = 'assets/drugs.png';
        name = AppTranslations.of(context).text("drugs_string");
        break;
      case 7:
        icon = 'assets/leaf.png';
        name = AppTranslations.of(context).text("leaf_string");
        break;
      case 8:
        icon = 'assets/clothing.png';
        name = AppTranslations.of(context).text("clothing_string");
        break;
    }

    return AnimatedPositioned(
      bottom: bottom > max ? max : bottom,
      right: bottomR > right ? right : bottomR,
      duration: Duration(milliseconds: 1200),
      curve: Curves.bounceOut,
      child: AnimatedOpacity(
        curve: Curves.easeInQuart,
        duration: Duration(milliseconds: 400),
        opacity: !horizontalButton ? (open ? 1.0 : 0.0) : (openMore ? 1.0 : 0.0),
        child: GestureDetector(
          onTap: () {
            if (type == 0) {
              setState(() {
                if (!openMore) {
                  bottomR = 300;
                } else {
                  bottomR = 0;
                }
                openMore = !openMore;
              });
            } else {
              widget.showFilteredMarkers(type);
            }
          },
          child: Column(
            children: <Widget>[
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: color1,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: icon == "icon_back"
                      ? Icon(
                          Icons.arrow_back,
                          size: 32,
                        )
                      : Image.asset(icon),
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _openButton() {
    setState(() {
      bottom = 500;
    });
  }
}
