import 'package:flutter/material.dart';

import '../../../data/models/product.dart';
import '../../../services/firestore_services.dart';
import '../../router/app_router.dart';
import 'ad_product_card.dart';

class AdProductScreen extends StatefulWidget {
  const AdProductScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.adminProduct),
      builder: (_) => const AdProductScreen(),
    );
  }

  @override
  State<AdProductScreen> createState() => _AdProductScreenState();
}

class _AdProductScreenState extends State<AdProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: <Widget>[
            Ink(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AppRouter.adminNewProduct)
                      .then((value) {
                    final bool? refresh = value as bool?;
                    if (refresh ?? false) {
                      setState(() {});
                    }
                  }).asStream();
                },
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.add_circle,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Add a New Product',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder<List<Product>>(
              stream: FireStoreServices().getCurrentUserProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 180,
                          child: AdProductCard(
                            product: snapshot.data![index],
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
