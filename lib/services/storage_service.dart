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
      // Clear storage on initialization for testing
      _storage.clear();
      debugPrint('LocalStorage cleared');
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
      _storage[_tiresKey] = tiresJson;
      debugPrint('Successfully saved tires to storage');
    } catch (e) {
      debugPrint('Error saving tires: $e');
      throw Exception('Failed to save tires: $e');
    }
  }

  Future<void> addTire(Tire tire) async {
    try {
      debugPrint('Adding new tire: ${tire.toString()}');
      final tires = await loadTires();
      if (!tires.any((t) => t.id == tire.id)) {
        tires.add(tire);
        await saveTires(tires);
        debugPrint('Successfully added tire: ${tire.id}');
      } else {
        debugPrint('Tire with ID ${tire.id} already exists, skipping');
      }
    } catch (e) {
      debugPrint('Error adding tire: $e');
      throw Exception('Failed to add tire: $e');
    }
  }

  Future<void> updateTire(Tire tire) async {
    try {
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
      final tires = await loadTires();
      tires.removeWhere((t) => t.id == id);
      await saveTires(tires);
      debugPrint('Successfully deleted tire: $id');
    } catch (e) {
      debugPrint('Error deleting tire: $e');
      throw Exception('Failed to delete tire: $e');
    }
  }
}
