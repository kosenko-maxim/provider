import 'package:flutter/material.dart';

class MainPoint extends StatelessWidget {
  const MainPoint(this._text, this._number);

  final String _text;
  final int _number;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(children: <Widget>[
        Container(
          padding: const EdgeInsets.all(1.0),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(115, 115, 115, 1.0),
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
              maxRadius: 14.0,
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              child: Text(
                  _number.toString(), style: const TextStyle(fontSize: 16.0))),
        ),
        Container(
            child: Flexible(
                child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      _text,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(115, 115, 115, 0.87)),
                    )))),
      ]),
    );
  }
}
