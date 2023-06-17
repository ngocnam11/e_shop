import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/blocs/cart/cart_bloc.dart';
import '../../logic/blocs/checkout/checkout_bloc.dart';
import '../../logic/cubits/cubits.dart';
import '../router/app_router.dart';
import '../widgets/item_in_cart.dart';
import '../widgets/empty_product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.cart),
      builder: (context) {
        context.read<NavigatonBarCubit>().setTab(NavigationTab.cart);
        return const CartScreen();
      },
    );
  }

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.home,
            (route) => false,
          ),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Cart'),
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: const Text('Delete'),
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartLoaded) {
            final products = state.cart.productQuantity(state.cart.products);
            if (products.keys.isEmpty) {
              return const EmptyProduct();
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ItemInCart(
                  product: products.keys.elementAt(index),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
            );
          } else {
            return const Text('Something went wrong');
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (cartState is CartLoaded) {
            final productsInCart = cartState.cart.products;
            if (productsInCart.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRouter.home,
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent.shade100,
                  ),
                  child: const Text('Continue Shopping'),
                ),
              );
            }
            return BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, checkoutState) {
                if (checkoutState is CheckoutLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (checkoutState is CheckoutLoaded) {
                  final products = checkoutState.checkout.products;
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 28,
                      top: 12,
                    ),
                    child: SizedBox(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Total',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              Text(
                                products.isEmpty
                                    ? '\$0'
                                    : '\$${checkoutState.checkout.totalString}',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(AppRouter.checkout, arguments: '');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.blueAccent.shade100,
                              fixedSize: const Size.fromWidth(500),
                            ),
                            child: const Text('Go to checkout'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const Text('Something went wrong');
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
