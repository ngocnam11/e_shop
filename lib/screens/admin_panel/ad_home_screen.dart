import 'package:flutter/material.dart';

import '../../router/router.dart';

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
        title: const Text('Admin Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Ink(
              height: 150,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.of(context).pushNamed(AppRouter.adminProduct);
                },
                child: const Center(
                  child: Text(
                    'Go to Products',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Ink(
              height: 150,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.of(context).pushNamed(AppRouter.adminOrder);
                },
                child: const Center(
                  child: Text(
                    'Go to Orders',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
