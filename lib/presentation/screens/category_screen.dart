import 'package:flutter/material.dart';

import '../../data/models/category.dart';
import '../../data/models/product.dart';
import '../../services/firestore_services.dart';
import '../widgets/product_card.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<List<Product>>(
          stream: FireStoreServices().getProducts(),
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
            var productsInCategory = snapshot.data!
                .where((doc) => doc.category == category.name)
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    category.name,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: productsInCategory.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisExtent: 230,
                    mainAxisSpacing: 30,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: productsInCategory[index],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
