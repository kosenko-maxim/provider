import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  const Description();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: const Center(
            child: Text(
      'Add a property in 3 steps',
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: Color.fromRGBO(115, 115, 115, 1.0)),
    )));
  }
}
