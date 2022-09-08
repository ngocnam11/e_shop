import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../router/router.dart';

class NewCardScreen extends StatelessWidget {
  const NewCardScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
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
          children: [
            Text(
              'Card Form',
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(height: 20),
            CardFormField(
              controller: CardFormEditController(),
            ),
            const SizedBox(height: 10),
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
