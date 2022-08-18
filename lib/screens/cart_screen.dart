import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/custom_navigationbar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Cart'),
      bottomNavigationBar: CustomNavigationBar(
        currentRoute: AppRouter.cart,
      ),
    );
  }
}
