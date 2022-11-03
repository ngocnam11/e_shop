import 'package:equatable/equatable.dart';

import 'product.dart';

class Wishlist extends Equatable {
  final List<Product> products;

  const Wishlist({this.products = const <Product>[]});

  Wishlist copyWith({List<Product>? products}) {
    return Wishlist(products: products ?? this.products);
  }

  @override
  List<Object?> get props => [products];
}
