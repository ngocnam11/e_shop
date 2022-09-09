import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../config/utils.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../router/router.dart';
import '../services/firestore_services.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_network_image.dart';
import 'conversation_screen.dart';

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

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 1,
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
              child: CustomNetworkImage(
                src: product.imageUrl,
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: theme.headline3,
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<User>(
                    future: FireStoreServices().getUserByUid(uid: product.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        debugPrint(snapshot.error.toString());
                        return const Text('Something went wrong');
                      }
                      return Text(
                        snapshot.data!.username,
                        style: theme.headline4,
                      );
                    },
                  ),
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
                    '\$${product.price}',
                    style: theme.headline3,
                  ),
                  const SizedBox(height: 12),
                  Ink(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectOptionsScreen(),));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CustomNetworkImage(
                                  src: product.imageUrl,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Color, Size',
                                    style: theme.headline3,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        product.colors!.isEmpty
                                            ? ''
                                            : product.colors![0],
                                        style: theme.headline4,
                                      ),
                                      Text(
                                        product.size!.isEmpty
                                            ? ''
                                            : product.size![0],
                                        style: theme.headline4,
                                      ),
                                    ],
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
                    product.description,
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
            FutureBuilder<User>(
              future: FireStoreServices().getUserByUid(uid: product.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return const Text('Something went wrong');
                }
                return OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ConversationScreen(
                          user: snapshot.data!,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Chat'),
                );
              },
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
