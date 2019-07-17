import 'package:flutter/material.dart';

class StyledCircularProgress extends StatelessWidget {
  const StyledCircularProgress({
    this.size = 'md',
    this.color,
  });

  final String size;
  final Color color;

  static const Map<String, double> sizes = <String, double>{
    'xs': 10.0,
    'sm': 20.0,
    'md': 30.0,
    'lg': 40.0,
    'xl': 50.0,
  };

  @override
  Widget build(BuildContext context) {
    final double chosenSize = sizes[size];
    final AlwaysStoppedAnimation<Color> chosenColor = getColor(context, color);

    return Center(
      child: SizedBox(
        height: chosenSize,
        width: chosenSize,
        child: CircularProgressIndicator(
          valueColor: chosenColor,
        ),
      ),
    );
  }

  AlwaysStoppedAnimation<Color> getColor(BuildContext context, Color color) {
    final Color chosenColor =
        color is Color ? color : Theme.of(context).primaryColor;
    return AlwaysStoppedAnimation<Color>(chosenColor);
  }
}
