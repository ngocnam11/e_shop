import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/cart.dart';
import '../../../data/models/checkout.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(CheckoutLoading()) {
    on<LoadCheckout>((event, emit) {
      emit(CheckoutLoading());
      try {
        emit(
          CheckoutLoaded(
            const Checkout(products: <CartItem>[]),
          ),
        );
      } on Exception catch (_) {
        emit(CheckoutError());
      }
    });

    on<AddProductToCheckout>(
      (event, emit) {
        final state = this.state;
        emit(CheckoutLoading());
        if (state is CheckoutLoaded) {
          try {
            emit(
              CheckoutLoaded(
                Checkout(
                  products: List.from(state.checkout.products)
                    ..add(event.product),
                ),
              ),
            );
          } on Exception catch (_) {
            emit(CheckoutError());
          }
        }
      },
    );
    on<RemoveProductFromCheckout>(
      (event, emit) {
        final state = this.state;
        emit(CheckoutLoading());
        if (state is CheckoutLoaded) {
          try {
            emit(
              CheckoutLoaded(
                Checkout(
                  products: List.from(state.checkout.products)
                    ..remove(event.product),
                ),
              ),
            );
          } on Exception catch (_) {
            emit(CheckoutError());
          }
        }
      },
    );
    on<EmptyCheckout>(
      (event, emit) {
        final state = this.state;
        emit(CheckoutLoading());
        if (state is CheckoutLoaded) {
          try {
            emit(
              CheckoutLoaded(
                const Checkout(products: <CartItem>[]),
              ),
            );
          } on Exception catch (_) {
            emit(CheckoutError());
          }
        }
      },
    );
  }
}
