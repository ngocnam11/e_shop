import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/product.dart';
import '../../models/wishlist.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(WishlistLoading()) {
    on<LoadWishlist>((event, emit) async {
      emit(WishlistLoading());
      try {
        await Future<void>.delayed(const Duration(seconds: 1));
        emit(const WishlistLoaded());
      } catch (_) {
        emit(WishlistError());
      }
    });
    on<AddProductToWishlist>((event, emit) {
      final state = this.state;
      if (state is WishlistLoaded) {
        try {
          emit(
            WishlistLoaded(
              wishlist: Wishlist(
                products: List.from(state.wishlist.products)
                  ..add(event.product),
              ),
            ),
          );
        } on Exception catch (_) {
          emit(WishlistError());
        }
      }
    });
    on<RemoveProductFromWishlist>((event, emit) {
      final state = this.state;
      if (state is WishlistLoaded) {
        try {
          WishlistLoaded(
            wishlist: Wishlist(
              products: List.from(state.wishlist.products)
                ..remove(event.product),
            ),
          );
        } on Exception catch (_) {
          emit(WishlistError());
        }
      }
    });
  }
}