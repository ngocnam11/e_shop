import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/cart.dart';

import '../../../data/repositories/repositories.dart';
import '../../../services/auth_services.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  final AuthRepository _authRepository;

  CartBloc({
    CartRepository? cartRepository,
    required AuthRepository authRepository,
  })  : _cartRepository = cartRepository ?? CartRepository(),
        _authRepository = authRepository,
        super(CartLoading()) {
    on<LoadCart>((event, emit) async {
      emit(CartLoading());
      try {
        _authRepository.user.listen((user) {
          if (user != null) {
            _cartRepository.getCart().listen((cart) {
              add(UpdateCart(cart));
            });
          }
        });
      } catch (_) {
        emit(CartError());
      }
    });
    on<UpdateCart>(
      (event, emit) {
        emit(CartLoaded(event.cart));
      },
    );
    on<AddProduct>(
      (event, emit) async {
        await _cartRepository.addProductToCart(event.product);

        final state = this.state;
        if (state is CartLoaded) {
          try {
            emit(
              CartLoaded(
                Cart(
                  uid: AuthServices().currentUser.uid,
                  products: List.from(state.cart.products),
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
      (event, emit) async {
        await _cartRepository.removeProductFromCart(event.product);

        final state = this.state;
        if (state is CartLoaded) {
          try {
            emit(
              CartLoaded(
                Cart(
                  uid: AuthServices().currentUser.uid,
                  products: List.from(state.cart.products),
                ),
              ),
            );
          } on Exception catch (_) {
            emit(CartError());
          }
        }
      },
    );
    on<DeleteProduct>(
      (event, emit) async {
        await _cartRepository.deleteProductFromCart(event.product);

        final state = this.state;
        if (state is CartLoaded) {
          try {
            emit(
              CartLoaded(
                Cart(
                  uid: AuthServices().currentUser.uid,
                  products: List.from(state.cart.products),
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
