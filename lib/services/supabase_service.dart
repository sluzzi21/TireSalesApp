import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/tire.dart';

class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient _client;
  bool _isInitialized = false;

  // Private constructor
  SupabaseService._();

  // Singleton instance
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  bool get isInitialized => _isInitialized;

  /// Initialize Supabase client
  Future<void> initialize() async {
    if (_isInitialized) {
      _client = Supabase.instance.client;
      return;
    }

    try {
      bool alreadyInitialized = false;
      try {
        Supabase.instance;
        alreadyInitialized = true;
      } catch (_) {}

      if (!alreadyInitialized) {
        await Supabase.initialize(
          url: SupabaseConfig.url,
          anonKey: SupabaseConfig.anonKey,
        );
      }
      
      _client = Supabase.instance.client;
      _isInitialized = true;
    } catch (e) {
      print('Error initializing Supabase: $e');
      rethrow;
    }
  }

  /// Get all tires
  Future<List<Tire>> getTires() async {
    try {
      final response = await _client
          .from('tires')
          .select();

      return (response as List)
          .map((json) => Tire.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      print('Error fetching tires: $e');
      rethrow;
    }
  }

  /// Get a single tire by ID
  Future<Tire?> getTireById(String id) async {
    try {
      final response = await _client
          .from('tires')
          .select()
          .eq('id', id)
          .single();

      if (response == null) return null;
      return Tire.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      print('Error fetching tire by ID: $e');
      rethrow;
    }
  }

  /// Add a new tire
  Future<Tire> addTire(Tire tire) async {
    try {
      // Log the tire data being sent
      print('Attempting to add tire with data:');
      print(tire.toJson());

      final response = await _client
          .from('tires')
          .insert(tire.toSupabaseJson())
          .select()
          .single();

      print('Received response:');
      print(response);

      return Tire.fromJson(Map<String, dynamic>.from(response));
    } catch (e, stackTrace) {
      print('Error adding tire: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Update an existing tire
  Future<Tire> updateTire(Tire tire) async {
    try {
      final response = await _client
          .from('tires')
          .update(tire.toSupabaseJson())
          .eq('id', tire.id)
          .select()
          .single();

      return Tire.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      print('Error updating tire: $e');
      rethrow;
    }
  }

  /// Delete a tire
  Future<void> deleteTire(String id) async {
    try {
      await _client
          .from('tires')
          .delete()
          .eq('id', id);
    } catch (e) {
      print('Error deleting tire: $e');
      rethrow;
    }
  }

  /// Search tires with filters
  Future<List<Tire>> searchTires({
    String? brand,
    String? model,
    String? width,
    String? ratio,
    String? diameter,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      var query = _client
          .from('tires')
          .select();

      if (brand != null) {
        query = query.ilike('brand', '%$brand%');
      }
      if (model != null) {
        query = query.ilike('model', '%$model%');
      }
      if (width != null) {
        query = query.eq('width', width);
      }
      if (ratio != null) {
        query = query.eq('ratio', ratio);
      }
      if (diameter != null) {
        query = query.eq('diameter', diameter);
      }
      if (category != null) {
        query = query.eq('category', category);
      }
      if (minPrice != null) {
        query = query.gte('price', minPrice);
      }
      if (maxPrice != null) {
        query = query.lte('price', maxPrice);
      }

      final response = await query;

      return (response as List)
          .map((json) => Tire.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      print('Error searching tires: $e');
      rethrow;
    }
  }

  /// Get distinct values for a column
  Future<List<String>> getDistinctValues(String column) async {
    try {
      final response = await _client
          .from('tires')
          .select(column)
          .not(column, 'is', null);

      return (response as List)
          .map((json) => json[column].toString())
          .toSet() // Remove duplicates
          .toList()
        ..sort(); // Sort alphabetically
    } catch (e) {
      print('Error getting distinct values: $e');
      rethrow;
    }
  }
}
