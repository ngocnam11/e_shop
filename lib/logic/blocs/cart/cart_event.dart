part of 'cart_bloc.dart';

@immutable
abstract class CartEvent extends Equatable {
  const CartEvent();
}

class LoadCart extends CartEvent {
  @override
  List<Object> get props => [];
}

class AddProduct extends CartEvent {
  final CartItem product;

  const AddProduct(this.product);

  @override
  List<CartItem> get props => [product];
}

class RemoveProduct extends CartEvent {
  final CartItem product;

  const RemoveProduct(this.product);

  @override
  List<CartItem> get props => [product];
}
