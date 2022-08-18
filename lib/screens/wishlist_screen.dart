import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/custom_navigationbar.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Wishlist'),
      bottomNavigationBar: const CustomNavigationBar(
        currentRoute: AppRouter.wishlist,
      ),
    );
  }
}
