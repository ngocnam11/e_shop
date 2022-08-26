import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final List<QueryDocumentSnapshot> products;
  const Cart({this.products = const <QueryDocumentSnapshot>[]});

  double get subtotal =>
      products.fold(0, (total, current) => total + current['price']);

  String get subtotalString => subtotal.toStringAsFixed(2);

  String get deliveryFeeString => deliveryFee(subtotal).toStringAsFixed(2);

  String get freeDeliveryString => freeDelivery(subtotal);

  String get totalString => total(subtotal, deliveryFee).toStringAsFixed(2);

  Map productQuantity(products) {
    var quantity = {};

    products.forEach((product) {
      if (!quantity.containsKey(product)) {
        quantity[product] = 1;
      } else {
        quantity[product] += 1;
      }
    });

    return quantity;
  }

  double total(subtotal, deliveryFee) {
    return subtotal + deliveryFee(subtotal);
  }

  String freeDelivery(subtotal) {
    if (subtotal >= 30) {
      return 'You have Free Delivery';
    } else {
      double missing = 30.0 - subtotal;
      return 'Add \$${missing.toStringAsFixed(2)} to FREE Delivery';
    }
  }

  double deliveryFee(subtotal) {
    if (subtotal >= 30) {
      return 0.0;
    } else {
      return 10;
    }
  }

  @override
  List<List<dynamic>> get props => [products];
}