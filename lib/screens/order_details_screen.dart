import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
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
        children: [
          Text(
            'Thanks for shopping!',
            style: Theme.of(context).textTheme.headline4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[300],
                    ),
                    child: const Icon(Icons.local_mall_outlined),
                  ),
                  Text(
                    'Order confirmed',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[300],
                    ),
                    child: const Icon(Icons.local_shipping_outlined),
                  ),
                  Text(
                    'Order shipment',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[300],
                    ),
                    child: const Icon(Icons.inventory_2_outlined),
                  ),
                  Text(
                    'Package arrived',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ],
          ),
          Text(
            'Order Code #123456',
            style: Theme.of(context).textTheme.headline5,
          ),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is CartLoaded) {
                return Text('abc');
              } else {
                return const Text('Something went wrong');
              }
            },
          )
        ],
      ),
    );
  }
}
