import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/wishlist/wishlist_bloc.dart';
import '../config/utils.dart';
import '../screens/screens.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final dynamic product;

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
                child: Image(
                  height: 160,
                  width: 150,
                  image: NetworkImage(
                    product['imageUrl'],
                  ),
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
                          color: Colors.blue[300]!.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: FittedBox(
                          child: IconButton(
                            onPressed: () {
                              context
                                  .read<WishlistBloc>()
                                  .add(AddProductToWishlist(product));
                              showSnackBar(context, 'Added to your Wishlist');
                            },
                            icon: Icon(
                              Icons.favorite_outline,
                              color: Colors.red[400],
                            ),
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
            product['name'],
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            product['description'],
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            '\$${product['price']}',
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
