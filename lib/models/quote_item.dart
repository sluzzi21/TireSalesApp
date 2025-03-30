import 'package:uuid/uuid.dart';
import 'tire.dart';
import 'service.dart';

enum QuoteItemType { tire, service }

class QuoteItem {
  final String id;
  final QuoteItemType type;
  final dynamic item; // Either Tire or Service
  final int quantity;

  QuoteItem({
    String? id,
    required this.type,
    required this.item,
    required this.quantity,
  }) : id = id ?? const Uuid().v4();

  double get totalPrice {
    if (type == QuoteItemType.tire) {
      return (item as Tire).price * quantity;
    } else {
      return (item as Service).price * quantity;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.toString(),
        'item': item.toJson(),
        'quantity': quantity,
      };

  factory QuoteItem.fromJson(Map<String, dynamic> json) {
    final type = QuoteItemType.values.firstWhere(
        (e) => e.toString() == json['type']);
    final item = type == QuoteItemType.tire
        ? Tire.fromJson(json['item'])
        : Service.fromJson(json['item']);
    
    return QuoteItem(
      id: json['id'],
      type: type,
      item: item,
      quantity: json['quantity'],
    );
  }
}
