import 'package:flutter/material.dart';

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
    return const Scaffold(
      body: Text('Wishlist'),
      bottomNavigationBar: CustomNavigationBar(
        currentRoute: AppRouter.wishlist,
      ),
    );
  }
}
