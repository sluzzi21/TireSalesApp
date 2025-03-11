import 'dart:convert';
import 'package:uuid/uuid.dart';

class Tire {
  final String id;
  final String brand;
  final String model;
  final String width;      // e.g., "225"
  final String ratio;      // e.g., "45"
  final String diameter;   // e.g., "17"
  final double price;
  final int quantity;
  final String category;
  final String description;

  Tire({
    String? id,
    required this.brand,
    required this.model,
    required this.width,
    required this.ratio,
    required this.diameter,
    required this.price,
    required this.quantity,
    required this.category,
    required this.description,
  }) : id = id ?? const Uuid().v4();

  String get size => '$width/${ratio}R$diameter';

  factory Tire.fromJson(Map<String, dynamic> json) {
    // Handle both new and old format
    if (json.containsKey('width')) {
      return Tire(
        id: json['id'] as String,
        brand: json['brand'] as String,
        model: json['model'] as String,
        width: json['width'] as String,
        ratio: json['ratio'] as String,
        diameter: json['diameter'] as String,
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'] as int,
        category: json['category'] as String,
        description: json['description'] as String,
      );
    } else {
      // Convert old format (single size field) to new format
      final size = json['size'] as String;
      final parts = size.split('/');
      final width = parts[0];
      final ratioParts = parts[1].split('R');
      final ratio = ratioParts[0];
      final diameter = ratioParts[1];

      return Tire(
        id: json['id'] as String,
        brand: json['brand'] as String,
        model: json['model'] as String,
        width: width,
        ratio: ratio,
        diameter: diameter,
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'] as int,
        category: json['category'] as String,
        description: json['description'] as String,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'width': width,
      'ratio': ratio,
      'diameter': diameter,
      'price': price,
      'quantity': quantity,
      'category': category,
      'description': description,
    };
  }

  Tire copyWith({
    String? brand,
    String? model,
    String? width,
    String? ratio,
    String? diameter,
    double? price,
    int? quantity,
    String? category,
    String? description,
  }) {
    return Tire(
      id: id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      width: width ?? this.width,
      ratio: ratio ?? this.ratio,
      diameter: diameter ?? this.diameter,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'Tire(id: $id, brand: $brand, model: $model, size: $size, price: \$${price.toStringAsFixed(2)}, quantity: $quantity, category: $category)';
  }
}
