import 'package:equatable/equatable.dart';

class Wishlist extends Equatable {
  final List<dynamic> products;
  
  const Wishlist({this.products = const <dynamic>[]});

  @override
  List<Object?> get props => [products];
  
}