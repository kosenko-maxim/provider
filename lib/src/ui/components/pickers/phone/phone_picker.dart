import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../models/phone/country_phone_data.dart';
import '../../../components/styled/styled_text_field.dart' show StyledTextField;
import 'phone_search.dart';

class PhonePicker extends StatefulWidget {
  const PhonePicker(
      {this.favorites,
        @required this.countryPhoneDataList,
        @required this.onSelected,
        @required this.selectedItem,
        @required this.itemByIp,
        @required this.isValid,
        @required this.phoneController});

  final List<CountryPhoneData> favorites;
  final List<CountryPhoneData> countryPhoneDataList;
  final Function onSelected;
  final CountryPhoneData itemByIp;
  final TextEditingController phoneController;
  final Function isValid;
  final CountryPhoneData selectedItem;

  @override
  _PhonePickerState createState() => _PhonePickerState();
}

class _PhonePickerState extends State<PhonePicker> {
  TextEditingController codeController = TextEditingController();
  CountryPhoneData item;

  @override
  void initState() {
    item = widget.selectedItem;
    codeController.text =
    '+ (${item == null ? _buildDataItem().code.toString() : item.code
        .toString()})';
    widget.phoneController.addListener(_phoneListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (item == null && widget.countryPhoneDataList != null) {
      setState(() {
        print(
            '===> widget.countryPhoneDataList[0]: ${widget
                .countryPhoneDataList[0].countryId}');
        item = _buildDataItem();
      });
    }
    super.didChangeDependencies();
  }

  void _phoneListener() {
    if (widget.onSelected is Function) {
      widget.onSelected(widget.isValid(), item, widget.phoneController.text);
    }
  }

  CountryPhoneData _findItemById(List<CountryPhoneData> list) {
    return list.firstWhere(
            (CountryPhoneData foundItem) =>
        foundItem.countryId == item.countryId,
        orElse: () => null);
  }

  CountryPhoneData _buildDataItem() {
    if (item == null) {
      if (widget.itemByIp == null) {
        return widget.favorites.isNotEmpty
            ? widget.favorites.first
            : widget.countryPhoneDataList.first;
      } else {
        return widget.itemByIp;
      }
    } else {
      final CountryPhoneData favItem = _findItemById(widget.favorites);
      return favItem == null
          ? _findItemById(widget.countryPhoneDataList) == null
          ? item
          : _findItemById(widget.countryPhoneDataList)
          : favItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      InkWell(
        child: Container(
            width: 70.0,
            child: IgnorePointer(
                child: StyledTextField(
                  controller: codeController,
                ))),
        onTap: () async {
          final CountryPhoneData result = await showSearch(
            context: context,
            delegate: CustomSearchDelegate(
                onSelected:
                    (close(BuildContext context, CountryPhoneData item)) {},
                favorites: widget.favorites,
                countryPhoneDataList: widget.countryPhoneDataList),
          );
          setState(() {
            if (result != null) {
              item = result;
              codeController.text = '+ (${item.code.toString()})';
              if (widget.onSelected is Function) {
                widget.onSelected(
                    widget.isValid(), item, widget.phoneController.text);
              }
            }
          });
        },
      ),
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(left: 12.0),
          child: StyledTextField(
            autofocus: true,
            controller: widget.phoneController,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            hintText: _buildDataItem().example.toString(),
            borderColor: widget.isValid()
                ? Theme
                .of(context)
                .primaryColor
                : Colors.redAccent,
            keyboardType: TextInputType.number,
          ),
        ),
      ),
    ]);
  }
}
