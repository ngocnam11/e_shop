import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/product.dart';
import '../../../data/models/wishlist.dart';
import '../../../services/wishlist_service.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(WishlistLoading()) {
    Wishlist wishlist = const Wishlist();
    on<LoadWishlist>((event, emit) async {
      emit(WishlistLoading());
      try {
        wishlist = wishlist.copyWith(
          products: await WishlistService().getWishlist(),
        );
        emit(WishlistLoaded(wishlist: wishlist));
      } catch (_) {
        emit(WishlistError());
      }
    });
    on<AddProductToWishlist>((event, emit) async {
      final state = this.state;
      if (state is WishlistLoaded) {
        try {
          wishlist = wishlist.copyWith(
            products: List.from(state.wishlist.products)..add(event.product),
          );
          await WishlistService().addWishlist(wishlist: wishlist);
          emit(WishlistLoaded(wishlist: wishlist));
        } on Exception catch (_) {
          emit(WishlistError());
        }
      }
    });
    on<RemoveProductFromWishlist>((event, emit) async {
      final state = this.state;
      if (state is WishlistLoaded) {
        try {
          wishlist = wishlist.copyWith(
            products: List.from(state.wishlist.products)..remove(event.product),
          );
          await WishlistService().removeWishlist(product: event.product);
          emit(WishlistLoaded(wishlist: wishlist));
        } on Exception catch (_) {
          emit(WishlistError());
        }
      }
    });
  }
}
