import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' show ReplaySubject;
import '../generic/picker.dart' show Picker;
import 'constants/initial_arrays.dart'
    show INITIAL_D_FULL_ARRAY, INITIAL_M_FULL_ARRAY;
import 'constants/months.dart' show MONTHS;
import 'helpers/generate_range_list.dart' show generateRangeList;
import 'helpers/grey_color.dart' show greyColourInclude, greyColourBegin;


class DatePicker extends StatefulWidget {
  DatePicker({
    @required this.onDateTimeChanged,
    @required this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
  })
      : assert(onDateTimeChanged != null,
  'onDateTimeChanged argument is required!'),
        assert(minimumDate.isBefore(maximumDate),
        'Minimum date should be before maximum date.');

  final Function onDateTimeChanged;
  final DateTime initialDateTime;
  final DateTime minimumDate;
  final DateTime maximumDate;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<DatePicker> {
  final int minimumYear = 1970;
  final int maximumYear = 2030;
  static DateTime initialDateTime;
  int dMin;
  int mMin;
  final int yMin = 0;
  List<int> yFullArray;
  int dMax;
  int mMax;
  int yMax;
  FixedExtentScrollController dayScrollController;
  FixedExtentScrollController monthScrollController;
  FixedExtentScrollController yearScrollController;
  ReplaySubject<int> subject;
  int dIndex;
  int mIndex;
  int yIndex;
  List<int> dArray = INITIAL_D_FULL_ARRAY;
  List<int> mArray = INITIAL_M_FULL_ARRAY;
  bool isPanning;

  @override
  void initState() {
    // Initialize indexes
    dIndex = widget.initialDateTime.day - 1;
    mIndex = widget.initialDateTime.month - 1;
    yFullArray = generateRangeList(<int>[
      (widget.minimumDate is DateTime) ? widget.minimumDate.year : minimumYear,
      (widget.maximumDate is DateTime) ? widget.maximumDate.year : maximumYear,
    ]);
    final int indexOfYear = yFullArray.indexOf(widget.initialDateTime.year);
    yIndex = indexOfYear != -1 ? indexOfYear : 0;

    dayScrollController = FixedExtentScrollController(initialItem: dIndex);
    monthScrollController = FixedExtentScrollController(initialItem: mIndex);
    yearScrollController = FixedExtentScrollController(initialItem: yIndex);

    initialDateTime = widget.initialDateTime is DateTime
        ? widget.initialDateTime
        : DateTime(2000, 1, 1);
    dMin = widget.minimumDate.day - 1;
    mMin = widget.minimumDate.month - 1;

    dMax = widget.maximumDate.day - 1;
    mMax = widget.maximumDate.month - 1;
    yMax = yFullArray.length - 1;

    // Calc greys
    recalculateIndexes();

//		subject = ReplaySubject<int>();
//		subject
//			.throttle(Duration(milliseconds: 500))
//			.listen(updateValues);
    super.initState();
  }

  void recalculateIndexes() {
    dArray = INITIAL_D_FULL_ARRAY;
    mArray = INITIAL_M_FULL_ARRAY;

    if (<int>[4, 6, 9, 11].contains(mIndex + 1)) {
      dArray = greyColourBegin(dArray, 30);
      if (dIndex > 29) {
        dIndex = 29;
      }
    } else {
      if (mIndex + 1 == 2) {
        if (yFullArray[yIndex] % 400 == 0 ||
            (yFullArray[yIndex] % 100 != 0 && yFullArray[yIndex] % 4 == 0)) {
          dArray = greyColourBegin(dArray, 29);
          if (dIndex > 28) {
            dIndex = 27;
          }
        }
      } else {
        dArray = greyColourBegin(dArray, 28);
        if (dIndex > 27) {
          dIndex = 27;
        }
      }
    }
    if (yIndex >= yMax) {
      yIndex = yMax;
      mArray = greyColourBegin(mArray, mMax + 1);
      if (mIndex >= mMax) {
        mIndex = mMax;
        dArray = greyColourBegin(dArray, dMax + 1);
        if (dIndex >= dMax) {
          dIndex = dMax;
        }
      }
    }
    if (yIndex <= yMin) {
      yIndex = yMin;
      mArray = greyColourInclude(mArray, mMin);
      if (mIndex <= mMin) {
        mIndex = mMin;
        dArray = greyColourInclude(dArray, dMin);
        if (dIndex <= dMin) {
          dIndex = dMin;
        }
      }
    }
  }

  void updateValues() {
    recalculateIndexes();
    widget.onDateTimeChanged(
      DateTime(
        yFullArray[yIndex],
        mArray[mIndex],
        dArray[dIndex],
      ).toUtc().millisecondsSinceEpoch,
    );
  }

  Widget buildDayPicker() {
    return Picker(
      animateDuration: 1000,
      controller: dayScrollController,
      index: dIndex,
      onSelectedItemChanged: (dynamic item) {
        setState(() {
          dIndex = dArray.indexOf(item);
          updateValues();
        });
      },
      itemList: dArray,
    );
  }

  Widget buildMonthPicker() {
    return Picker(
      animateDuration: 1000,
      controller: monthScrollController,
      displayFunction: (int value) => MONTHS[value - 1],
      index: mIndex,
      onSelectedItemChanged: (dynamic item) {
        setState(() {
          mIndex = mArray.indexOf(item);
          updateValues();
        });
      },
      itemList: mArray,
    );
  }

  Widget buildYearPicker() {
    return Picker(
      controller: yearScrollController,
      index: yIndex,
      itemList: yFullArray,
      onSelectedItemChanged: (dynamic item) {
        setState(() {
          yIndex = yFullArray.indexOf(item);
          updateValues();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        buildDayPicker(),
        buildMonthPicker(),
        buildYearPicker(),
      ],
    );
  }
}
