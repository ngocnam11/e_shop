import 'package:flutter/material.dart';

import '../widgets/purchase_item.dart';
import '../router/router.dart';
import '../widgets/order_summary.dart';
import 'order_confirmation/order_confirm_screen.dart';

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
  // final List<Map<String, String>> _payment = [
  //   {'title': 'Cash Money', 'icon': 'assets/svgs/logo/money.svg'},
  //   // {'title':'Paypal','icon': 'assets/svgs/logo/paypal.svg'},
  //   {'title': 'Apple Pay', 'icon': 'assets/svgs/logo/apple.svg'},
  //   {'title': 'Google Pay', 'icon': 'assets/svgs/logo/google.svg'},
  //   {'title': 'Credit Card', 'icon': 'assets/svgs/logo/mastercard.svg'},
  // ];

  String _paymentMethod = '';

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
                style: Theme.of(context).textTheme.headline6,
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
            PurchaseItem(
              svgIconPath: 'assets/svgs/logo/apple.svg',
              title: Text(
                'Apple Pay',
                style: Theme.of(context).textTheme.headline6,
              ),
              subTitle: const Text(
                '***** **** 2472',
                style: TextStyle(color: Colors.black54),
              ),
              trailing: Radio<String>(
                value: 'Apple Pay',
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
            PurchaseItem(
              svgIconPath: 'assets/svgs/logo/google.svg',
              title: Text(
                'Google Pay',
                style: Theme.of(context).textTheme.headline6,
              ),
              subTitle: const Text(
                '589****118',
                style: TextStyle(color: Colors.black54),
              ),
              trailing: Radio<String>(
                value: 'Google Pay',
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
            PurchaseItem(
              svgIconPath: 'assets/svgs/logo/mastercard.svg',
              title: Text(
                'Credit Card',
                style: Theme.of(context).textTheme.headline6,
              ),
              subTitle: const Text(
                '245********643',
                style: TextStyle(color: Colors.black54),
              ),
              trailing: Radio<String>(
                value: 'Credit Card',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                    debugPrint('Method: $_paymentMethod');
                  });
                },
              ),
            ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const OrderSummary(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (constext) => const OrderConfirmScreen(),
                  ),
                );
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
          ],
        ),
      ),
    );
  }
}
