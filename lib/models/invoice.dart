import 'package:uuid/uuid.dart';
import 'quote.dart';

class Invoice {
  final String id;
  final String quoteId;
  final String customerName;
  final String customerPhone;
  final DateTime createdAt;
  final DateTime dueDate;
  final bool isPaid;
  final List<QuoteItem> items;

  Invoice({
    required this.id,
    required this.quoteId,
    required this.customerName,
    required this.customerPhone,
    required this.createdAt,
    required this.dueDate,
    this.isPaid = false,
    required this.items,
  });

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quoteId': quoteId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'isPaid': isPaid ? 1 : 0,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      quoteId: map['quoteId'],
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
      createdAt: DateTime.parse(map['createdAt']),
      dueDate: DateTime.parse(map['dueDate']),
      isPaid: map['isPaid'] == 1,
      items: [], // Items need to be loaded from the quote_items table
    );
  }

  factory Invoice.fromQuote(Quote quote, {required DateTime dueDate}) {
    return Invoice(
      id: const Uuid().v4(),
      quoteId: quote.id,
      customerName: quote.customerName,
      customerPhone: quote.customerPhone,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      items: quote.items,
    );
  }
}
