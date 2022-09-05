import 'package:flutter/material.dart';

import '../../router/router.dart';
import 'ad_order_screen.dart';
import 'ad_product_screen.dart';

class AdHomeScreen extends StatelessWidget {
  const AdHomeScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.admin),
      builder: (_) => const AdHomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdProductScreen(),
                  ),
                );
              },
              child: const Card(
                child: Center(
                  child: Text(
                    'Go to Products',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdOrderScreen(),
                  ),
                );
              },
              child: const Card(
                child: Center(
                  child: Text(
                    'Go to Orders',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
