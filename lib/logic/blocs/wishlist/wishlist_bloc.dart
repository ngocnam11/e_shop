import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/product.dart';
import '../../../data/models/wishlist.dart';
import '../../../data/repositories/repositories.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository _wishlistRepository;
  final AuthRepository _authRepository;

  WishlistBloc({
    WishlistRepository? wishlistRepository,
    required AuthRepository authRepository,
  })  : _wishlistRepository = wishlistRepository ?? WishlistRepository(),
        _authRepository = authRepository,
        super(WishlistLoading()) {
    on<LoadWishlist>((event, emit) async {
      emit(WishlistLoading());
      _authRepository.user.listen((user) {
        if (user != null) {
          _wishlistRepository.getWishlist().listen((wishlist) {
            add(UpdateWishlist(wishlist));
          });
        }
      });
    });
    on<UpdateWishlist>((event, emit) {
      emit(WishlistLoaded(event.wishlist));
    });
    on<AddProductToWishlist>((event, emit) async {
      await _wishlistRepository.addProductToWishlist(event.product);

      final state = this.state;
      if (state is WishlistLoaded) {
        try {
          emit(WishlistLoaded(Wishlist(
            products: List.from(state.wishlist.products),
          )));
        } on Exception catch (_) {
          emit(WishlistError());
        }
      }
    });
    on<RemoveProductFromWishlist>((event, emit) async {
      await _wishlistRepository.removeProductFromWishlist(event.product);

      final state = this.state;
      if (state is WishlistLoaded) {
        try {
          emit(WishlistLoaded(Wishlist(
            products: List.from(state.wishlist.products),
          )));
        } on Exception catch (_) {
          emit(WishlistError());
        }
      }
    });
  }
}
