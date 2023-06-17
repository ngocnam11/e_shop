part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadOrder extends OrderEvent {

  @override
  List<Object> get props => [];
}

class AddOrder extends OrderEvent {
  final OrderModel order;

  const AddOrder(this.order);

  @override
  List<Object> get props => [order];
}

class UpdateOrderStatus extends OrderEvent {
  final String id;
  final String orderStatus;

  const UpdateOrderStatus(this.id, this.orderStatus);

  @override
  List<Object> get props => [id, orderStatus];
}

class UpdateOrder extends OrderEvent {
  final List<OrderModel> orders;

  const UpdateOrder(this.orders);

  @override
  List<Object> get props => [orders];
}
