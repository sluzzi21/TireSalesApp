import 'package:uuid/uuid.dart';
import 'quote_item.dart';

class QuoteItem {
  final String id;
  final String tireId;
  final int quantity;
  final double price;

  QuoteItem({
    required this.id,
    required this.tireId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tireId': tireId,
      'quantity': quantity,
      'price': price,
    };
  }

  factory QuoteItem.fromMap(Map<String, dynamic> map) {
    return QuoteItem(
      id: map['id'],
      tireId: map['tireId'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}

class Quote {
  final String id;
  final String customerName;
  final String customerPhone;
  final DateTime createdAt;
  final String status; // pending, approved, rejected, converted
  final List<QuoteItem> items;
  bool isConverted;

  Quote({
    String? id,
    required this.customerName,
    required this.customerPhone,
    DateTime? createdAt,
    this.status = 'pending',
    this.items = const [],
    this.isConverted = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  double get total => items.fold(0, (sum, item) => sum + item.price * item.quantity);

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'createdAt': createdAt.toIso8601String(),
        'status': status,
        'items': items.map((item) => item.toMap()).toList(),
        'isConverted': isConverted,
      };

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        id: json['id'],
        customerName: json['customerName'],
        customerPhone: json['customerPhone'],
        createdAt: DateTime.parse(json['createdAt']),
        status: json['status'],
        items: (json['items'] as List)
            .map((item) => QuoteItem.fromMap(item))
            .toList(),
        isConverted: json['isConverted'],
      );

  Quote copyWith({
    String? customerName,
    String? customerPhone,
    String? status,
    List<QuoteItem>? items,
    bool? isConverted,
  }) =>
      Quote(
        id: id,
        customerName: customerName ?? this.customerName,
        customerPhone: customerPhone ?? this.customerPhone,
        createdAt: createdAt,
        status: status ?? this.status,
        items: items ?? this.items,
        isConverted: isConverted ?? this.isConverted,
      );
}
