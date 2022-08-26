import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;
  final String imageUrl;

  const Category({
    required this.name,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [name, imageUrl];

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}