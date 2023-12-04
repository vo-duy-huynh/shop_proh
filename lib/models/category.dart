import 'dart:convert';

class Category {
  final String name;
  final String? imageCover;
  final String? description;
  final String? id;
  Category({
    required this.name,
    this.imageCover,
    this.description,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageCover': imageCover,
      'description': description,
      'id': id,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] ?? '',
      imageCover: map['imageCover'] ?? '',
      description: map['description'] ?? '',
      id: map['_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));
}
