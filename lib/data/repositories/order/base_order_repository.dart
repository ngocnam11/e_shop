import '../../models/order.dart';

abstract class BaseOrderRepository {
  Stream<List<OrderModel>> getCurrentUserOrders();
  Stream<List<OrderModel>> getOrdersOfSellerId();
  Future<String> addOrder(OrderModel order);
  Future<String> updateOrderStatus({
    required String id,
    required String orderStatus,
  });
}