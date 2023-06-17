import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final String uid;
  final List<CartItem> products;

  const Cart({
    required this.uid,
    this.products = const <CartItem>[],
  });

  double get subtotal => products.fold(
      0, (total, current) => total + current.price * current.quantity);

  String get subtotalString => subtotal.toStringAsFixed(2);

  String get deliveryFeeString => deliveryFee(subtotal).toStringAsFixed(2);

  String get totalString => total(subtotal, deliveryFee).toStringAsFixed(2);

  Map productQuantity(products) {
    var quantity = {};

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

  factory Cart.fromJson(Map<String, dynamic> snap) {
    List<CartItem> products = [];
    snap['products'].forEach((product) {
      products.add(CartItem.fromJson(product));
    });
    return Cart(
      uid: snap['uid'],
      products: products,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'products': List.from(products.map((product) => product.toJson())),
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
  final String sellerId;

  const CartItem({
    required this.id,
    required this.productId,
    this.color,
    this.size,
    required this.price,
    required this.quantity,
    required this.sellerId,
  });

  CartItem copyWith({
    String? id,
    String? color,
    String? size,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId,
      color: color ?? this.color,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      price: price,
      sellerId: sellerId,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      color: json['color'],
      size: json['size'],
      price: json['price'] + .0,
      quantity: json['quantity'],
      sellerId: json['sellerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'color': color,
      'size': size,
      'price': price,
      'quantity': quantity,
      'sellerId': sellerId,
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
        sellerId,
      ];
}
