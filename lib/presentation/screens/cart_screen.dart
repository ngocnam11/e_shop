import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/utils.dart';
import '../../logic/blocs/cart/cart_bloc.dart';
import '../../logic/cubits/cubits.dart';
import '../../services/firestore_services.dart';
import '../router/app_router.dart';
import '../widgets/empty_product.dart';
import '../widgets/list_item.dart';

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
  void removeProductToCart({
    required String id,
    required String productId,
    required String color,
    required String size,
    required double priceOfItem,
    required String sellerId,
  }) async {
    String res = await FireStoreServices().removeProductFromCart(
      id: id,
      productId: productId,
      color: color,
      size: size,
      priceOfItem: priceOfItem,
      sellerId: sellerId,
    );

    if (!mounted) return;

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      showSnackBar(context, 'Removed from your Cart');
    }
  }

  void addProductToCart({
    required String productId,
    required String color,
    required String size,
    required double price,
    required String sellerId,
  }) async {
    String res = await FireStoreServices().addProductToCart(
      productId: productId,
      color: color,
      size: size,
      quantity: 1,
      price: price,
      sellerId: sellerId,
    );

    if (!mounted) return;

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      showSnackBar(context, 'Added to your Cart');
    }
  }

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
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          removeProductToCart(
                            id: state.cart.products[index].id,
                            productId: state.cart.products[index].productId,
                            color: state.cart.products[index].color!,
                            size: state.cart.products[index].size!,
                            priceOfItem: state.cart.products[index].price,
                            sellerId: state.cart.products[index].sellerId,
                          );
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
                          addProductToCart(
                            productId: state.cart.products[index].productId,
                            color: state.cart.products[index].color!,
                            size: state.cart.products[index].size!,
                            price: state.cart.products[index].price,
                            sellerId: state.cart.products[index].sellerId,
                          );
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
              separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                    children: <Widget>[
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
          }
          return const Text('Something went wrong');
        },
      ),
    );
  }
}
