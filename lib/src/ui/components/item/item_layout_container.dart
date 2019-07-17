import 'package:flutter/material.dart';

class ItemLayoutContainer extends StatelessWidget {
  const ItemLayoutContainer(this.child, {this.onTap, this.disabled});

  final Function onTap;
  final dynamic child;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.white,
      child: InkWell(
        onTap: onTap is Function ? onTap : null,
        child: buildContainer(child),
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      constraints: const BoxConstraints(
        minHeight: 35.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: child,
      ),
    );
  }
}
