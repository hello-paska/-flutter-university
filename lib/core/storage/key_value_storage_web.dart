import 'dart:html' as html;
import 'key_value_storage.dart';

class WebKeyValueStorage implements KeyValueStorage {
  @override
  Future<void> write(String key, String value) async {
    html.window.localStorage[key] = value;
  }

  @override
  Future<String?> read(String key) async {
    return html.window.localStorage[key]; 
  }
}
