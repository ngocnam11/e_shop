import 'package:flutter/material.dart';

import 'empty_product.dart';
import '../router/router.dart';
import '../widgets/custom_navigationbar.dart';
import '../widgets/list_item.dart';

class WishlistScreen extends StatelessWidget {
  WishlistScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.wishlist),
      builder: (_) => WishlistScreen(),
    );
  }

  final Map<String, dynamic> product = {'Product name': 'Size: L'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
        actions: [
          TextButton(
            child: Text('Delete'),
            onPressed: () {},
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
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Add to Cart'),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
      bottomNavigationBar: const CustomNavigationBar(
        currentRoute: AppRouter.wishlist,
      ),
    );
  }
}
