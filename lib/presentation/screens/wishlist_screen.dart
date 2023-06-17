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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, wishlistState) {
          if (wishlistState is WishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (wishlistState is WishlistLoaded) {
            if (wishlistState.wishlist.products.isEmpty) {
              return const EmptyProduct();
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: wishlistState.wishlist.products.length,
              itemBuilder: (context, index) {
                final wishlistItem = wishlistState.wishlist.products[index];
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
                        arguments: wishlistItem,
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
                          id: wishlistItem.id,
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
                                            .headlineMedium,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '\$${wishlistItem.price}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
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
                                                  wishlistItem));
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
                                                context
                                                    .read<CartBloc>()
                                                    .add(AddProduct(
                                                      CartItem(
                                                        id: 'ci${wishlistItem.id}',
                                                        productId:
                                                            wishlistItem.id,
                                                        color: wishlistItem
                                                                .colors.isEmpty
                                                            ? 'n'
                                                            : wishlistItem
                                                                .colors[0],
                                                        size: wishlistItem
                                                                .sizes.isEmpty
                                                            ? 'n'
                                                            : wishlistItem
                                                                .sizes[0],
                                                        price:
                                                            wishlistItem.price,
                                                        quantity: 1,
                                                        sellerId:
                                                            wishlistItem.uid,
                                                      ),
                                                    ));
                                                showSnackBar(
                                                  context,
                                                  'Added to your Cart',
                                                );
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
                                            'Something went wrong',
                                          );
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
          }
          return const Text('Something went wrong');
        },
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
