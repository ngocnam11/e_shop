import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String orderStatus;
  final Timestamp createdAt;

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
    required this.orderStatus,
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
      orderStatus: snap['orderStatus'],
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
      'orderStatus': orderStatus,
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
        orderStatus,
        createdAt,
      ];
}
