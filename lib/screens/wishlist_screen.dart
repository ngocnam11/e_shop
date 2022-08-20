import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/custom_navigationbar.dart';
import '../widgets/list_item.dart';

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
        title: Text('Wishlist'),
        actions: [
          TextButton(
            child: Text('Delete'),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: 6,
        itemBuilder: (context, index) {
          return ListItem(
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
