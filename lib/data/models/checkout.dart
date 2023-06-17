import 'package:equatable/equatable.dart';

import 'cart.dart';

class Checkout extends Equatable {
  final List<CartItem> products;

  const Checkout({
    this.products = const <CartItem>[],
  });

  double get subtotal =>
      products.fold(0, (total, current) => total + current.price * current.quantity);

  String get subtotalString => subtotal.toStringAsFixed(2);

  String get deliveryFeeString => deliveryFee(subtotal).toStringAsFixed(2);

  String get totalString => total(subtotal, deliveryFee).toStringAsFixed(2);

  Map<CartItem, int> productQuantity(products) {
    var quantity = <CartItem, int>{};

    products.forEach((CartItem product) {
      if (!quantity.containsKey(product)) {
        quantity[product] = 1;
      } else {
        quantity[product] = product.quantity;
      }
    });

    return quantity;
  }

  double total(subtotal, deliveryFee) {
    return subtotal + deliveryFee(subtotal);
  }

  double deliveryFee(subtotal) {
    if (subtotal >= 30) {
      return 0.0;
    } else {
      return 10;
    }
  }
  
  @override
  List<Object> get props => [products];
}