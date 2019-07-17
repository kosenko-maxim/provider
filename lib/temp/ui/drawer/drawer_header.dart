import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../../../src/models/auth/user_info.dart' show UserInfo;

class Header extends StatelessWidget {
  const Header({this.userProfile});

  final UserInfo userProfile;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 14.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  userProfile != null
                      ? Text(
                          userProfile.phone.number,
                          style: const TextStyle(
                              fontSize: 20.0,
                              color: Color.fromRGBO(0, 0, 0, 0.87)),
                        )
                      : Container(width: 0.0, height: 0.0),
                  IconButton(
                      icon: const Icon(
                        OMIcons.close,
                        color: Color.fromRGBO(0, 0, 0, 0.54),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ]),
      ),
      Divider(
        color: const Color.fromRGBO(66, 65, 65, 0.38),
      ),
    ]);
  }
}
