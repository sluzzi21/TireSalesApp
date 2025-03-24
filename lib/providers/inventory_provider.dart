import 'package:flutter/material.dart';
import 'package:tire_sales_app/models/tire.dart';
import 'package:tire_sales_app/services/storage_service.dart';

class InventoryProvider with ChangeNotifier {
  final StorageService _storageService;
  List<Tire> _tires = [];
  List<Tire> _filteredTires = [];
  String? _error;
  bool _isLoading = false;
  Map<String, String> _columnFilters = {
    'brand': '',
    'model': '',
    'width': '',
    'ratio': '',
    'diameter': '',
    'category': '',
    'price': '',
    'description': '',
  };

  InventoryProvider(this._storageService) {
    debugPrint('InventoryProvider initialized with StorageService');
    // Load tires immediately when provider is created
    loadTires();
  }

  List<Tire> get tires => _filteredTires.isEmpty ? _tires : _filteredTires;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Get distinct values for picklists
  List<String> get distinctBrands => _getDistinctValues((tire) => tire.brand)..sort();
  List<String> get distinctModels => _getDistinctValues((tire) => tire.model).where((m) => m != null).map((m) => m!).toList()..sort();
  List<String> get distinctWidths => _getDistinctValues((tire) => tire.width)..sort();
  List<String> get distinctRatios => _getDistinctValues((tire) => tire.ratio)..sort();
  List<String> get distinctDiameters => _getDistinctValues((tire) => tire.diameter)..sort();
  List<String> get distinctCategories => _getDistinctValues((tire) => tire.category).where((c) => c != null).map((c) => c!).toList()..sort();
  List<String> get distinctPrices => _getDistinctValues((tire) => tire.price.toString());
  List<String> get distinctDescriptions => _getDistinctValues((tire) => tire.description).where((d) => d != null).map((d) => d!).toList()..sort();

  List<String> getDistinctModelsForBrand(String? brand) {
    if (brand == null) return [];
    return _tires
        .where((tire) => tire.brand == brand)
        .map((tire) => tire.model)
        .where((model) => model != null)
        .map((model) => model!)
        .toSet()
        .toList()
        ..sort();
  }

  List<T> _getDistinctValues<T>(T Function(Tire) getValue) {
    return _tires
        .map(getValue)
        .where((value) => value != null)
        .toSet()
        .toList();
  }

  // Get filtered values for cascading picklists

  void updateColumnFilter(String column, String value) {
    _columnFilters[column] = value;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredTires = _tires.where((tire) {
      return _matchesFilters(tire);
    }).toList();
  }

  bool _matchesFilters(Tire tire) {
    // Helper function to check if a value matches a filter
    bool matchesFilter(String? value, String filter) {
      if (filter.isEmpty) return true;
      if (value == null) return false;
      return value.toLowerCase().contains(filter.toLowerCase());
    }

    // Check each column filter
    if (!matchesFilter(tire.brand, _columnFilters['brand']!)) return false;
    if (!matchesFilter(tire.model, _columnFilters['model']!)) return false;
    if (!matchesFilter(tire.width, _columnFilters['width']!)) return false;
    if (!matchesFilter(tire.ratio, _columnFilters['ratio']!)) return false;
    if (!matchesFilter(tire.diameter, _columnFilters['diameter']!)) return false;
    if (!matchesFilter(tire.category, _columnFilters['category']!)) return false;
    if (!matchesFilter(tire.price.toString(), _columnFilters['price']!)) return false;
    if (!matchesFilter(tire.description, _columnFilters['description']!)) return false;

    return true;
  }

  void searchTires(String query) {
    if (query.isEmpty) {
      _filteredTires = _tires;
    } else {
      final searchStr = query.toLowerCase();
      _filteredTires = _tires.where((tire) {
        return matchesSearch(tire, searchStr);
      }).toList();
    }
    notifyListeners();
  }

  bool matchesSearch(Tire tire, String searchStr) {
    return tire.brand.toLowerCase().contains(searchStr) ||
           (tire.model?.toLowerCase() ?? '').contains(searchStr) ||
           tire.width.toLowerCase().contains(searchStr) ||
           tire.ratio.toLowerCase().contains(searchStr) ||
           tire.diameter.toLowerCase().contains(searchStr) ||
           (tire.category?.toLowerCase() ?? '').contains(searchStr) ||
           (tire.description?.toLowerCase() ?? '').contains(searchStr) ||
           (tire.price?.toString() ?? '').contains(searchStr);
  }

  Future<void> loadTires() async {
    debugPrint('Loading tires from storage');
    _error = null;
    _isLoading = true;
    notifyListeners();

    try {
      _tires = await _storageService.loadTires();
      debugPrint('Successfully loaded ${_tires.length} tires');
      debugPrint('First tire: ${_tires.isNotEmpty ? _tires.first.toString() : "No tires"}');
      _filteredTires = _tires;
      _error = null;
    } catch (e) {
      debugPrint('Error loading tires: $e');
      _error = 'Failed to load tires: $e';
      _tires = [];
      _filteredTires = [];
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint('Finished loading tires. Loading: $_isLoading, Error: $_error, Tires count: ${_tires.length}');
    }
  }

  Future<void> addTire(Tire tire) async {
    debugPrint('Adding new tire: ${tire.id}');
    try {
      await _storageService.addTire(tire);
      await loadTires();
    } catch (e) {
      debugPrint('Error adding tire: $e');
      _error = 'Failed to add tire: $e';
      notifyListeners();
    }
  }

  Future<void> updateTire(Tire tire) async {
    debugPrint('Updating tire: ${tire.id}');
    try {
      await _storageService.updateTire(tire);
      await loadTires();
    } catch (e) {
      debugPrint('Error updating tire: $e');
      _error = 'Failed to update tire: $e';
      notifyListeners();
    }
  }

  Future<void> deleteTire(String id) async {
    debugPrint('Deleting tire: $id');
    try {
      await _storageService.deleteTire(id);
      await loadTires();
    } catch (e) {
      debugPrint('Error deleting tire: $e');
      _error = 'Failed to delete tire: $e';
      notifyListeners();
    }
  }
}
