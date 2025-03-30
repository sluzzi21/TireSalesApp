import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import '../models/service.dart';
import 'package:uuid/uuid.dart';

class ServicesProvider with ChangeNotifier {
  List<Service> _services = [];
  final String _storageKey = 'services';

  List<Service> get services => [..._services];

  ServicesProvider() {
    _loadServices();
  }

  void _loadServices() {
    final storage = html.window.localStorage[_storageKey];
    if (storage != null) {
      final List<dynamic> jsonData = json.decode(storage);
      _services = jsonData.map((item) => Service.fromJson(item)).toList();
      notifyListeners();
    }
  }

  void _saveServices() {
    final jsonData = _services.map((service) => service.toJson()).toList();
    html.window.localStorage[_storageKey] = json.encode(jsonData);
  }

  void addService(String name, String description, double price) {
    final service = Service(
      id: const Uuid().v4(),
      name: name,
      description: description,
      price: price,
    );
    _services.add(service);
    _saveServices();
    notifyListeners();
  }

  void updateService(Service service) {
    final index = _services.indexWhere((s) => s.id == service.id);
    if (index >= 0) {
      _services[index] = service;
      _saveServices();
      notifyListeners();
    }
  }

  void deleteService(String id) {
    _services.removeWhere((service) => service.id == id);
    _saveServices();
    notifyListeners();
  }

  Service? getServiceById(String id) {
    try {
      return _services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }
}
