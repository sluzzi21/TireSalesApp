import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tire_sales_app/models/tire.dart';
import 'package:tire_sales_app/services/storage_service.dart';

class InventoryProvider extends ChangeNotifier {
  final StorageService _storageService;
  List<Tire> _tires = [];
  List<Tire> _filteredTires = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  InventoryProvider(this._storageService) {
    debugPrint('InventoryProvider initialized with StorageService');
    // Load tires immediately when provider is created
    loadTires();
  }

  List<Tire> get tires => _filteredTires.isEmpty && _searchQuery.isEmpty ? _tires : _filteredTires;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTires() async {
    debugPrint('Loading tires from storage');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tires = await _storageService.loadTires();
      debugPrint('Successfully loaded ${_tires.length} tires');
      debugPrint('First tire: ${_tires.isNotEmpty ? _tires.first.toString() : "No tires"}');
      _updateFilteredTires();
    } catch (e) {
      _error = 'Failed to load tires: $e';
      debugPrint('Error loading tires: $e');
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
      _tires.add(tire);
      debugPrint('Successfully added tire: ${tire.id}');
      _updateFilteredTires();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add tire: $e';
      debugPrint('Error adding tire: $e');
      throw Exception(_error);
    }
  }

  Future<void> updateTire(Tire tire) async {
    debugPrint('Updating tire: ${tire.id}');
    try {
      await _storageService.updateTire(tire);
      final index = _tires.indexWhere((t) => t.id == tire.id);
      if (index != -1) {
        _tires[index] = tire;
        debugPrint('Successfully updated tire: ${tire.id}');
        _updateFilteredTires();
        notifyListeners();
      } else {
        throw Exception('Tire not found: ${tire.id}');
      }
    } catch (e) {
      _error = 'Failed to update tire: $e';
      debugPrint('Error updating tire: $e');
      throw Exception(_error);
    }
  }

  Future<void> deleteTire(String id) async {
    debugPrint('Deleting tire: $id');
    try {
      await _storageService.deleteTire(id);
      _tires.removeWhere((tire) => tire.id == id);
      debugPrint('Successfully deleted tire: $id');
      _updateFilteredTires();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete tire: $e';
      debugPrint('Error deleting tire: $e');
      throw Exception(_error);
    }
  }

  void searchTires(String query) {
    debugPrint('Searching tires with query: $query');
    _searchQuery = query.toLowerCase();
    _updateFilteredTires();
  }

  void _updateFilteredTires() {
    if (_searchQuery.isEmpty) {
      debugPrint('Search query empty, showing all ${_tires.length} tires');
      _filteredTires = [];
    } else {
      _filteredTires = _tires.where((tire) {
        final brand = tire.brand.toLowerCase();
        final model = tire.model.toLowerCase();
        final width = tire.width.toLowerCase();
        final ratio = tire.ratio.toLowerCase();
        final diameter = tire.diameter.toLowerCase();
        final category = tire.category.toLowerCase();
        final description = tire.description.toLowerCase();
        return brand.contains(_searchQuery) ||
               model.contains(_searchQuery) ||
               width.contains(_searchQuery) ||
               ratio.contains(_searchQuery) ||
               diameter.contains(_searchQuery) ||
               category.contains(_searchQuery) ||
               description.contains(_searchQuery);
      }).toList();
      debugPrint('Found ${_filteredTires.length} tires matching query: $_searchQuery');
    }
    notifyListeners();
  }
}
