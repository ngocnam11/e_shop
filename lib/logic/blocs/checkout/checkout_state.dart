part of 'checkout_bloc.dart';

class CheckoutState extends Equatable {

  @override
  List<Object> get props => [];
}

class CheckoutLoading extends CheckoutState {
  @override
  List<Object> get props => [];
}

class CheckoutLoaded extends CheckoutState {
  final Checkout checkout;

  CheckoutLoaded(this.checkout);
  
  @override
  List<Object> get props => [];
}

class CheckoutError extends CheckoutState {
  @override
  List<Object> get props => [];
}

