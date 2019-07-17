import 'package:flutter/material.dart';

class SubPoint extends StatelessWidget {
  const SubPoint(this._text);

  final String _text;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 82.0),
        child: Row(
          children: <Widget>[
            Container(
              child: const Icon(Icons.done,
                  color: Color.fromRGBO(115, 115, 115, 0.54)),
            ),
            Container(
              padding: const EdgeInsets.only(left: 11),
              child: Text(_text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    color: Color.fromRGBO(115, 115, 115, 1.0),
                  )),
            )
          ],
        ));
  }
}
