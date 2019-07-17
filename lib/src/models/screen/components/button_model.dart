import 'component_model.dart';

class ButtonModel extends ComponentModel {
  ButtonModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _key = json['key'],
        _isAble = json['isAble'],
        _value = json['value'],
        _typeQuery = json['typeQuery'],
        _color = json['color'],
        super.fromJson(json['component']);

  String _id;
  String _key;
  bool _isAble;
  dynamic _value;
  String _typeQuery;
  String _color;

  String get id => _id;

  String get key => _key;

  bool get isAble => _isAble;

  dynamic get value => _value;

  String get typeQuery => _typeQuery;

  String get color => _color;
}
