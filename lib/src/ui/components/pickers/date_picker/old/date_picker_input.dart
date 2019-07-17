import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../date_picker.dart';

class DatePickerInput extends StatefulWidget {
  const DatePickerInput({
    @required this.initialValue,
    @required this.onDateTimeChanged,
    this.minimumDate,
    this.maximumDate,
    this.minimumYear,
    this.maximumYear,
  });

  final String initialValue;
  final Function onDateTimeChanged;
  final String minimumDate;
  final String maximumDate;
  final String minimumYear;
  final String maximumYear;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerInputState();
  }
}

class _DatePickerInputState extends State<DatePickerInput> {
  final DateFormat formatter = DateFormat('dd.MM.yyyy');
  bool bottomSheetOpen = false;
  String value = 'Choose a date';

  @override
  void initState() {
    if (widget.initialValue is String) {
      value = timestampToString(
        DateTime.parse(widget.initialValue).millisecondsSinceEpoch,
      );
    }
    super.initState();
  }

  String timestampToString(int timestamp) {
    return formatter.format(
      DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  void handleDateTimeChanged(int timestamp) {
    setState(() {
      value = timestampToString(timestamp);
    });
  }

  // ignore: avoid_void_async
  void openBottomSheet(BuildContext context) async {
    setState(() {
      bottomSheetOpen = true;
    });
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return DatePicker(
          minimumDate: DateTime(2013, 5, 10),
          maximumDate: DateTime.now(),
          onDateTimeChanged: handleDateTimeChanged,
          initialDateTime: null,
        );
      },
    );
    setState(() {
      bottomSheetOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        openBottomSheet(context);
      },
      child: Container(
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subhead,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: bottomSheetOpen
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).unselectedWidgetColor,
              width: bottomSheetOpen ? 2.0 : 1.0,
            ),
          ),
        ),
        width: double.infinity,
        padding: EdgeInsets.only(top: 8.0, bottom: bottomSheetOpen ? 7.0 : 8.0),
      ),
    );
  }
}
