import 'component_model.dart' show ComponentModel;
import 'helpers/parse_money_value.dart' show parseMoneyValue;

class ItemModel extends ComponentModel {
  ItemModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _key = json['key'],
        _picture = json['picture'],
        _isTransition = json['isTransition'],
        _isInput = json['isInput'],
        _typeValue = json['typeValue'],
        _value = json['value'],
        _min = json['min'],
        _max = json['max'],
        _list = json['list'],
        super.fromJson(json['component']);

  String _id;
  String _key;
  String _picture;
  bool _isTransition;
  bool _isInput;
  String _typeValue;
  dynamic _value;
  List<dynamic> _list;

  // date specific props
  int _min;
  int _max;

  String get id => _id;

  String get key => _key;

  String get picture => _picture;

  bool get isTransition => _isTransition;

  bool get isInput => _isInput;

  String get typeValue => _typeValue;

  List<dynamic> get list => _list;

  dynamic get value {
    return (typeValue == 'money') ? parseMoneyValue(_value) : _value;
  }

  set value(Object value) {
    if (value is bool) {
      _value = value;
    }
  }

  // date specific props
  int get min => _min;

  int get max => _max;
}
