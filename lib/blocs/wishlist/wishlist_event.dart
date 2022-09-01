part of 'wishlist_bloc.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWishlist extends WishlistEvent {

  @override
  List<Object> get props => [];
}

class AddProductToWishlist extends WishlistEvent {
  final product;

  const AddProductToWishlist(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveProductFromWishlist extends WishlistEvent {
  final product;

  const RemoveProductFromWishlist(this.product);
  
  @override
  List<Object> get props => [product];
}