import 'package:flutter/material.dart';

import '../../data/models/cart.dart';
import '../../data/models/order.dart';
import '../router/app_router.dart';
import '../widgets/list_item.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.order});

  static Route route({required OrderModel order}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.orderDetails),
      builder: (_) => OrderDetailsScreen(
        order: order,
      ),
    );
  }

  final OrderModel? order;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: <Widget>[
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
        children: <Widget>[
          Center(
            child: Text(
              'Thanks for shopping!',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
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
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
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
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
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
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
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
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              widget.order!.id,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: widget.order!.products.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListItem(
                product: CartItem(
                  id: 'ci${widget.order!.products[index].id}',
                  productId: widget.order!.products[index].id,
                  price: widget.order!.products[index].price,
                  quantity: widget.order!.products[index].quantity,
                  sellerId: widget.order!.products[index].uid,
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          ),
        ],
      ),
    );
  }
}
