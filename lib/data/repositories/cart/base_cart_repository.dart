import '../../models/cart.dart';

abstract class BaseCartRepository {
  Stream<Cart> getCart();
  Future<String> addProductToCart(CartItem product);
  Future<String> removeProductFromCart(CartItem product);
  Future<String> deleteProductFromCart(CartItem product);
}
