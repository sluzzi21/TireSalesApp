import 'dart:convert';
import 'package:uuid/uuid.dart';

class Tire {
  final String id;
  final String brand;
  final String? model;
  final String width;
  final String ratio;
  final String diameter;
  final double? price;
  final String? category;
  final String? description;
  final String? storage_location1;
  final String? storage_location2;
  final String? storage_location3;
  final int quantity;
  final DateTime? created_at;
  final DateTime? updated_at;

  Tire({
    String? id,
    required this.brand,
    this.model,
    required this.width,
    required this.ratio,
    required this.diameter,
    this.price,
    this.category,
    this.description,
    this.storage_location1,
    this.storage_location2,
    this.storage_location3,
    this.quantity = 0,
    this.created_at,
    this.updated_at,
  }) : id = id ?? const Uuid().v4();

  String get size => '$width/$ratio R$diameter';

  factory Tire.fromJson(Map<String, dynamic> json) {
    return Tire(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String? ?? '',
      width: json['width'] as String,
      ratio: json['ratio'] as String,
      diameter: json['diameter'] as String,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      storage_location1: json['storage_location1'] as String? ?? '',
      storage_location2: json['storage_location2'] as String? ?? '',
      storage_location3: json['storage_location3'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      created_at: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updated_at: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  /// Convert to JSON for local storage (includes all fields)
  /// Convert to JSON for local storage (includes all fields)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model ?? '',
      'width': width,
      'ratio': ratio,
      'diameter': diameter,
      'price': price ?? 0.0,
      'category': category ?? '',
      'description': description ?? '',
      'storage_location1': storage_location1 ?? '',
      'storage_location2': storage_location2 ?? '',
      'storage_location3': storage_location3 ?? '',
      'quantity': quantity,
      'created_at': created_at?.toIso8601String(),
      'updated_at': updated_at?.toIso8601String(),
    };
  }

  /// Convert to JSON for Supabase (only includes fields that exist in the database)
  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model ?? '',
      'width': width,
      'ratio': ratio,
      'diameter': diameter,
      'price': price ?? 0.0,
      'category': category ?? '',
      'description': description ?? '',
      'storage_location1': storage_location1 ?? '',
      'storage_location2': storage_location2 ?? '',
      'storage_location3': storage_location3 ?? '',
      'quantity': quantity,
      // created_at and updated_at are handled by Supabase
    };
  }

  Tire copyWith({
    String? id,
    String? brand,
    String? model,
    String? width,
    String? ratio,
    String? diameter,
    double? price,
    String? category,
    String? description,
    String? storage_location1,
    String? storage_location2,
    String? storage_location3,
    int? quantity,
    DateTime? created_at,
    DateTime? updated_at,
  }) {
    return Tire(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      width: width ?? this.width,
      ratio: ratio ?? this.ratio,
      diameter: diameter ?? this.diameter,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      storage_location1: storage_location1 ?? this.storage_location1,
      storage_location2: storage_location2 ?? this.storage_location2,
      storage_location3: storage_location3 ?? this.storage_location3,
      quantity: quantity ?? this.quantity,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  @override
  String toString() {
    return 'Tire(id: $id, brand: $brand, model: ${model ?? ''}, size: $size, price: \$${price?.toStringAsFixed(2) ?? 'N/A'}, category: ${category ?? ''})';
  }
}
