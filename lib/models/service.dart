class Service {
  final String id;
  final String name;
  final String description;
  final double price;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
      };

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: json['price'].toDouble(),
      );
}
