import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/order.dart';
import '../../../data/repositories/repositories.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final AuthRepository _authRepository;

  OrderBloc({
    OrderRepository? orderRepository,
    required authRepository,
  })  : _orderRepository = orderRepository ?? OrderRepository(),
        _authRepository = authRepository,
        super(OrderLoading()) {
    on<LoadOrder>((event, emit) async {
      emit(OrderLoading());
      try {
        _authRepository.user.listen((user) {
          if (user != null) {
            _orderRepository.getCurrentUserOrders().listen((orders) {
              add(UpdateOrder(orders));
            });
          }
        });
      } catch (_) {
        emit(OrderError());
      }
    });
    on<UpdateOrder>(
      (event, emit) {
        emit(OrderLoaded(event.orders));
      },
    );
    on<AddOrder>((event, emit) async {
      await _orderRepository.addOrder(event.order);

      final state = this.state;
      if (state is OrderLoaded) {
        try {
          emit(
            OrderLoaded(state.orders),
          );
        } on Exception catch (_) {
          emit(OrderError());
        }
      }
    });
    on<UpdateOrderStatus>((event, emit) async {
      await _orderRepository.updateOrderStatus(
        id: event.id,
        orderStatus: event.orderStatus,
      );

      final state = this.state;
      if (state is OrderLoaded) {
        try {
          emit(
            OrderLoaded(state.orders),
          );
        } on Exception catch (_) {
          emit(OrderError());
        }
      }
    });
  }
}
