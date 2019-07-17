import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../typography.dart' show ACTIVE_COLOR, DISABLED_COLOR;
import '../../../utils/type_check.dart' show isNotNull;
import 'item_layout_container.dart';

class ItemLayout extends StatelessWidget {
  const ItemLayout({
    this.picture,
    this.body,
    this.suffix,
    this.link = false,
    this.onTap,
    this.disabled = false,
  });

  final String picture;
  final String body;
  final dynamic suffix;
  final bool link;
  final Function onTap;
  final bool disabled;

  Widget _buildPicture() {
    if (picture is String) {
      return Container(
        margin: const EdgeInsets.only(right: 8.0),
        child: Center(
          child: picture.startsWith('<svg')
              ? SvgPicture.string(picture)
              : Image.memory(
                  base64Decode(picture),
                ),
        ),
      );
    }

    return null;
  }

  Widget _buildTextContent(BuildContext context) {
    if (body is String) {
      return Expanded(
        flex: 3,
        child: Container(
          child: renderText(body),
        ),
      );
    } else {
      return null;
    }
  }

  Widget _buildSuffix() {
    if (isNotNull(suffix)) {
      return Expanded(
        flex: 1,
        child: Container(
          alignment: suffix is Switch
              ? const Alignment(1.5, 1)
              : const Alignment(1, 1),
          child: renderText(suffix),
        ),
      );
    } else {
      return null;
    }
  }

  Widget _buildLink() {
    if (link) {
      return Icon(
        Icons.chevron_right,
        color: disabled ? DISABLED_COLOR : ACTIVE_COLOR,
      );
    } else {
      return null;
    }
  }

  Widget renderText(Object value) {
    if (!(value is StatefulWidget) && !(value is StatelessWidget)) {
      const double fontSize = 16.0;
      return Text(
        isNotNull(value) ? value.toString() : '--',
        style: disabled
            ? const TextStyle(fontSize: fontSize, color: DISABLED_COLOR)
            : const TextStyle(fontSize: fontSize, color: ACTIVE_COLOR),
      );
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return ItemLayoutContainer(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildPicture(),
            _buildTextContent(context),
            _buildSuffix(),
            _buildLink(),
          ].where(isNotNull).toList(),
        ),
        onTap: onTap,
        disabled: disabled);
  }
}
