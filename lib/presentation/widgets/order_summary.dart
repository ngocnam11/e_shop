import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/blocs/cart/cart_bloc.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CartLoaded) {
          return Column(
            children: <Widget>[
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
                    '\$${state.cart.subtotalString}',
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
                    '\$0',
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
                    '\$${state.cart.deliveryFeeString}',
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
                    '\$${state.cart.totalString}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ],
          );
        }
        return const Text('Something went wrong');
      },
    );
  }
}
