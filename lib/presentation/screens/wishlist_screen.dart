import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/utils.dart';
import '../../data/models/cart.dart';
import '../../data/models/product.dart';
import '../../logic/blocs/blocs.dart';
import '../../logic/cubits/cubits.dart';
import '../../services/firestore_services.dart';
import '../router/app_router.dart';
import '../widgets/custom_navigationbar.dart';
import '../widgets/custom_network_image.dart';
import '../widgets/empty_product.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.wishlist),
      builder: (context) {
        context.read<NavigatonBarCubit>().setTab(NavigationTab.wishlist);
        return const WishlistScreen();
      },
    );
  }

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
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
        title: const Text('Wishlist'),
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
                          id: wishlistState.wishlist.products[index].id,
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
                                                addProductToCart(
                                                  productId: wishlistState
                                                      .wishlist
                                                      .products[index]
                                                      .id,
                                                  color: wishlistState
                                                          .wishlist
                                                          .products[index]
                                                          .colors
                                                          .isEmpty
                                                      ? 'n'
                                                      : wishlistState
                                                          .wishlist
                                                          .products[index]
                                                          .colors[0],
                                                  size: wishlistState
                                                          .wishlist
                                                          .products[index]
                                                          .sizes
                                                          .isEmpty
                                                      ? 'n'
                                                      : wishlistState
                                                          .wishlist
                                                          .products[index]
                                                          .sizes[0],
                                                  price: wishlistState.wishlist
                                                      .products[index].price,
                                                  sellerId: wishlistState
                                                      .wishlist
                                                      .products[index]
                                                      .uid,
                                                );
                                                context
                                                    .read<CartBloc>()
                                                    .add(AddProduct(
                                                      CartItem(
                                                        id: 'ci${wishlistState.wishlist.products[index].id}',
                                                        productId: wishlistState
                                                            .wishlist
                                                            .products[index]
                                                            .id,
                                                        color: wishlistState
                                                                .wishlist
                                                                .products[index]
                                                                .colors
                                                                .isEmpty
                                                            ? 'n'
                                                            : wishlistState
                                                                .wishlist
                                                                .products[index]
                                                                .colors[0],
                                                        size: wishlistState
                                                                .wishlist
                                                                .products[index]
                                                                .sizes
                                                                .isEmpty
                                                            ? 'n'
                                                            : wishlistState
                                                                .wishlist
                                                                .products[index]
                                                                .sizes[0],
                                                        price: wishlistState
                                                            .wishlist
                                                            .products[index]
                                                            .price,
                                                        quantity: 1,
                                                        sellerId: wishlistState
                                                            .wishlist
                                                            .products[index]
                                                            .uid,
                                                      ),
                                                    ));
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
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
