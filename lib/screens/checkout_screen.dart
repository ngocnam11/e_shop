import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../config/utils.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../router/router.dart';
import '../services/auth_services.dart';
import '../services/firestore_services.dart';
import '../widgets/list_item.dart';
import '../widgets/order_summary.dart';
import 'delivery_address_screen.dart';
import 'order_confirmation/order_confirm_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key, required this.productInCart})
      : super(key: key);

  static MaterialPageRoute route({required List<Product> productInCart}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.checkout),
      builder: (_) => CheckoutScreen(
        productInCart: productInCart,
      ),
    );
  }

  final List<Product> productInCart;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // late Cart cart;

  // void addOrder() async {
  //   String res = await FireStoreServices().addOrder(
  //     customerId: AuthServices().currentUser.uid,
  //     sellerId: sellerId,
  //     products: cart.products,
  //     deliveryAddress: deliveryAddress,
  //     subtotal: cart.subtotal,
  //     deliveryFee: double.parse(cart.deliveryFeeString),
  //     total: double.parse(cart.totalString),
  //   );

  //   if (!mounted) return;

  //   if (res != 'success') {
  //     showSnackBar(context, res);
  //   } else {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) => const OrderConfirmScreen(),
  //       ),
  //     );
  //   }
  // }

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
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DeliveryAddressScreen(),
                    ),
                  );
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
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.red,
                              ),
                              Text(
                                'Delivery Address',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(color: Colors.blue[300]),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: SizedBox(
                              height: 24,
                              child: FutureBuilder<User>(
                                future: FireStoreServices().getUserByUid(
                                    uid: AuthServices().currentUser.uid),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return const Text('Something went wrong');
                                  }
                                  return Text(
                                    '${snapshot.data!.username} | (${snapshot.data!.phoneNum})',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Text(
                              'delivery address',
                              style: Theme.of(context).textTheme.headline4,
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
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          FutureBuilder<User>(
                            future: FireStoreServices().getUserByUid(
                                uid: products.keys.elementAt(index).uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  snapshot.data!.username,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          ListItem(
                            product: products.keys.elementAt(index),
                            child: const SizedBox(
                              width: 64,
                              height: 40,
                            ),
                          ),
                        ],
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
            Padding(
              padding: const EdgeInsets.all(12),
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.local_shipping_outlined),
                      Text(
                        'Delivery Method',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text(
                        'EShopExpress',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const Icon(Icons.navigate_next),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRouter.purchase);
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.monetization_on_outlined),
                      Text(
                        'Payment Method',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text(
                        'Cash Money',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const Icon(Icons.navigate_next),
                    ],
                  ),
                ),
              ),
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
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent.shade100,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OrderConfirmScreen(),
              ),
            );
          },
          child: Text(
            'Order Now',
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
