import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import '../../../typography.dart' show ACTIVE_COLOR, DISABLED_COLOR;
import '../../../utils/type_check.dart' show isNotNull;
import '../../helpers/money_controller.dart' show formatCost;

class PropertyFooter extends StatefulWidget {
  const PropertyFooter(
      {this.isInput,
      this.currency,
      this.costSale,
      this.costRent,
      this.paymentPeriod,
      this.mainInfo,
      this.address});

  final String currency;
  final double costSale;
  final double costRent;
  final String paymentPeriod;
  final String mainInfo;
  final String address;
  final bool isInput;

  @override
  State createState() => PropertyState();
}

class PropertyState extends State<PropertyFooter> {
  static const Color fontColor = Color(0xFF212121);
  TextStyle addInfoStyle;
  TextStyle mainValueStyle;

  Color get color => widget.isInput ? ACTIVE_COLOR : DISABLED_COLOR;

  @override
  void initState() {
    super.initState();
    addInfoStyle = TextStyle(fontSize: 14.0, color: color);
    mainValueStyle =
        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: color);
  }

  Widget buildMainValue(num value, double padding,
      {bool includePaymentPeriod = false}) {
    Widget renderPaymentPeriod() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text('/', style: mainValueStyle),
          Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(widget.paymentPeriod,
                  style: const TextStyle(fontSize: 12.0))),
        ],
      );
    }

    if (value is num) {
      return Padding(
        padding: EdgeInsets.only(bottom: padding),
        child: Row(
          children: <Widget>[
            Text('${widget.currency} ${formatCost(value)}',
                style: mainValueStyle),
            includePaymentPeriod ? renderPaymentPeriod() : null,
          ].where(isNotNull).toList(),
        ),
      );
    }

    return null;
  }

  Widget buildAddInfo(String value, {bool addSeparator = false}) {
    if (value is String) {
      return Row(
        children: <Widget>[
          Text(value, style: addInfoStyle),
          addSeparator
              ? Padding(
                  padding: const EdgeInsets.only(left: 23.0, right: 17.0),
                  child: Text('|', style: addInfoStyle),
                )
              : null,
        ].where(isNotNull).toList(),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 13.0, 16.0, 12.0),
      constraints: const BoxConstraints(
        minHeight: 74
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildMainValue(widget.costSale, 5.0),
          buildMainValue(widget.costRent, 13.0, includePaymentPeriod: true),
          Row(
            children: <Widget>[
              buildAddInfo(widget.mainInfo, addSeparator: true),
              buildAddInfo(widget.address),
            ].where(isNotNull).toList(),
          ),
        ].where(isNotNull).toList(),
      ),
    );
  }
}
