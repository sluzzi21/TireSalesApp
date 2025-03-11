import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../models/tire.dart';
import '../models/quote.dart';
import '../models/invoice.dart';
import 'web_storage.dart' if (dart.library.io) 'mock_storage.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor() {
    if (kIsWeb) {
      _storage = WebStorage();
      // Clear storage on initialization
      _storage.clear();
      developer.log('Storage cleared on initialization');
    }
  }
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Storage keys
  static const String _tiresKey = 'tires';
  static const String _quotesKey = 'quotes';
  static const String _invoicesKey = 'invoices';

  // Storage instance
  dynamic _storage;

  // Tire operations
  Future<void> insertTire(Tire tire) async {
    try {
      final tires = await getAllTires();
      tires.add(tire);
      final tiresJson = jsonEncode(tires.map((t) => t.toMap()).toList());
      if (_storage != null) {
        _storage[_tiresKey] = tiresJson;
      }
      developer.log('Inserted tire: ${tire.id}');
    } catch (e) {
      developer.log('Error inserting tire: $e');
      rethrow;
    }
  }

  Future<List<Tire>> getAllTires() async {
    try {
      if (_storage == null) {
        return [];
      }
      
      final tiresJson = _storage[_tiresKey];
      if (tiresJson == null) {
        developer.log('No tires found in storage');
        return [];
      }
      
      final List<dynamic> tiresList = jsonDecode(tiresJson);
      final tires = tiresList.map((json) => Tire.fromMap(json)).toList();
      developer.log('Retrieved ${tires.length} tires from storage');
      return tires;
    } catch (e) {
      developer.log('Error getting tires: $e');
      return [];
    }
  }

  Future<void> updateTire(Tire tire) async {
    try {
      final tires = await getAllTires();
      final index = tires.indexWhere((t) => t.id == tire.id);
      if (index != -1) {
        tires[index] = tire;
        final tiresJson = jsonEncode(tires.map((t) => t.toMap()).toList());
        if (_storage != null) {
          _storage[_tiresKey] = tiresJson;
        }
        developer.log('Updated tire: ${tire.id}');
      }
    } catch (e) {
      developer.log('Error updating tire: $e');
      rethrow;
    }
  }

  Future<void> deleteTire(String id) async {
    try {
      final tires = await getAllTires();
      tires.removeWhere((t) => t.id == id);
      final tiresJson = jsonEncode(tires.map((t) => t.toMap()).toList());
      if (_storage != null) {
        _storage[_tiresKey] = tiresJson;
      }
      developer.log('Deleted tire: $id');
    } catch (e) {
      developer.log('Error deleting tire: $e');
      rethrow;
    }
  }

  // Quote operations
  Future<void> insertQuote(Quote quote) async {
    try {
      final quotes = await getAllQuotes();
      quotes.add(quote);
      final quotesJson = jsonEncode(quotes.map((q) => q.toMap()).toList());
      if (_storage != null) {
        _storage[_quotesKey] = quotesJson;
      }
      developer.log('Inserted quote: ${quote.id}');
    } catch (e) {
      developer.log('Error inserting quote: $e');
      rethrow;
    }
  }

  Future<List<Quote>> getAllQuotes() async {
    try {
      if (_storage == null) {
        return [];
      }
      
      final quotesJson = _storage[_quotesKey];
      if (quotesJson == null) {
        developer.log('No quotes found in storage');
        return [];
      }
      
      final List<dynamic> quotesList = jsonDecode(quotesJson);
      final quotes = quotesList.map((json) => Quote.fromMap(json)).toList();
      developer.log('Retrieved ${quotes.length} quotes from storage');
      return quotes;
    } catch (e) {
      developer.log('Error getting quotes: $e');
      return [];
    }
  }

  Future<void> updateQuote(Quote quote) async {
    try {
      final quotes = await getAllQuotes();
      final index = quotes.indexWhere((q) => q.id == quote.id);
      if (index != -1) {
        quotes[index] = quote;
        final quotesJson = jsonEncode(quotes.map((q) => q.toMap()).toList());
        if (_storage != null) {
          _storage[_quotesKey] = quotesJson;
        }
        developer.log('Updated quote: ${quote.id}');
      }
    } catch (e) {
      developer.log('Error updating quote: $e');
      rethrow;
    }
  }

  Future<void> deleteQuote(String id) async {
    try {
      final quotes = await getAllQuotes();
      quotes.removeWhere((q) => q.id == id);
      final quotesJson = jsonEncode(quotes.map((q) => q.toMap()).toList());
      if (_storage != null) {
        _storage[_quotesKey] = quotesJson;
      }
      developer.log('Deleted quote: $id');
    } catch (e) {
      developer.log('Error deleting quote: $e');
      rethrow;
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    try {
      if (_storage != null) {
        _storage.clear();
        developer.log('Cleared all data from storage');
      }
    } catch (e) {
      developer.log('Error clearing data: $e');
      rethrow;
    }
  }
}
