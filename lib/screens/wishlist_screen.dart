import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../config/utils.dart';
import '../widgets/empty_product.dart';
import '../router/router.dart';
import '../widgets/custom_navigationbar.dart';
import '../widgets/list_item.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.wishlist),
      builder: (_) => const WishlistScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: [
          TextButton(
            child: const Text('Delete'),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, wishlistState) {
          if (wishlistState is WishlistLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (wishlistState is WishlistLoaded) {
            if (wishlistState.wishlist.products.isEmpty) return const EmptyProduct();
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: wishlistState.wishlist.products.length,
              itemBuilder: (context, index) {
                return ListItem(
                  product: wishlistState.wishlist.products[index],
                  child: BlocBuilder<CartBloc, CartState>(
                    builder: (context, cartState) {
                      if (cartState is CartLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (cartState is CartLoaded) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue[300],
                          ),
                          onPressed: () {
                            context.read<CartBloc>().add(AddProduct(cartState.cart.products[index]));
                            showSnackBar(context, 'Added to your Cart');
                          },
                          child: const Text('Add to Cart'),
                        );
                      } else {
                        return const Text('Something went wrong');
                      }
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            );
          } else {
            return const Text('Something went wrong');
          }
        },
      ),
      bottomNavigationBar: const CustomNavigationBar(
        currentRoute: AppRouter.wishlist,
      ),
    );
  }
}
