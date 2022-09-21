import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../router/router.dart';
import '../widgets/list_item.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.orderDetails),
      builder: (_) => const OrderDetailsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Thanks for shopping!',
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: Colors.blue),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Thank you so much for your order.'
              '\nWe really appreciate you supporting'
              '\nour small business!'
              '\nWe hope you love your order!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[300],
                    ),
                    child: const Icon(
                      Icons.local_mall_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order confirmed',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[100],
                    ),
                    child: const Icon(Icons.local_shipping_outlined),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order shipment',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[100],
                    ),
                    child: const Icon(Icons.inventory_2_outlined),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Package arrived',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '#ORD2022Y9M17ES',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is CartLoaded) {
                final products =
                    state.cart.productQuantity(state.cart.products);
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: products.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListItem(
                      product: products.keys.elementAt(index),
                      child: SizedBox(
                        width: 80,
                        height: 24,
                        child: Text(
                          'Quantity: 1',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                );
              } else {
                return const Text('Something went wrong');
              }
            },
          ),
        ],
      ),
    );
  }
}
