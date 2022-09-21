import 'package:flutter/material.dart';

import '../models/user.dart';
import '../router/router.dart';
import '../services/auth_services.dart';
import '../services/firestore_services.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.address),
      builder: (_) => const DeliveryAddressScreen(),
    );
  }

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  Future<void> getInitAddress() async {
    final user = await FireStoreServices()
        .getUserByUid(uid: AuthServices().currentUser.uid);
    _addressValue =
        user.addresses.isNotEmpty ? user.addresses[0].toString() : '';
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
              debugPrint(snapshot.error.toString());
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
                                value:
                                    snapshot.data!.addresses[index].toString(),
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
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(
                                    AppRouter.editAddress,
                                    arguments: snapshot.data!.addresses[index],
                                  )
                                      .then((value) {
                                    final bool? refresh = value as bool?;
                                    if (refresh ?? false) {
                                      setState(() {});
                                    }
                                  });
                                },
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
                    Navigator.of(context)
                        .pushNamed(AppRouter.newAddress)
                        .then((value) {
                      final bool? refresh = value as bool?;
                      if (refresh ?? false) {
                        setState(() {});
                      }
                    });
                  },
                  child: const Text('+ Add New Address'),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: snapshot.data!.addresses.length + 1,
            );
          }),
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
          onPressed: () {
            Navigator.of(context).pop(
              _addressValue,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent.shade100,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('Continue'),
        ),
      ),
    );
  }
}
