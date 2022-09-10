import 'package:flutter/material.dart';

import '../models/user.dart';
import '../router/router.dart';
import '../services/auth_services.dart';
import '../services/firestore_services.dart';
import '../widgets/order_summary.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  Future<void> getInitAddress() async {
    final user = await FireStoreServices()
        .getUserByUid(uid: AuthServices().currentUser.uid);
    _addressValue = user.addresses.isNotEmpty ? user.addresses[0].address : '';
  }

  late String _addressValue;

  @override
  void initState() {
    super.initState();
    getInitAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Address'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: FutureBuilder<User>(
          future: FireStoreServices()
              .getUserByUid(uid: AuthServices().currentUser.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemBuilder: (context, index) {
                if (index != snapshot.data!.addresses.length) {
                  return Container(
                    height: 70,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Text>[
                              Text(
                                snapshot.data!.addresses[index].address,
                                style: Theme.of(context).textTheme.headline4,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              Text(
                                '${snapshot.data!.addresses[index].city}, ${snapshot.data!.addresses[index].country}',
                                style: Theme.of(context).textTheme.headline5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Expanded(
                              child: Radio<String>(
                                value: snapshot.data!.addresses[index].address,
                                groupValue: _addressValue,
                                onChanged: (value) {
                                  setState(() {
                                    _addressValue = value!;
                                    debugPrint('Address: $_addressValue');
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Edit',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRouter.newaddress);
                  },
                  child: const Text('+ Add New Address'),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: snapshot.data!.addresses.length + 1,
            );
          }),
      bottomNavigationBar: Container(
        height: 170,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
          top: 10,
        ),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 7,
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const OrderSummary(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRouter.checkout,
                  // arguments: _addressValue,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                primary: Colors.blueAccent.shade100,
                fixedSize: const Size.fromWidth(500),
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
