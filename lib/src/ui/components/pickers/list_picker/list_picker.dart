import 'package:flutter/material.dart';
import '../generic/picker.dart' show Picker;

class ListPicker extends StatefulWidget {
  const ListPicker({this.onItemChanged, this.initialItem, this.listItems});

  final Function onItemChanged;
  final dynamic initialItem;
  final List<dynamic> listItems;

  @override
  State<StatefulWidget> createState() {
    return _ListPickerState();
  }
}

class _ListPickerState extends State<ListPicker> {
  FixedExtentScrollController itemScrollController;
  dynamic selectedItem;

  @override
  void initState() {
    selectedItem = widget.listItems.contains(widget.initialItem)
        ? widget.initialItem
        : widget.listItems.first;
    itemScrollController = FixedExtentScrollController(
        initialItem: widget.listItems.indexOf(selectedItem));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[_buildListPicker()],
    );
  }

  void updateValues() {
    widget.onItemChanged(selectedItem);
  }

  Widget _buildListPicker() {
    return Picker(
      animateDuration: 1000,
      controller: itemScrollController,
      index: widget.listItems.indexOf(selectedItem),
      onSelectedItemChanged: (dynamic item) {
        setState(() {
          selectedItem = item;
          updateValues();
        });
      },
      itemList: widget.listItems,
    );
  }
}
