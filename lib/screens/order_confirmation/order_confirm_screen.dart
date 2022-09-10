import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/user.dart';
import '../../router/router.dart';
import '../../services/auth_services.dart';
import '../../services/firestore_services.dart';
import '../../widgets/order_summary.dart';
import '../order_details_screen.dart';

class OrderConfirmScreen extends StatelessWidget {
  const OrderConfirmScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.orderConfirm),
      builder: (_) => const OrderConfirmScreen(),
    );
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
          child: FutureBuilder<User>(
            future: FireStoreServices().getUserByUid(
              uid: AuthServices().currentUser.uid,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
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
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(
                      'Thanks for your purchase',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const Divider(),
                    const OrderSummary(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const OrderDetails(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size.fromWidth(double.maxFinite),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        primary: Colors.indigo,
                      ),
                      child: const Text('Track Your Order'),
                    ),
                    const Text('Order #123456'),
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
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            primary: Colors.blueAccent.shade100,
          ),
          child: const Text('Continue Shopping'),
        ),
      ),
    );
  }
}
