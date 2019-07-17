import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../utils/type_check.dart' show isNotNull;
import '../generic/open_modal_bottom.dart' show openModalBottom;
import 'list_picker.dart';

dynamic _selectedItem;

Future<Widget> openListPicker(
  BuildContext context, {
  List<dynamic> listItems,
  Function onItemChanged,
  Function onOk,
  dynamic initialItem,
}) async {
  _selectedItem = isNotNull(initialItem) ? initialItem : listItems.first;
  return openModalBottom(
    context: context,
    child: Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              if (onOk is Function) {
                onOk(_selectedItem);
              }
              _selectedItem = null;

              Future<void>.delayed(Duration(milliseconds: 100), () {
                Navigator.pop(context);
              });
            },
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Divider(),
          ListPicker(
            listItems: listItems,
            onItemChanged: (dynamic item) {
              _selectedItem = item;
              if (onItemChanged is Function) {
                onItemChanged(item);
              }
            },
            initialItem: initialItem,
          ),
        ],
      ),
    ),
  );
}
