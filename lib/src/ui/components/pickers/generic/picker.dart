import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoPicker;
import 'package:user_mobile/src/ui/components/pickers/generic/debouncer.dart';

class Picker extends StatefulWidget {
  const Picker({
    @required this.controller,
    @required this.index,
    @required this.itemList,
    this.animateDuration,
    this.displayFunction,
    this.looping = false,
    this.onSelectedItemChanged,
  });

  final FixedExtentScrollController controller;
  final int index;
  final List<dynamic> itemList;

  final int animateDuration;
  final Function displayFunction;
  final bool looping;
  final Function onSelectedItemChanged;

  @override
  State<StatefulWidget> createState() {
    return _PickerState();
  }
}

class _PickerState extends State<Picker> {
  final Debouncer _debouncer = Debouncer(milliseconds: 700);
  int realIndex;
  bool isDragging;

  static List<Widget> generateListOfItems(
      List<dynamic> list, Function displayFunction, BuildContext context) {
    Function renderer = (Object value) => value;

    if (displayFunction is Function) {
      renderer = displayFunction;
    }

    return List<Widget>.generate(list.length, (int i) {
      final dynamic value = list[i];
      return Container(
        height: 10.0,
        alignment: Alignment.center,
        child: Text(
          value is int
              ? renderer(value.abs()).toString()
              : value.toString(),
          style: TextStyle(
            fontSize: 16.0,
            color: value is int
                ? value < 0 ? Colors.grey : Colors.black
                : value.isEmpty ? Colors.grey : Colors.black,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    realIndex = widget.index;
    super.initState();
  }

  @override
  void didUpdateWidget(Picker oldWidget) {
    if (widget.animateDuration is int) {
      if (widget.index != realIndex) {
        animateToRightIndex();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void animateToRightIndex() {
    _debouncer.run(() {
      widget.controller.animateToItem(
        widget.index,
        duration: Duration(seconds: 1),
        curve: const Cubic(0, 0, 0.58, 1),
      );
    });
  }

  @override
  Widget build(BuildContext build) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(color: Colors.blueGrey),
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          children: _PickerState.generateListOfItems(
            widget.itemList,
            widget.displayFunction,
            context,
          ),
          magnification: 1.1,
          itemExtent: 45.0,
          onSelectedItemChanged: (dynamic _selectedItem) {
            realIndex = _selectedItem;
            widget.onSelectedItemChanged(widget.itemList[realIndex]);
          },
          scrollController: widget.controller,
          useMagnifier: true,
          looping: widget.looping,
        ),
      ),
    );
  }
}
