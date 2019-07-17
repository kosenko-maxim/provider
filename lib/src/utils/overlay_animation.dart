import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import '../../src/ui/components/styled/styled_circular_progress.dart'
    show StyledCircularProgress;

Future<void> clearStack(OverlayEntry overlayEntry) async {
  overlayEntry.remove();
}

Future<void> circularLoading({@required BuildContext context}) async {
  final OverlayState overlayState = Overlay.of(context);
  final OverlayEntry overlayEntry =
      OverlayEntry(builder: (BuildContext context) => CircularLoading());
  overlayState.insert(overlayEntry);
  await Future<void>.delayed(Duration(seconds: 2));
  clearStack(overlayEntry);
}

Future<void> slideAnimation(
    {@required Widget body,
    @required String side,
    @required BuildContext context}) async {
  final OverlayState overlayState = Overlay.of(context);
  final OverlayEntry overlayEntry = OverlayEntry(
      builder: (BuildContext context) => SlideAnimation(
            body: body,
            side: side,
          ));
  overlayState.insert(overlayEntry);
  await Future<void>.delayed(Duration(milliseconds: 1000));
  clearStack(overlayEntry);
}

class CircularLoading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CircularLoadingState();
  }
}

class _CircularLoadingState extends State<CircularLoading>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
            child: Container(
              width: 60,
              height: 60,
              child: const StyledCircularProgress(size: 'md'),
            ))
      ],
    );
  }
}

class SlideAnimation extends StatefulWidget {
  const SlideAnimation({this.body, this.side});

  final Widget body;
  final String side;

  @override
  State<StatefulWidget> createState() {
    return _SlideAnimationState();
  }
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900));

    offset = widget.side == 'right'
        ? Tween<Offset>(end: Offset.zero, begin: const Offset(1, 0.0))
            .animate(controller)
        : Tween<Offset>(begin: const Offset(-1, 0.0), end: const Offset(0, 0))
            .animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    return Align(
        alignment: Alignment.bottomCenter,
        child: SlideTransition(position: offset, child: widget.body));
  }
}
