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
  double bottom = 0, right = 0;
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildButton(65, 0, 1, Colors.red[400]),
        _buildButton(145, 0, 2, Colors.green[400]),
        _buildButton(225, 0, 3, Colors.amber[400]),
        _buildButton(300, 0, 4, Colors.grey[400]),
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
                    right = 0;
                    widget.showFilteredMarkers(0);
                  } else
                    _openButton();

                  open = !open;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(double max, double right, int type, Color color1) {
    String icon, name;

    switch (type) {
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
    }

    return AnimatedPositioned(
      bottom: bottom > max ? max : bottom,
      right: bottom > right ? right : bottom,
      duration: Duration(milliseconds: 1200),
      curve: Curves.bounceOut,
      child: AnimatedOpacity(
        curve: Curves.easeInQuart,
        duration: Duration(milliseconds: 400),
        opacity: open ? 1.0 : 0.0,
        child: GestureDetector(
          onTap: () {
            widget.showFilteredMarkers(type);
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
                  child: Image.asset(icon),
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
