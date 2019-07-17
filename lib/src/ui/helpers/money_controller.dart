import 'package:flutter_masked_text/flutter_masked_text.dart';

// ignore: always_specify_types
MoneyMaskedTextController createMoneyController(initialValue,
    // ignore: always_specify_types
    {defaultValue = '0.00'}) {
  final MoneyMaskedTextController _moneyController = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ' ',
  );

  _moneyController.text =
      initialValue != null ? (initialValue * 10).toString() : defaultValue;

  return _moneyController;
}

String formatCost(num cost) {
  if (cost == null) {
    return null;
  }

  final MoneyMaskedTextController _controller =
      createMoneyController(cost, defaultValue: null);
  return _controller.text;
}
