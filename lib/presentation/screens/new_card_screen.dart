import 'package:flutter/material.dart';

import '../router/app_router.dart';

class NewCardScreen extends StatelessWidget {
  const NewCardScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.newCard),
      builder: (_) => const NewCardScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay with a Credit card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              'Card Form',
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
