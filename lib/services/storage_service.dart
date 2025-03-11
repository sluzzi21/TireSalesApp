import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tire_sales_app/models/tire.dart';
import 'package:universal_html/html.dart' as html;

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
    } catch (e) {
      debugPrint('Error initializing localStorage: $e');
      throw Exception('Failed to initialize storage service');
    }
  }

  Future<List<Tire>> loadTires() async {
    try {
      final tiresJson = _storage[_tiresKey];
      debugPrint('Loading tires from storage: $tiresJson');
      
      if (tiresJson == null || tiresJson.isEmpty) {
        return [];
      }

      final List<dynamic> tiresList = jsonDecode(tiresJson);
      return tiresList.map((json) => Tire.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading tires: $e');
      return [];
    }
  }

  Future<void> saveTires(List<Tire> tires) async {
    try {
      final tiresJson = jsonEncode(tires.map((tire) => tire.toJson()).toList());
      _storage[_tiresKey] = tiresJson;
      debugPrint('Saved tires to storage: $tiresJson');
    } catch (e) {
      debugPrint('Error saving tires: $e');
      throw Exception('Failed to save tires: $e');
    }
  }

  Future<void> addTire(Tire tire) async {
    try {
      final tires = await loadTires();
      tires.add(tire);
      await saveTires(tires);
      debugPrint('Added tire: ${tire.id}');
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
        debugPrint('Updated tire: ${tire.id}');
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
      final initialLength = tires.length;
      tires.removeWhere((tire) => tire.id == id);
      
      if (tires.length == initialLength) {
        throw Exception('Tire not found: $id');
      }
      
      await saveTires(tires);
      debugPrint('Deleted tire: $id');
    } catch (e) {
      debugPrint('Error deleting tire: $e');
      throw Exception('Failed to delete tire: $e');
    }
  }
}
