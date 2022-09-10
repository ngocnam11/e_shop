import 'package:equatable/equatable.dart';

import 'product.dart';

class Order extends Equatable {
  final String id;
  final String customerId;
  final String sellerId;
  final List<Product> products;
  final String paymentMethod;
  final String deliveryAddress;
  final double deliveryFee;
  final double subtotal;
  final double total;
  final bool isAccepted;
  final bool isDelivered;
  final bool isCancelled;
  final bool isReceived;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.customerId,
    required this.sellerId,
    required this.products,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.deliveryFee,
    required this.subtotal,
    required this.total,
    required this.isAccepted,
    required this.isDelivered,
    required this.isCancelled,
    required this.isReceived,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> snap) {
    List<Product> products = [];
    snap["products"].forEach((product) {
      products.add(Product.fromJson(product));
    });
    return Order(
      id: snap['id'],
      customerId: snap['customerId'],
      sellerId: snap['sellerId'],
      products: products,
      paymentMethod: snap['paymentMethod'],
      deliveryAddress: snap['deliveryAddress'],
      deliveryFee: snap['deliveryFee'],
      subtotal: snap['subtotal'],
      total: snap['total'],
      isAccepted: snap['isAccepted'],
      isDelivered: snap['isDelivered'],
      isCancelled: snap['isCancelled'],
      isReceived: snap['isReceived'],
      createdAt: snap['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'sellerId': sellerId,
      'products':
          List<dynamic>.from(products.map((product) => product.toJson())),
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress,
      'deliveryFee': deliveryFee,
      'subtotal': subtotal,
      'total': total,
      'isAccepted': isAccepted,
      'isDelivered': isDelivered,
      'isCancelled': isCancelled,
      'isReceived': isReceived,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        sellerId,
        products,
        paymentMethod,
        deliveryFee,
        subtotal,
        total,
        isAccepted,
        isDelivered,
        isCancelled,
        isReceived,
        createdAt,
      ];
}
