import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../config/utils.dart';
import '../models/product.dart';
import '../services/firestore_services.dart';
import '../widgets/custom_network_image.dart';
import '../widgets/empty_product.dart';
import '../router/router.dart';
import '../widgets/custom_navigationbar.dart';

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
            if (wishlistState.wishlist.products.isEmpty) {
              return const EmptyProduct();
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: wishlistState.wishlist.products.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 126,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<Product>(
                      future: FireStoreServices().getProductById(
                          id: wishlistState.wishlist.products[index].id
                              .toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        return Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CustomNetworkImage(
                                src: snapshot.data!.imageUrl,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          snapshot.data!.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      // Checkbox(
                                      //   value: false,
                                      //   onChanged: (value) {},
                                      // ),
                                      const SizedBox(
                                        height: 32,
                                        width: 32,
                                      ),
                                    ],
                                  ),
                                  // Text(
                                  //   '${wishlistState.wishlist.products[index].colors[0]}, ${wishlistState.wishlist.products[index].size[0]}',
                                  //   style:
                                  //       Theme.of(context).textTheme.bodyText1,
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$${wishlistState.wishlist.products[index].price}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      BlocBuilder<CartBloc, CartState>(
                                        builder: (context, cartState) {
                                          if (cartState is CartLoading) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          if (cartState is CartLoaded) {
                                            return ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blue[300],
                                              ),
                                              onPressed: () {
                                                context.read<CartBloc>().add(
                                                    AddProduct(cartState
                                                        .cart.products[index]));
                                                showSnackBar(context,
                                                    'Added to your Cart');
                                              },
                                              child: const Text('Add to Cart'),
                                            );
                                          } else {
                                            return const Text(
                                                'Something went wrong');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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
