import 'package:flutter/material.dart';

import '../../../constants/layout.dart'
    show borderRadius, standardHorizontalPadding, standardVerticalPadding;
import 'styled_circular_progress.dart' show StyledCircularProgress;

class StyledButton extends StatelessWidget {
  const StyledButton(
      {this.text = '', this.onPressed, this.loading = false, this.color});

  final String text;
  final Function onPressed;
  final bool loading;
  final String color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: standardVerticalPadding,
          left: standardHorizontalPadding,
          right: standardHorizontalPadding),
      child: SafeArea(
        child: Container(
            height: 48.0,
            width: double.infinity,
            child: RaisedButton(
              color: color != null
                  ? Color(int.parse(color))
                  : Theme.of(context).primaryColor,
              disabledColor: const Color(0xE6CACACA),
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius)),
              onPressed: loading ? null : onPressed,
              child: buildChild(context),
            )),
      ),
    );
  }

  Widget buildChild(BuildContext context) {
    if (loading) {
      return const StyledCircularProgress(size: 'sm', color: Colors.white);
    }

    return Text(
      text,
      style: const TextStyle(
          fontSize: 14.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFFF)),
    );
  }
}
