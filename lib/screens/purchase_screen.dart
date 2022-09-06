import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  final List<String> _paymentIcon = [
    'assets/svgs/logo/money.svg',
    // 'assets/svgs/logo/paypal.svg',
    'assets/svgs/logo/apple.svg',
    'assets/svgs/logo/google.svg',
    'assets/svgs/logo/mastercard.svg',
  ];

  final List<String> _paymentTitle = [
    'Cash Money',
    // 'Paypal',
    'Apple Pay',
    'Google Pay',
    'Credit Card',
  ];

  String _paymentMethod = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemBuilder: (context, index) {
          if (index != _paymentTitle.length) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                  child: FittedBox(
                    child: SvgPicture.asset(
                      _paymentIcon[index],
                    ),
                  ),
                ),
                title: Text(_paymentTitle[index]),
                trailing: Radio<String>(
                  value: _paymentTitle[index],
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                      debugPrint('Method: $_paymentMethod');
                    });
                  },
                ),
              ),
            );
          }

          return OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.newCard);
            },
            child: const Text('+ Add New Card'),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: _paymentTitle.length + 1,
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
