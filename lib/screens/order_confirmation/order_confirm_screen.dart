import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../router/router.dart';

class OrderConfirmScreen extends StatelessWidget {
  const OrderConfirmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 1.6,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/svgs/order/success.svg',
                  height: 150,
                  width: 150,
                ),
                Text(
                  'Hey {username},',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Thanks for your purchase',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sub-total'),
                    Text(
                      '{price}\$',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('VAT (%)'),
                    Text(
                      '{price}\$',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping Charge'),
                    Text(
                      '{price}\$',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '{price}\$',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size.fromWidth(double.maxFinite),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    primary: Colors.indigo,
                  ),
                  child: const Text('Track Your Order'),
                ),
                Text('Order #123456'),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouter.home,
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            primary: Colors.blueAccent.shade100,
          ),
          child: const Text('Continue Shopping'),
        ),
      ),
    );
  }
}
