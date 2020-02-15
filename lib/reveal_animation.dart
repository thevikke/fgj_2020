import 'dart:math';

import 'package:flutter/material.dart';

/// On generate switch to select named function,
/// check how to not show animation for when using basic page
class RevealRoute<T> extends MaterialPageRoute<T> {
  RevealRoute({
    WidgetBuilder builder,
    RouteSettings settings,
    this.transitionColor = Colors.green,
    this.transitionDuration = const Duration(milliseconds: 500),
  }) : super(builder: builder, settings: settings);

  Color transitionColor;
  Duration transitionDuration;
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    //  if (settings.isInitialRoute) return child;

    return RevealTransition(
      child: child,
      duration: transitionDuration,
      color: transitionColor,
    );
  }
}

class RevealTransition extends StatefulWidget {
  RevealTransition({@required this.child, this.color, this.duration});
  final Widget child;
  final Color color;
  final Duration duration;
  @override
  _RevealTransitionState createState() => _RevealTransitionState();
}

class _RevealTransitionState extends State<RevealTransition>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  double _fraction = 0.0;
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    /// When closed run the animation again.
    return WillPopScope(
      onWillPop: () async {
        _visible = true;
        _controller.forward();
        return Future(() => true);
      },
      child: Stack(
        children: [
          widget.child,

          /// Ignorepointer so user can't interact with the reveal effect.
          IgnorePointer(
            ignoring: true,

            /// Paints the circle animation.
            child: CustomPaint(
              painter: RevealPainter(

                  /// Size of circle
                  fraction: _fraction,
                  screenSize: MediaQuery.of(context).size,
                  color: widget.color,
                  duration: widget.duration,

                  /// When done animating we want to set the circle invisible.
                  visible: _visible),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    reset();
    super.deactivate();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    /// Start reveal animation.
    reveal();
    super.initState();
  }

  /// Call this function to start the reveal effect.
  void reveal() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)

      /// [AddListener] tells us when animation value has changed.
      ..addListener(() {
        setState(() {
          /// Update [_fraction] with [_animation.value] to increase the circle size.
          _fraction = _animation.value;
        });
      })
      ..addStatusListener((AnimationStatus state) {
        /// When completed, so animation is at the end we reverse.
        if (state == AnimationStatus.completed) {
          setState(() {
            /// we could enable reversing if that looks better for you
            _controller.reverse();
          });

          /// When dismissed, so animation has reversed back to beginning we set painter invisible.
        } else if (state == AnimationStatus.dismissed) {
          _visible = false;
        }
      });

    /// Start animation.
    _controller.forward();
  }

  void reset() {
    _fraction = 0.0;
  }
}

/// Paints the circle.
class RevealPainter extends CustomPainter {
  final double fraction;
  final Size screenSize;
  final Color color;
  final Duration duration;
  final bool visible;

  RevealPainter(
      {@required this.fraction,
      @required this.screenSize,
      @required this.color,
      @required this.duration,
      @required this.visible});

  @override
  void paint(Canvas canvas, Size size) {
    var finalRadius, radius;
    var paint = Paint()
      ..color = visible ? color : Colors.transparent
      ..style = PaintingStyle.fill;

    finalRadius = sqrt(
        pow(screenSize.width / 2, 2) + pow(screenSize.height - 32.0 - 48.0, 2));
    print(finalRadius);
    radius = 24.0 + finalRadius * fraction;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(RevealPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
