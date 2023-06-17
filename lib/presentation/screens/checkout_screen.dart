import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/order.dart';
import '../../data/models/product.dart';
import '../../data/models/user.dart';
import '../../logic/blocs/blocs.dart';
import '../../services/auth_services.dart';
import '../../services/firestore_services.dart';
import '../router/app_router.dart';
import '../widgets/checkout_option.dart';
import '../widgets/list_item.dart';
import '../widgets/order_summary.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, this.deliveryAddress});

  static Route route({required String deliveryAddress}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.checkout),
      builder: (_) => CheckoutScreen(deliveryAddress: deliveryAddress),
    );
  }

  final String? deliveryAddress;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Future<Product> getInitProduct(String id) async {
    final product = await FireStoreServices().getProductById(id: id);
    return product;
  }

  String deliveryAddress = 'Choose delivery address';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AppRouter.address)
                      .then((value) {
                    deliveryAddress = value.toString();
                    setState(() {});
                  });
                },
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.red,
                              ),
                              Text(
                                'Delivery Address',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(color: Colors.blue[300]),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: SizedBox(
                              height: 24,
                              child: FutureBuilder<UserModel>(
                                future: FireStoreServices().getUserByUid(
                                  uid: AuthServices().currentUser.uid,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    debugPrint(snapshot.error.toString());
                                    return const Text('Something went wrong');
                                  }
                                  return Text(
                                    '${snapshot.data!.username} | (${snapshot.data!.phoneNum})',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Text(
                              deliveryAddress,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.navigate_next),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                if (state is CheckoutLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CheckoutLoaded) {
                  final products =
                      state.checkout.productQuantity(state.checkout.products);
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Divider(),
                          FutureBuilder<UserModel>(
                            future: FireStoreServices().getUserByUid(
                                uid: products.keys.elementAt(index).sellerId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                debugPrint(snapshot.error.toString());
                                return const Text('Something went wrong');
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  snapshot.data!.username,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          ListItem(
                            product: products.keys.elementAt(index),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                  );
                } else {
                  return const Text('Something went wrong');
                }
              },
            ),
            CheckoutOption(
              option: 'Delivery Method',
              title: 'EshopExpress',
              icon: const Icon(Icons.local_shipping_outlined),
              onTap: () {},
            ),
            CheckoutOption(
              option: 'Payment Method',
              title: 'Cash Money',
              icon: const Icon(Icons.monetization_on_outlined),
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.purchase);
              },
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: OrderSummary(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
            ),
          ],
        ),
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CheckoutLoaded) {
              final products =
                  state.checkout.productQuantity(state.checkout.products);
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  final product = products.keys.first;
                  final subtotal = product.price * product.quantity;
                  final productInfo = await getInitProduct(product.productId);
                  if (!mounted) return;
                  context.read<OrderBloc>().add(
                        AddOrder(
                          OrderModel(
                            id: '',
                            customerId: AuthServices().currentUser.uid,
                            sellerId: product.sellerId,
                            products: [
                              productInfo.copyWith(
                                quantity: product.quantity,
                                colors: [product.color!],
                                sizes: [product.size!],
                              )
                            ],
                            paymentMethod: 'Cash Money',
                            deliveryAddress: deliveryAddress,
                            deliveryFee: subtotal > 30 ? 0.0 : 10.0,
                            subtotal: subtotal,
                            total: subtotal > 30 ? subtotal : subtotal + 10,
                            orderStatus: 'Pending',
                            createdAt: Timestamp.now(),
                          ),
                        ),
                      );
                  context.read<CartBloc>().add(DeleteProduct(product));
                  Navigator.of(context).pushNamed(AppRouter.orderConfirm);
                },
                child: Text(
                  'Order Now',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Colors.white),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
