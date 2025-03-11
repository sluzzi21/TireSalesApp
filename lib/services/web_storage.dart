import 'dart:html' as html;

class WebStorage {
  static final WebStorage _instance = WebStorage._internal();
  factory WebStorage() => _instance;
  WebStorage._internal();

  final _storage = html.window.localStorage;

  String? operator [](String key) => _storage[key];
  void operator []=(String key, String value) => _storage[key] = value;
  void remove(String key) => _storage.remove(key);
  void clear() => _storage.clear();
}
