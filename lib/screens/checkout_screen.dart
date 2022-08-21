import 'package:flutter/material.dart';

import '../router/router.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.checkout),
      builder: (_) => const CheckoutScreen(),
    );
  }

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final List<String> address = [
    '1784 Juniper Drive',
    '2993 Liberty Avenue',
    '297 Nguyễn Thái Học',
    '250 Jalan Purta',
    '117 Bevan St E',
    '1274-39 Kokinu',
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
  ];
  String _addressValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Address'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemBuilder: (context, index) {
          if (index != address.length) {
            return Container(
              height: 70,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.location_on_outlined),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Text>[
                        Text(
                          'City, Country',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          address[index],
                          style: Theme.of(context).textTheme.bodyText1,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Radio<String>(
                          value: address[index],
                          groupValue: _addressValue,
                          onChanged: (value) {
                            setState(() {
                              _addressValue = value!;
                              debugPrint('Address: $_addressValue');
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Edit',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
              Navigator.of(context).pushNamed(AppRouter.newaddress);
            },
            child: const Text('+ Add New Address'),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: address.length + 1,
      ),
      bottomNavigationBar: Container(
        height: 160,
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
          children: [
            Column(
              children: [
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
              ],
            ),
            ElevatedButton(
              onPressed: () {},
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
