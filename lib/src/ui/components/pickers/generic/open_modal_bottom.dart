import 'package:flutter/material.dart';

Future<Widget> openModalBottom({BuildContext context, Widget child}) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return GestureDetector(
          behavior: HitTestBehavior.opaque, onTap: () {}, child: child);
    },
  );
}
