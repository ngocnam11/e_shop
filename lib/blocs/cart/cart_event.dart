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
  final QueryDocumentSnapshot product;

  const AddProduct(this.product);

  @override
  List<QueryDocumentSnapshot> get props => [product];
}

class RemoveProduct extends CartEvent {
  final QueryDocumentSnapshot product;

  const RemoveProduct(this.product);

  @override
  List<QueryDocumentSnapshot> get props => [product];
}