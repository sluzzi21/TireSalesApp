import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tire_sales_app/models/tire.dart';
import 'dart:html' as html;

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal() {
    _initializeStorage();
  }

  static const String _tiresKey = 'tires';
  late final html.Storage _storage;

  void _initializeStorage() {
    try {
      _storage = html.window.localStorage;
      debugPrint('LocalStorage initialized successfully');
      // Debug: Print all storage keys
      debugPrint('Current localStorage keys: ${_storage.keys.join(', ')}');
      // Debug: Check if tires key exists
      debugPrint('Tires key exists: ${_storage.containsKey(_tiresKey)}');
      if (_storage.containsKey(_tiresKey)) {
        debugPrint('Current tires value: ${_storage[_tiresKey]}');
      }
    } catch (e) {
      debugPrint('Error initializing localStorage: $e');
      throw Exception('Failed to initialize storage service');
    }
  }

  Future<List<Tire>> loadTires() async {
    try {
      debugPrint('Loading tires from storage');
      final tiresJson = _storage[_tiresKey];
      debugPrint('Raw tires data from storage: $tiresJson');
      
      if (tiresJson == null || tiresJson.isEmpty) {
        debugPrint('No tires found in storage');
        return [];
      }

      try {
        final List<dynamic> tiresList = jsonDecode(tiresJson);
        debugPrint('Successfully parsed JSON. Found ${tiresList.length} tires');
        debugPrint('First tire data: ${tiresList.isNotEmpty ? jsonEncode(tiresList.first) : "none"}');
        
        final tires = tiresList.map((json) {
          try {
            return Tire.fromJson(json);
          } catch (e) {
            debugPrint('Error parsing tire: $e');
            debugPrint('Problematic tire data: ${jsonEncode(json)}');
            rethrow;
          }
        }).toList();
        
        debugPrint('Successfully converted ${tires.length} tires');
        debugPrint('First tire object: ${tires.isNotEmpty ? tires.first.toString() : "none"}');
        return tires;
      } catch (e) {
        debugPrint('Error parsing tires JSON: $e');
        rethrow;
      }
    } catch (e) {
      debugPrint('Error loading tires: $e');
      return [];
    }
  }

  Future<void> saveTires(List<Tire> tires) async {
    try {
      debugPrint('Saving ${tires.length} tires to storage');
      final tiresJson = jsonEncode(tires.map((tire) => tire.toJson()).toList());
      debugPrint('Encoded tires JSON: $tiresJson');
      _storage[_tiresKey] = tiresJson;
      debugPrint('Successfully saved tires to storage');
      
      // Verify save
      final savedJson = _storage[_tiresKey];
      debugPrint('Verification - Read back from storage: $savedJson');
    } catch (e) {
      debugPrint('Error saving tires: $e');
      throw Exception('Failed to save tires: $e');
    }
  }

  Future<void> addTire(Tire tire) async {
    try {
      debugPrint('Adding new tire: ${tire.toString()}');
      final tires = await loadTires();
      tires.add(tire);
      await saveTires(tires);
      debugPrint('Successfully added tire: ${tire.id}');
    } catch (e) {
      debugPrint('Error adding tire: $e');
      throw Exception('Failed to add tire: $e');
    }
  }

  Future<void> updateTire(Tire tire) async {
    try {
      debugPrint('Updating tire: ${tire.toString()}');
      final tires = await loadTires();
      final index = tires.indexWhere((t) => t.id == tire.id);
      if (index != -1) {
        tires[index] = tire;
        await saveTires(tires);
        debugPrint('Successfully updated tire: ${tire.id}');
      } else {
        throw Exception('Tire not found: ${tire.id}');
      }
    } catch (e) {
      debugPrint('Error updating tire: $e');
      throw Exception('Failed to update tire: $e');
    }
  }

  Future<void> deleteTire(String id) async {
    try {
      debugPrint('Deleting tire: $id');
      final tires = await loadTires();
      final initialLength = tires.length;
      tires.removeWhere((tire) => tire.id == id);
      
      if (tires.length == initialLength) {
        throw Exception('Tire not found: $id');
      }
      
      await saveTires(tires);
      debugPrint('Successfully deleted tire: $id');
    } catch (e) {
      debugPrint('Error deleting tire: $e');
      throw Exception('Failed to delete tire: $e');
    }
  }
}
