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
    );
  }

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
    );
  }

  @override
  String toString() {
    return 'Tire(id: $id, brand: $brand, model: ${model ?? ''}, size: $size, price: \$${price?.toStringAsFixed(2) ?? 'N/A'}, category: ${category ?? ''})';
  }
}
