import 'package:flutter/material.dart';

import '../router/app_router.dart';
import '../widgets/purchase_item.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  static Route route() {
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
          children: <Widget>[
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).popAndPushNamed(AppRouter.checkout);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent.shade100,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('Continue'),
        ),
      ),
    );
  }
}
