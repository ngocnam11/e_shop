import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/custom_navigationbar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.cart),
      builder: (_) => const CartScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Cart'),
      bottomNavigationBar: CustomNavigationBar(
        currentRoute: AppRouter.cart,
      ),
    );
  }
}
