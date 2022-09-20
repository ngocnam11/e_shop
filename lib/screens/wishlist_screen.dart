import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        actions: <Widget>[
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
                return Ink(
                  height: 126,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRouter.product,
                        arguments: wishlistState.wishlist.products[index],
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        bottom: 8,
                        top: 8,
                      ),
                      child: FutureBuilder<Product>(
                        future: FireStoreServices().getProductById(
                          id: wishlistState.wishlist.products[index].id
                              .toString(),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            debugPrint(snapshot.error.toString());
                            return const Text('Something went wrong');
                          }
                          if (snapshot.hasData) {
                            return Row(
                              children: <Widget>[
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
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data!.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '\$${wishlistState.wishlist.products[index].price}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Tooltip(
                                      message: 'Remove from Wishlist',
                                      child: IconButton(
                                        onPressed: () {
                                          context.read<WishlistBloc>().add(
                                              RemoveProductFromWishlist(
                                                  wishlistState.wishlist
                                                      .products[index]));
                                          showSnackBar(
                                            context,
                                            'Removed from your Wishlist',
                                          );
                                        },
                                        icon: Icon(
                                          Icons.heart_broken_rounded,
                                          color: Colors.red[400],
                                        ),
                                      ),
                                    ),
                                    BlocBuilder<CartBloc, CartState>(
                                      builder: (context, cartState) {
                                        if (cartState is CartLoading) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        if (cartState is CartLoaded) {
                                          return Tooltip(
                                            message: 'Add to Cart',
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blue[300],
                                                shape: const CircleBorder(),
                                                padding:
                                                    const EdgeInsets.all(4),
                                              ),
                                              onPressed: () {
                                                context.read<CartBloc>().add(
                                                    AddProduct(cartState
                                                        .cart.products[index]));
                                                showSnackBar(context,
                                                    'Added to your Cart');
                                              },
                                              child: SvgPicture.asset(
                                                'assets/svgs/add-to-basket.svg',
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.cover,
                                                color: Colors.white,
                                              ),
                                            ),
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
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
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
      bottomNavigationBar: const CustomNavigationBar(
        currentRoute: AppRouter.wishlist,
      ),
    );
  }
}
