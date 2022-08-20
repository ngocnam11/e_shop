import 'package:flutter/material.dart';

import '../router/router.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.checkout),
      builder: (_) => const CheckoutScreen(),
    );
  }

  final int countItem = 5;

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
          if (index != countItem) {
            return Container(
              height: 70,
              width: double.maxFinite,
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
                          'A very loooo oooo oooooo oooooo oooo ong Address',
                          style: Theme.of(context).textTheme.bodyText1,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          // softWrap: false,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Checkbox(
                          value: true,
                          onChanged: (value) {},
                        ),
                      ),
                      Expanded(
                        flex: 1,
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
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.newaddress);
            },
            child: Text('+ Add New Address'),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: (countItem + 1),
      ),
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 24),
      //   child: Container(
      //     width: double.infinity,
      //     height: 80,
      //     color: Colors.grey.shade200,
      //     child: Row(
      //       children: [
      //         Icon(Icons.location_on_outlined),
      //         SizedBox(width: 8),
      //         Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               'City',
      //               style: Theme.of(context).textTheme.headline5,
      //             ),
      //             Text(
      //               'this is an address',
      //               style: Theme.of(context).textTheme.headline6,
      //             ),
      //           ],
      //         ),
      //         Column(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Checkbox(
      //               value: false,
      //               onChanged: (value) {},
      //             ),
      //
      //           ],
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 150,
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
                    vertical: 16,
                  ),
                  primary: Colors.blueAccent.shade100,
                  fixedSize: const Size.fromWidth(500),
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
