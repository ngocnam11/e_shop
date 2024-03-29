import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/user.dart';
import '../../../services/auth_services.dart';
import '../../../services/firestore_services.dart';
import '../../router/app_router.dart';
import '../../widgets/order_summary.dart';

class OrderConfirmScreen extends StatefulWidget {
  const OrderConfirmScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.orderConfirm),
      builder: (_) => const OrderConfirmScreen(),
    );
  }

  @override
  State<OrderConfirmScreen> createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen> {
  static const String orderIdKey = 'orderId';
  String orderId = '';
  @override
  void initState() {
    getOrderId();
    super.initState();
  }

  void getOrderId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(orderIdKey)) {
      final id = prefs.getString(orderIdKey);
      if (id != null) {
        orderId = id;
      } else {
        orderId = '';
      }
    }
  }

  void removeOrderId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(orderIdKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder<UserModel>(
            future: FireStoreServices().getUserByUid(
              uid: AuthServices().currentUser.uid,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SvgPicture.asset(
                        'assets/svgs/order/success.svg',
                        height: 80,
                        width: 80,
                      ),
                    ),
                    Text(
                      'Hey ${snapshot.data!.username},',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      'Thanks for your purchase',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Divider(),
                    const OrderSummary(),
                    Text('Order $orderId'),
                  ],
                );
              } else {
                debugPrint(snapshot.error.toString());
                return const Text('Something went wrong');
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouter.home,
              (route) => false,
            );
            removeOrderId();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blueAccent.shade100,
          ),
          child: const Text('Continue Shopping'),
        ),
      ),
    );
  }
}
