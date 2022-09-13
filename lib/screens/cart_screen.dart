import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../widgets/empty_product.dart';
import '../router/router.dart';
import '../widgets/list_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.cart),
      builder: (_) => const CartScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Delete'),
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                return ListItem(
                  product: products.keys.elementAt(index),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                              RemoveProduct(products.keys.elementAt(index)));
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        products.values.elementAt(index).toString(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<CartBloc>()
                              .add(AddProduct(products.keys.elementAt(index)));
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
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
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CartLoaded) {
            final products = state.cart.products;
            if (products.isEmpty) {
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
            } else {
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Text(
                            '\$${state.cart.totalString}',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRouter.checkout,
                            arguments: products,
                          );
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
          }
          return const Text('Something went wrong');
        },
      ),
    );
  }
}
