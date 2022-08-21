import 'package:flutter/material.dart';

import 'empty_product.dart';
import '../router/router.dart';
import '../widgets/list_item.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.cart),
      builder: (_) => CartScreen(),
    );
  }

  final Map<String, dynamic> product = {};

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
      body: product.keys.isEmpty
          ? const EmptyProduct()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: product.keys.length,
              itemBuilder: (context, index) {
                return ListItem(
                  product: product,
                  index: index,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '1',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
      bottomNavigationBar: product.keys.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onLongPress: () {
                  Navigator.of(context).pushNamed(AppRouter.checkout);
                },
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRouter.home,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  primary: Colors.blueAccent.shade100,
                ),
                child: const Text('Continue Shopping'),
              ),
            )
          : Padding(
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
                          '{price}\$',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRouter.checkout);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        primary: Colors.blueAccent.shade100,
                        fixedSize: const Size.fromWidth(500),
                      ),
                      child: const Text('Go to checkout'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
