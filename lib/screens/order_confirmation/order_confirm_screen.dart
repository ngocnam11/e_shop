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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SvgPicture.asset(
                  'assets/svgs/order/success.svg',
                  height: 80,
                  width: 80,
                ),
              ),
              Text(
                'Hey {username},',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                'Thanks for your purchase',
                style: Theme.of(context).textTheme.headline5,
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Sub-total',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  Text(
                    '{price}\$',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'VAT (%)',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  Text(
                    '{price}\$',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Shipping Charge',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  Text(
                    '{price}\$',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    '{price}\$',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: const Size.fromWidth(double.maxFinite),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  primary: Colors.indigo,
                ),
                child: const Text('Track Your Order'),
              ),
              const Text('Order #123456'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            primary: Colors.blueAccent.shade100,
          ),
          child: const Text('Continue Shopping'),
        ),
      ),
    );
  }
}
