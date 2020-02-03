
import 'package:flutter/material.dart';
import 'package:keep_it_clean/FirstTimeUserPage/page1.dart';
import 'package:keep_it_clean/FirstTimeUserPage/page2.dart';
import 'package:keep_it_clean/FirstTimeUserPage/page3.dart';
import 'package:keep_it_clean/Utils/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FirstTimeUserWidget extends StatefulWidget {
  @override
  _FirstTimeUserWidgetState createState() => _FirstTimeUserWidgetState();
}

class _FirstTimeUserWidgetState extends State<FirstTimeUserWidget> {
  final _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff4f8f9),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              ScrollConfiguration(
                behavior: FilterListBehavior(),
                child: PageView(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
//                  physics: PageScrollPhysics(),
                  physics: CustomScrollPhysics(),
                  children: <Widget>[Page1(), Page2(), Page3()],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SmoothPageIndicator(
                      controller: _controller, // PageController
                      count: 3,
                      effect: ColorTransitionEffect(
                          spacing: 16.0,
                          dotWidth: 12.0,
                          dotHeight: 12.0,
                          activeDotColor: Colors.green[600],
                          dotColor: Color(0xfff4f8f9)), // your preferred effect
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  CustomScrollPhysics({ScrollPhysics parent}) : super(parent: parent);

  bool isGoingLeft = false;

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    isGoingLeft = offset.sign < 0;
    return offset;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    //print("applyBoundaryConditions");
    assert(() {
      if (value == position.pixels) {
        throw FlutterError(
            '$runtimeType.applyBoundaryConditions() was called redundantly.\n'
                'The proposed new position, $value, is exactly equal to the current position of the '
                'given ${position.runtimeType}, ${position.pixels}.\n'
                'The applyBoundaryConditions method should only be called when the value is '
                'going to actually change the pixels, otherwise it is redundant.\n'
                'The physics object in question was:\n'
                '  $this\n'
                'The position object in question was:\n'
                '  $position\n');
      }
      return true;
    }());
    if (value < position.pixels && position.pixels <= position.minScrollExtent)
      return value - position.pixels;
    if (position.maxScrollExtent <= position.pixels && position.pixels < value)
      // overscroll
      return value - position.pixels;
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) // hit top edge

      return value - position.minScrollExtent;

    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) // hit bottom edge
      return value - position.maxScrollExtent;

    if (!isGoingLeft) {
      return value - position.pixels;
    }
    return 0.0;
  }
}