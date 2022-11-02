import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String uid;
  final String name;
  final String category;
  final String imageUrl;
  final double price;
  final int quantity;
  final String description;
  final List<String> colors;
  final List<String> sizes;

  const Product({
    required this.id,
    required this.uid,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.description,
    this.colors = const [],
    this.sizes = const [],
  });

  Product copyWith({
    String? name,
    String? category,
    String? imageUrl,
    double? price,
    int? quantity,
    String? description,
    List<String>? colors,
    List<String>? sizes,
  }) {
    return Product(
      id: id,
      uid: uid,
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'description': description,
      'colors': colors,
      'sizes': sizes,
    };
  }

  factory Product.fromJson(Map<String, dynamic> snap) {
    return Product(
      id: snap['id'],
      uid: snap['uid'],
      name: snap['name'],
      category: snap['category'],
      imageUrl: snap['imageUrl'],
      price: snap['price'] + .0,
      quantity: snap['quantity'],
      description: snap['description'],
      colors: List<String>.from(snap['colors'].map((x) => x)),
      sizes: List<String>.from(snap['sizes'].map((x) => x)),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        imageUrl,
        price,
        quantity,
        description,
        colors,
        sizes,
      ];

  static const List<Product> products = [
    Product(
      id: '',
      uid: '',
      name: 'Vagabond Sack',
      category: 'Accessories',
      imageUrl:
          'https://images.unsplash.com/photo-1462037629520-2a7c6feac7f4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1210&q=80',
      price: 120,
      quantity: 1,
      description: '',
    ),
    Product(
      id: '',
      uid: '',
      name: 'Stella Sunglasses',
      category: 'Accessories',
      imageUrl:
          'https://images.unsplash.com/photo-1577803645773-f96470509666?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      price: 58,
      quantity: 2,
      description: '',
    ),
    Product(
      id: '',
      uid: '',
      name: 'Whitney Belt',
      category: 'Accessories',
      imageUrl:
          'https://images.unsplash.com/photo-1631160246898-58192f971b5f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1925&q=80',
      price: 35,
      quantity: 3,
      description: '',
    ),
  ];
}
