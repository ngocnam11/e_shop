import 'package:flutter/material.dart';

import '../widgets/purchase_item.dart';
import '../router/router.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.purchase),
      builder: (_) => const PurchaseScreen(),
    );
  }

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  String _paymentMethod = 'Cash Money';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            PurchaseItem(
              svgIconPath: 'assets/svgs/logo/money.svg',
              title: Text(
                'Cash Money',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Radio<String>(
                value: 'Cash Money',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                    debugPrint('Method: $_paymentMethod');
                  });
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: const Size.fromWidth(double.maxFinite),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRouter.newCard);
              },
              child: const Text('+ Add New Card'),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 170,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
          top: 10,
        ),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 7,
            ),
          ],
          color: Colors.white,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).popAndPushNamed(AppRouter.checkout);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            primary: Colors.blueAccent.shade100,
            fixedSize: const Size.fromWidth(500),
          ),
          child: const Text('Continue'),
        ),
      ),
    );
  }
}
