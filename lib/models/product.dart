import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String uid;
  final String name;
  final String category;
  final String imageUrl;
  final double price;
  final int quantity;
  final String description;
  final List<String>? colors;
  final List<String>? size;

  const Product({
    required this.id,
    required this.uid,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    this.quantity = 0,
    required this.description,
    this.colors,
    this.size,
  });

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
      'size': size,
    };
  }

  factory Product.fromJson(Map<String, dynamic> snap) {
    return Product(
      id: snap['id'],
      uid: snap['uid'],
      name: snap['name'],
      category: snap['category'],
      imageUrl: snap['imageUrl'],
      price: snap['price'],
      quantity: snap['quantity'],
      description: snap['description'],
      colors: List<String>.from(snap['colors'].map((x) => x)),
      size: List<String>.from(snap['size'].map((x) => x)),
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
        size,
      ];

  static List<Product> products = [
    const Product(
      id: 1,
      uid: '',
      name: 'Vagabond Sack',
      category: 'Accessories',
      imageUrl:
          'https://images.unsplash.com/photo-1462037629520-2a7c6feac7f4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1210&q=80',
      price: 120,
      description: '',
    ),
    const Product(
      id: 2,
      uid: '',
      name: 'Stella Sunglasses',
      category: 'Accessories',
      imageUrl:
          'https://images.unsplash.com/photo-1577803645773-f96470509666?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      price: 58,
      description: '',
    ),
    const Product(
      id: 3,
      uid: '',
      name: 'Whitney Belt',
      category: 'Accessories',
      imageUrl:
          'https://images.unsplash.com/photo-1631160246898-58192f971b5f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1925&q=80',
      price: 35,
      description: '',
    ),
  ];
}
