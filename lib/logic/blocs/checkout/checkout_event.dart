part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class LoadCheckout extends CheckoutEvent {

  @override
  List<CartItem> get props => [];
}

class AddProductToCheckout extends CheckoutEvent {
  final CartItem product;
  
  const AddProductToCheckout(this.product);

  @override
  List<CartItem> get props => [product];
}

class RemoveProductFromCheckout extends CheckoutEvent {
  final CartItem product;
  
  const RemoveProductFromCheckout(this.product);

  @override
  List<CartItem> get props => [product];
}

class EmptyCheckout extends CheckoutEvent {

  @override
  List<CartItem> get props => [];
}
