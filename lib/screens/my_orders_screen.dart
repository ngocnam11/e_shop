import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';
import '../router/router.dart';
import '../services/firestore_services.dart';
import '../widgets/custom_network_image.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.myOrders),
      builder: (_) => const MyOrdersScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Order>>(
        stream: FireStoreServices().getCurrentUserOrders(),
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
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CustomNetworkImage(
                            src: snapshot.data![index].products[0].imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '#${snapshot.data![index].id}',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                Text(
                                  snapshot.data![index].orderStatus,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'EShopExpress',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                Text(
                                  DateFormat('dd-MM-yy').format(
                                      snapshot.data![index].createdAt.toDate()),
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 160,
                              child: Text(
                                snapshot.data![index].products[0].name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${snapshot.data![index].total}',
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(AppRouter.orderDetails);
                                  },
                                  child: Text(
                                    'Track',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: 12,
            ),
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }
}
