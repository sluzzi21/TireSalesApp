import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import '../models/quote.dart';
import '../models/quote_item.dart';
import '../models/tire.dart';
import '../models/service.dart';

class QuoteProvider with ChangeNotifier {
  Quote? _currentQuote;
  List<Quote> _quotes = [];
  final String _storageKey = 'quotes';

  Quote? get currentQuote => _currentQuote;
  List<Quote> get quotes => [..._quotes];

  QuoteProvider() {
    _loadQuotes();
  }

  void _loadQuotes() {
    final storage = html.window.localStorage[_storageKey];
    if (storage != null) {
      final List<dynamic> jsonData = json.decode(storage);
      _quotes = jsonData.map((item) => Quote.fromJson(item)).toList();
      notifyListeners();
    }
  }

  void _saveQuotes() {
    final jsonData = _quotes.map((quote) => quote.toJson()).toList();
    html.window.localStorage[_storageKey] = json.encode(jsonData);
  }

  void createNewQuote(String customerName, String customerPhone) {
    _currentQuote = Quote(
      customerName: customerName,
      customerPhone: customerPhone,
    );
    notifyListeners();
  }

  void addTireToQuote(Tire tire, int quantity) {
    if (_currentQuote == null) return;

    final quoteItem = QuoteItem(
      type: QuoteItemType.tire,
      item: tire,
      quantity: quantity,
    );

    final items = List<QuoteItem>.from(_currentQuote!.items)..add(quoteItem);
    _currentQuote = _currentQuote!.copyWith(items: items);
    notifyListeners();
  }

  void addServiceToQuote(Service service, int quantity) {
    if (_currentQuote == null) return;

    final quoteItem = QuoteItem(
      type: QuoteItemType.service,
      item: service,
      quantity: quantity,
    );

    final items = List<QuoteItem>.from(_currentQuote!.items)..add(quoteItem);
    _currentQuote = _currentQuote!.copyWith(items: items);
    notifyListeners();
  }

  void removeItemFromQuote(String itemId) {
    if (_currentQuote == null) return;

    final items = _currentQuote!.items
        .where((item) => item.id != itemId)
        .toList();
    _currentQuote = _currentQuote!.copyWith(items: items);
    notifyListeners();
  }

  void saveQuote() {
    if (_currentQuote == null) return;

    final existingIndex = _quotes.indexWhere((q) => q.id == _currentQuote!.id);
    if (existingIndex >= 0) {
      _quotes[existingIndex] = _currentQuote!;
    } else {
      _quotes.add(_currentQuote!);
    }
    _saveQuotes();
    notifyListeners();
  }

  void clearCurrentQuote() {
    _currentQuote = null;
    notifyListeners();
  }

  void updateQuoteStatus(String quoteId, String status) {
    final index = _quotes.indexWhere((q) => q.id == quoteId);
    if (index >= 0) {
      _quotes[index] = _quotes[index].copyWith(status: status);
      _saveQuotes();
      notifyListeners();
    }
  }
}
