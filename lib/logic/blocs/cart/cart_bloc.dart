import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/cart.dart';
import '../../../services/auth_services.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoading()) {
    on<LoadCart>((event, emit) async {
      emit(CartLoading());
      try {
        await Future<void>.delayed(const Duration(seconds: 1));
        emit(const CartLoaded());
      } catch (_) {
        emit(CartError());
      }
    });
    on<AddProduct>(
      (event, emit) {
        final state = this.state;
        if (state is CartLoaded) {
          try {
            emit(
              CartLoaded(
                cart: Cart(
                  uid: AuthServices().currentUser.uid,
                  products: List.from(state.cart.products)..add(event.product),
                ),
              ),
            );
          } on Exception catch (_) {
            emit(CartError());
          }
        }
      },
    );
    on<RemoveProduct>(
      (event, emit) {
        final state = this.state;
        if (state is CartLoaded) {
          try {
            emit(
              CartLoaded(
                cart: Cart(
                  uid: AuthServices().currentUser.uid,
                  products: List.from(state.cart.products)
                    ..remove(event.product),
                ),
              ),
            );
          } on Exception catch (_) {
            emit(CartError());
          }
        }
      },
    );
  }
}
