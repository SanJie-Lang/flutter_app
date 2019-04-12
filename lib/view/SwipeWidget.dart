import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef void VoidCallback();

double _buttonWidth = 80.0;
final _effectiveSpeed = 600;

// ignore: must_be_immutable
class SwipeWidget extends StatefulWidget {
  Widget child;
  String button;
  Color buttonColor;
  VoidCallback onButtonPressed;
  VoidCallback onTap;

  SwipeWidget({this.child, this.button, this.buttonColor, this.onButtonPressed, this.onTap});


  @override
  State createState() => IState(child, button, buttonColor, onButtonPressed, onTap);

}

class IState extends State<SwipeWidget> with SingleTickerProviderStateMixin {
  Widget child;
  String button;
  Color buttonColor;
  VoidCallback onButtonPressed;
  VoidCallback onTap;

  double _x = 0.0;
  Offset _lastOffset;

  AnimationController _animation;
  VoidCallback _animationListener;
  bool isOpen = false;

  IState(this.child, this.button, this.buttonColor,
      this.onButtonPressed, this.onTap);

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(vsync: this);
  }

  void _moveSmoothly(double start, double end, {int duration: 100}) {
    _animationListener = () {
      final distance = (end - start) * _animation.value + start;
      setState(() {
        _x = distance;
      });
      if (_animation.value == 1.0) {
        _animation.removeListener(_animationListener);
      }
    };
    _animation
      ..reset()
      ..duration = Duration(milliseconds: duration)
      ..addListener(_animationListener)
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideWidget(
      offset: Offset(_x, 0.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onTap,
                  onHorizontalDragDown: (detail) {
                    _lastOffset = detail.globalPosition;
                  },
                  onHorizontalDragUpdate: (detail) {
                    setState(() {
                      _x += detail.globalPosition.dx - _lastOffset.dx;

                      if (_x < -_buttonWidth) {
                        _x = -_buttonWidth;
                      }

                      if (_x > 0) {
                        _x = 0.0;
                      }
                      _lastOffset = detail.globalPosition;
                    });
                  },
                  onHorizontalDragEnd: (detail) {
                    if (_x > -_buttonWidth / 2) {
                      if (detail.velocity.pixelsPerSecond.dx <
                          -_effectiveSpeed) {
                        //open
                        isOpen = true;
                        _moveSmoothly(_x, -_buttonWidth);
                      } else {
                        //close
                        isOpen = false;
                        _moveSmoothly(_x, 0.0);
                      }
                    } else {
                      if (detail.velocity.pixelsPerSecond.dx >
                          _effectiveSpeed) {
                        //close
                        isOpen = false;
                        _moveSmoothly(_x, 0.0);
                      } else {
                        //open
                        isOpen = true;
                        _moveSmoothly(_x, -_buttonWidth);
                      }
                    }
                  },
                  onHorizontalDragCancel: () {
                  },
                  child: child),
            ),
            Container(
              width: _buttonWidth,
              child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(),
                  onPressed: () {
                    onButtonPressed();
                  },
                  color: buttonColor,
                  child: Text(
                    button,
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SlideWidget extends SingleChildRenderObjectWidget {

  Offset offset;

  SlideWidget({Key key, Widget child, this.offset: Offset.zero})
      : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) => RenderSlideObject();

  @override
  void updateRenderObject(BuildContext context, RenderSlideObject renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject._offset = offset;
    renderObject.markNeedsLayout();
  }
}

class RenderSlideObject extends RenderProxyBox {
  Offset _offset = Offset.zero;

  RenderSlideObject({RenderBox child}) : super(child);

  @override
  void paint(PaintingContext context, Offset offset) {
    context.pushClipRect(
        needsCompositing, offset, Offset.zero & size, defaultPaint);
  }

  void defaultPaint(PaintingContext context, Offset offset) {
    context.paintChild(child, offset + _offset);
  }

  @override
  performLayout() {
    BoxConstraints childConstraints = const BoxConstraints();
    child.layout(childConstraints, parentUsesSize: true);
    size = child.size - Offset(_buttonWidth, 0.0);
  }

  @override
  bool hitTestChildren(HitTestResult result, {Offset position}) {
    return child.hitTest(result, position: (position - _offset));
  }
}