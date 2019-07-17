import '../../../models/screen/components/component_model.dart'
    show ComponentModel;
import 'helpers/parse_money_value.dart' show parseMoneyValue;

class PropertyModel extends ComponentModel {
  PropertyModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _picture = json['picture'],
        _statusValue = json['statusValue'],
        _statusColor = json['statusColor'],
        _currency = json['currency'],
        _costSale = json['costSale'],
        _costRent = json['costRent'],
        _paymentPeriod = json['paymentPeriod'],
        _mainInfo = json['mainInfo'],
        _address = json['address'],
        _isTransition =
            json['isTransition'] != null ? json['isTransition'] : false,
        _isInput = json['isInput'] != null ? json['isInput'] : false,
        super.fromJson(json['component']);

  String _id;
  String _picture;
  String _statusValue;
  String _statusColor;
  String _currency;
  int _costSale;
  int _costRent;
  String _paymentPeriod;
  String _mainInfo;
  String _address;
  bool _isTransition;
  bool _isInput;

  String get id => _id;

  String get picture => _picture;

  String get statusValue => _statusValue;

  String get statusColor => _statusColor;

  String get currency => _currency;

  double get costSale => parseMoneyValue(_costSale);

  double get costRent => parseMoneyValue(_costRent);

  String get paymentPeriod => _paymentPeriod;

  String get mainInfo => _mainInfo;

  String get address => _address;

  bool get isTransition => _isTransition;

  bool get isInput => _isInput;
}
