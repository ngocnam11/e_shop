import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../config/utils.dart';
import '../router/router.dart';
import '../widgets/custom_button.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  static MaterialPageRoute route({required product}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.product),
      builder: (_) => ProductScreen(
        product: product,
      ),
    );
  }

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 1,
        // backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        actions: [
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Image(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                image: NetworkImage(
                  product['imageUrl'],
                ),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: theme.headline3,
                  ),
                  const SizedBox(height: 12),
                  Text('Shop', style: theme.headline4),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow),
                      const Icon(Icons.star, color: Colors.yellow),
                      const Icon(Icons.star, color: Colors.yellow),
                      const Icon(Icons.star, color: Colors.yellow),
                      const Icon(Icons.star, color: Colors.yellow),
                      Text(
                        '10',
                        style: theme.headline4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${product['price']}',
                    style: theme.headline3,
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image(
                                  height: 70,
                                  width: 70,
                                  image: NetworkImage(
                                    product['imageUrl'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'options (color, size)',
                                    style: theme.headline3,
                                  ),
                                  Text(
                                    'options selected',
                                    style: theme.headline4,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.navigate_next,
                            size: 40,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Description',
                    style: theme.headline3,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product['description'],
                    style: theme.headline6,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Row(
          children: [
            const SizedBox(width: 24),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRouter.chat);
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Chat'),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is CartLoaded) {
                    return CustomButton(
                      svg: 'assets/svgs/shopping_bag.svg',
                      press: () {
                        context.read<CartBloc>().add(AddProduct(product));
                        showSnackBar(context, 'Added to your Cart');
                      },
                      textColor: Colors.white,
                      primaryColor: Colors.deepOrange[400]!,
                      svgColor: Colors.white,
                      title: 'Add to Cart',
                    );
                  } else {
                    return const Text('Something went wrong');
                  }
                },
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
