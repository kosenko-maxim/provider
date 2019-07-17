import 'components/button_model.dart' show ButtonModel;
import 'components/item_model.dart' show ItemModel;
import 'components/note_model.dart' show NoteModel;
import 'components/property_model.dart' show PropertyModel;

class ScreenModel {
  ScreenModel.fromJson(Map<String, dynamic> json) {
    _path = json['path'];
    _value = json['value'];
    _components = json['components'] is List
        ? json['components'].map((dynamic component) {
            switch (component['component']) {
              case 'button':
                return ButtonModel.fromJson(component);
              case 'item':
                return ItemModel.fromJson(component);
              case 'note':
                return NoteModel.fromJson(component);
              case 'property':
                return PropertyModel.fromJson(component);
              default:
                return null;
            }
          }).toList()
        : <dynamic>[];
  }
  String _path;
  String _value;
  List<dynamic> _components;

  String get path => _path;
  String get value => _value;
  List<dynamic> get components => _components;
}
