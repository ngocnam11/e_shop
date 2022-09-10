import 'package:equatable/equatable.dart';

import 'product.dart';

class Cart extends Equatable {
  // final String uid;
  final List<Product> products;
  const Cart({this.products = const <Product>[]});

  double get subtotal =>
      products.fold(0, (total, current) => total + current.price);

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

  // factory Cart.fromSnap(Map<String, dynamic> snap) {
  //   List<CartItem> products = [];
  //   snap["products"].forEach((product) {
  //     products.add(Product.fromJson(product));
  //   });
  //   return Cart(
  //     products: products,
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'uid': uid,
  //     'products': products,
  //   }
  // }

  @override
  List<List<Product>> get props => [products];
}

class CartItem extends Equatable {
  final String id;
  final String productId;
  final int quantity;
  final int price;
  final Product? productInfo;

  const CartItem({
    required this.id,
    required this.productId,
    required this.price,
    required this.quantity,
    this.productInfo,
  });

  static CartItem fromSnap(Map<String, dynamic> snap) {
    return CartItem(
      id: snap["id"] ,
      productId: snap["productId"],
      price: snap["price"],
      quantity: snap["quantity"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "productId": productId,
      "price": price,
      "quantity": quantity,
    };
  }
  
  @override
  List<Object?> get props => [id, productId, price, quantity,];
}