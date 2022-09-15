import 'package:equatable/equatable.dart';

import 'product.dart';

class Cart extends Equatable {
  final String uid;
  final List<CartItem> products;
  // final Map<String, CartItem> products;

  const Cart({
    required this.uid,
    this.products = const <CartItem>[],
    // this.products = const <String, CartItem>{},
  });

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

  factory Cart.fromSnap(Map<String, dynamic> snap) {
    List<CartItem> products = [];
    snap["products"].forEach((product) {
      products.add(CartItem.fromSnap(product));
    });
    return Cart(
      uid: snap['uid'],
      products: products,
      // products: Map.from(snap["products"]).map((k, v) => MapEntry<String, CartItem>(k, CartItem.fromSnap(v))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'products': List.from(products.map((product) => product.toJson())),
      // 'products': Map.from(products).map((k, product) => MapEntry<String, dynamic>(k, product.toJson())),
    };
  }

  @override
  List<Object> get props => [uid, products];
}

class CartItem extends Equatable {
  final String id;
  final String productId;
  final String? color;
  final String? size;
  final int quantity;
  final double price;
  final Product? productInfo;

  const CartItem({
    required this.id,
    required this.productId,
    this.color,
    this.size,
    required this.price,
    required this.quantity,
    this.productInfo,
  });

  static CartItem fromSnap(Map<String, dynamic> snap) {
    return CartItem(
      id: snap["id"],
      productId: snap["productId"],
      color: snap["color"],
      size: snap["size"],
      price: snap["price"] + .0,
      quantity: snap["quantity"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productId": productId,
      "color": color,
      "size": size,
      "price": price,
      "quantity": quantity,
    };
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        color,
        size,
        price,
        quantity,
      ];
}
