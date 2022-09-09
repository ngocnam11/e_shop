import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/wishlist/wishlist_bloc.dart';
import '../config/utils.dart';
import '../models/product.dart';
import '../screens/screens.dart';
import 'custom_network_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              product: product,
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomNetworkImage(
                  src: product.imageUrl,
                  height: 160,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, state) {
                    if (state is WishlistLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is WishlistLoaded) {
                      return Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.blue[200]!.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: FittedBox(
                          child: IconButton(
                            onPressed: () {
                              if (state.wishlist.products.contains(product)) {
                                context
                                    .read<WishlistBloc>()
                                    .add(RemoveProductFromWishlist(product));
                                showSnackBar(
                                  context,
                                  'Removed from your Wishlist',
                                );
                              } else {
                                context
                                    .read<WishlistBloc>()
                                    .add(AddProductToWishlist(product));
                                showSnackBar(
                                  context,
                                  'Added to your Wishlist',
                                );
                              }
                            },
                            icon: state.wishlist.products.contains(product)
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red[400],
                                  )
                                : const Icon(Icons.favorite_outline),
                          ),
                        ),
                      );
                    } else {
                      return const Text('Something went wrong');
                    }
                  },
                ),
              ),
            ],
          ),
          Text(
            product.name,
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            product.description,
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            '\$${product.price}',
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
