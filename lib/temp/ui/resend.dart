import 'dart:async';
import 'package:flutter/material.dart';

class Resend extends StatefulWidget {
  const Resend({@required this.type, this.onPressed});

  ///Circular - Timer
  final String type;

  final Function onPressed;

  @override
  _ResendState createState() => _ResendState();
}

class _ResendState extends State<Resend> {
  Timer timer;
  int start;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case 'Circular':
        return _buildCircular();
      case 'Timer':
        return _buildResentCode();
      default:
        return Container();
    }
  }

  Widget _buildCircular() {
    return CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor);
  }

  Widget _buildResentCode() {
    return Container(
        margin: start != 0
            ? const EdgeInsets.only(top: 18.0)
            : const EdgeInsets.only(top: 2.0),
        child: start != 0
            ? Text('Resend code through 00.$start sec',
                style: const TextStyle(fontSize: 14, color: Color(0x8a000000)))
            : FlatButton(
                onPressed: () {
                  setState(() {
                    startTimer();
                  });
                  if (widget.onPressed is Function) {
                    widget.onPressed();
                  }
                },
                child: Text('Resent code',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Theme.of(context).primaryColor))));
  }

  void startTimer() {
    start = 60;
    const Duration oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
            () {
              if (start < 1) {
                timer.cancel();
              } else {
                start = start - 1;
              }
            },
          ),
    );
  }
}
