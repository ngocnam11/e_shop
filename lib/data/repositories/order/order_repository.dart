import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/data/models/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_order_repository.dart';

class OrderRepository implements BaseOrderRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  OrderRepository({
    FirebaseFirestore? firebaseFirestore,
    FirebaseAuth? firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<List<OrderModel>> getCurrentUserOrders() {
    final snaps = _firebaseFirestore
        .collection('orders')
        .where('customerId', isEqualTo: _firebaseAuth.currentUser!.uid)
        .snapshots();
    final orders = snaps.map((snap) =>
        snap.docs.map((doc) => OrderModel.fromJson(doc.data())).toList());
    return orders;
  }

  @override
  Stream<List<OrderModel>> getOrdersOfSellerId() {
    final snaps = _firebaseFirestore
        .collection('orders')
        .where('sellerId', isEqualTo: _firebaseAuth.currentUser!.uid)
        .snapshots();
    final orders = snaps.map((snap) =>
        snap.docs.map((doc) => OrderModel.fromJson(doc.data())).toList());
    return orders;
  }

  @override
  Future<String> addOrder(OrderModel order) async {
    String response = 'Some error occurred';
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var date = DateTime.now().toLocal();
      final id = 'ORD${date.year}Y${date.month}M${date.day}ES${date.second}';
      await prefs.setString('orderId', id);

      OrderModel orderModel = OrderModel(
        id: id,
        customerId: order.customerId,
        sellerId: order.sellerId,
        products: order.products,
        paymentMethod: 'Cash Money',
        deliveryAddress: order.deliveryAddress,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        total: order.total,
        orderStatus: order.orderStatus,
        createdAt: Timestamp.now(),
      );
      _firebaseFirestore.collection('orders').doc(id).set(orderModel.toJson());
      response = 'success';
    } catch (e) {
      response = e.toString();
    }

    return response;
  }

  @override
  Future<String> updateOrderStatus({
    required String id,
    required String orderStatus,
  }) async {
    String updateOrder = 'Some error occurred';
    try {
      _firebaseFirestore.collection('orders').doc(id).update({
        'orderStatus': orderStatus,
      });
      updateOrder = 'success';
    } catch (e) {
      updateOrder = e.toString();
    }
    return updateOrder;
  }
}
