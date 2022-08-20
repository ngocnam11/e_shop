import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/list_item.dart';

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
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: 6,
        itemBuilder: (context, index) {
          return ListItem(
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
        separatorBuilder: (context, index) => const SizedBox(
          height: 12,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: 32,
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
                  Navigator.of(context).pushReplacementNamed(AppRouter.home);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  primary: Colors.blueAccent.shade100,
                  fixedSize: const Size.fromWidth(500),
                ),
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
