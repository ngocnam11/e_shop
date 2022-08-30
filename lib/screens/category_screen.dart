import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/product_card.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key, required this.category}) : super(key: key);
  final dynamic category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream:
                FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              var productsInCategory = snapshot.data!.docs
                  .where((doc) => doc.data()['category'] == category['name'])
                  .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      category['name'],
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  SizedBox(
                    height: 600,
                    child: GridView.builder(
                      itemCount: productsInCategory.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: productsInCategory[index],
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
