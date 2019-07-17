import 'dart:convert' show base64Decode;
import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart';

import '../../../src/utils/type_check.dart' show isNotNull;

class PropertyImage extends StatelessWidget {
  factory PropertyImage(
      {String id, String statusColor, String statusValue, String picture}) {
    bool pictureDecodingError = false;
    Uint8List decodedPicture;
    if (picture != null) {
      try {
        decodedPicture = base64Decode(picture);
      } catch (error) {
        pictureDecodingError = true;
      }
    }

    return PropertyImage._(
      id: id,
      statusColor: statusColor,
      statusValue: statusValue,
      picture: decodedPicture,
      pictureDecodingError: pictureDecodingError,
    );
  }

  const PropertyImage._(
      {this.id,
      this.statusColor,
      this.statusValue,
      this.picture,
      this.pictureDecodingError});

  static const Radius radius = Radius.circular(3.0);

  final String id;
  final String statusColor;
  final String statusValue;

  final Uint8List picture;
  final bool pictureDecodingError;

  Widget buildImage() {
    Widget greyContainer({Widget child}) => Container(
          color: const Color(0xFFe9e9e9),
          child: child,
        );

    if (pictureDecodingError) {
      return greyContainer(
          child: const Center(child: Text('Error decoding image :(')));
    }

    if (picture != null) {
      return SizedBox.expand(
        child: Image.memory(
          picture,
          fit: BoxFit.fitWidth,
        ),
      );
    }

    return greyContainer();
  }

  Widget buildStatus(double height) {
    if (statusValue != null) {
      return Positioned(
        right: 0.0,
        top: height * 0.085,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color(int.parse(statusColor)),
                borderRadius: const BorderRadius.only(
                  topLeft: radius,
                  bottomLeft: radius,
                ),
              ),
              alignment: Alignment.center,
              height: 22.0,
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Text(statusValue,
                  style: const TextStyle(
                      fontSize: 14.0, color: Color(0xFFdeffffff))),
            ),
          ],
        ),
      );
    }

    return null;
  }

  Widget buildPlaceholder(double height) {
    if (picture == null && !pictureDecodingError) {
      return Container(
        margin: EdgeInsets.only(top: height / 2, left: 16.0),
        child: const Text('Here will be your property',
            style: TextStyle(fontSize: 16.0, color: Color(0xFF1e1e1e))),
      );
    }

    return null;
  }

  Widget buildId(double height) {
    if (id != null) {
      return Positioned(
        top: height * 0.085,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(3.0, 4.0, 6.0, 3.0),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(81, 81, 81, 0.54),
                borderRadius: BorderRadius.all(radius),
              ),
              height: 22.0,
              margin: const EdgeInsets.only(left: 16.0),
              child: Text('#$id',
                  style: const TextStyle(fontSize: 14.0, color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    const double height = 160.0;
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.grey,
      margin: const EdgeInsets.only(bottom: 1.0),
      child: Stack(
        children: <Widget>[
          buildImage(),
          buildStatus(height),
          buildPlaceholder(height),
          buildId(height),
        ].where(isNotNull).toList(),
      ),
    );
  }
}
