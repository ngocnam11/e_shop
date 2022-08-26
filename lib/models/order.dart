import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final int id;
  final String customerId;
  final List<int> productIds;
  final double deliveryFee;
  final double subtotal;
  final double total;
  final bool isAccepted;
  final bool isDelivered;
  final bool isCancelled;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.customerId,
    required this.productIds,
    required this.deliveryFee,
    required this.subtotal,
    required this.total,
    required this.isAccepted,
    required this.isDelivered,
    required this.isCancelled,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'productIds': productIds,
      'dedeliveryFee': deliveryFee,
      'susubtotal': subtotal,
      'tototal': total,
      'isAccepted': isAccepted,
      'isDelivered': isDelivered,
      'isCancelled': isCancelled,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        productIds,
        deliveryFee,
        subtotal,
        total,
        isAccepted,
        isDelivered,
        isCancelled,
        createdAt,
      ];

  static List<Order> orders = [
    Order(
      id: 1,
      customerId: '1',
      productIds: const [1, 2],
      deliveryFee: 0,
      subtotal: 100,
      total: 100,
      isAccepted: false,
      isDelivered: false,
      isCancelled: false,
      createdAt: DateTime.now(),
    ),
  ];
}