import 'package:flutter/material.dart';

import '../../../constants/layout.dart' show borderRadius;
import '../../../typography.dart' show DISABLED_COLOR;

class StyledAlertDialog extends StatelessWidget {
  const StyledAlertDialog({this.title, this.content, this.onOk, this.onCancel});

  final String title;
  final String content;
  final Function onOk;
  final Function onCancel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (onCancel is Function) {
                onCancel();
              } else if (onOk is Function) {
                onOk();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          Align(
            alignment: FractionalOffset.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0.0, 12.0))
                        ]),
                    constraints: const BoxConstraints(
                      minHeight: 120,
                    ),
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 12.0, left: 24, right: 24, top: 10),
                                child: Text(
                                  title is String ? title : 'Oops...',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Color.fromRGBO(0, 0, 0, 0.87),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, bottom: 8),
                              child: Text(
                                content is String ? content : null,
                                style: const TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.541327),
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              if (onCancel is Function)
                                FlatButton(
                                    onPressed: onCancel,
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: DISABLED_COLOR,
                                        fontSize: 16,
                                      ),
                                    )),
                              if (onOk is Function)
                                FlatButton(
                                    onPressed: onOk,
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(
                                        color: Color.fromRGBO(55, 180, 188, 1),
                                        fontSize: 16,
                                      ),
                                    )),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
