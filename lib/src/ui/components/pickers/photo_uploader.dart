import 'dart:async' show Future;
import 'dart:io' show File, Platform;
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;

import '../../../pallete.dart' show primaryColor;
import 'generic/open_modal_bottom.dart' show openModalBottom;

Future<Widget> openPhotoUploader(BuildContext context,
    {Function onChoose, Function onLoad}) async {
  return openModalBottom(
    context: context,
    child: _Uploader(onChoose: onChoose, onLoad: onLoad),
  );
}

class _UploaderButton extends StatelessWidget {
  const _UploaderButton({@required this.onTap, @required this.title});

  final Function onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            height: 48.0,
            child: Center(
              child: title is String
                  ? Text(title,
                      style:
                          TextStyle(fontSize: 16.0, color: primaryColor[500]))
                  : null,
            ),
          ),
          const Divider(height: 2.0),
        ],
      ),
    );
  }
}

class _Uploader extends StatelessWidget {
  const _Uploader({this.onChoose, this.onLoad});

  final Function onChoose;
  final Function onLoad;

  Future<void> handleChooseImage(BuildContext context, String type) async {
    if (onChoose is Function) {
      onChoose();
    }

    ImageSource source;

    switch (type) {
      case 'take':
        source = ImageSource.camera;
        break;
      case 'choose':
        source = ImageSource.gallery;
        break;
    }

    final Future<File> cb = pickImage(source);
    Navigator.of(context).pop();
    if (onLoad is Function) {
      onLoad(cb);
    }
  }

  // with Android rotation fix
  Future<File> pickImage(ImageSource source) async {
    final File image =
        await ImagePicker.pickImage(source: source, maxWidth: 640);

    return image != null
        ? Platform.isAndroid
        ? FlutterExifRotation.rotateImage(path: image.path)
        : image
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _UploaderButton(
              title: 'Take Photo',
              onTap: () {
                handleChooseImage(context, 'take');
              }),
          _UploaderButton(
              title: 'Choose Photo',
              onTap: () {
                handleChooseImage(context, 'choose');
              }),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 12.0),
    );
  }
}
