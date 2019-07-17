import 'package:flutter/material.dart';

class NumberOnlyTextEditingController extends TextEditingController {
  NumberOnlyTextEditingController() {
    addListener(() {
      String numberText = '';
      for (String number in text.split('')) {
        if (RegExp('[0-9]').hasMatch(number)) {
          numberText += number;
        }
      }
      value = value.copyWith(
        text: numberText,
        selection: TextSelection(
            baseOffset: numberText.length, extentOffset: numberText.length),
        composing: TextRange.empty,
      );
    });
  }
}
