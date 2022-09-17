import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/utils.dart';
import '../../models/order.dart';
import '../../router/router.dart';
import '../../services/firestore_services.dart';
import '../../widgets/custom_network_image.dart';

class AdOrderScreen extends StatelessWidget {
  const AdOrderScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.adminOrder),
      builder: (_) => const AdOrderScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Order>>(
                stream: FireStoreServices().getOrdersOfSellerId(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                    return const Text('Something went wrong');
                  }
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return OrderCard(
                        order: snapshot.data![index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 12),
                  );
                }),
          )
        ],
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  const OrderCard({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  void updateOrderStatus({required String orderStatus}) async {
    String res = await FireStoreServices().updateOrderStatus(
      id: widget.order.id,
      orderStatus: orderStatus,
    );
    if (!mounted) return;

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      showSnackBar(context, 'Order  is $orderStatus');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.order.id,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd-MM-yy')
                        .format(widget.order.createdAt.toDate()),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.order.products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        CustomNetworkImage(
                          src: widget.order.products[index].imageUrl,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.order.products[index].name,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.order.products[index].description,
                              style: Theme.of(context).textTheme.headline5,
                              overflow: TextOverflow.clip,
                              maxLines: 2,
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Delivery Fee',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        '${widget.order.deliveryFee}',
                        style: Theme.of(context).textTheme.headline4,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        '${widget.order.total}',
                        style: Theme.of(context).textTheme.headline4,
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => updateOrderStatus(orderStatus: 'Accepted'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Accept'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        updateOrderStatus(orderStatus: 'Cancelled'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Cancel'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
