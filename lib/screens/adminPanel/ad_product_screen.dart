import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ad_product_card.dart';
import 'new_product_screen.dart';

class AdProductScreen extends StatefulWidget {
  const AdProductScreen({Key? key}) : super(key: key);

  @override
  State<AdProductScreen> createState() => _AdProductScreenState();
}

class _AdProductScreenState extends State<AdProductScreen> {
  final TextEditingController searchController = TextEditingController();
  bool searchProducts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // SearchBar(
            //   controller: searchController,
            //   hintText: 'Search a product',
            //   press: () {
            //     setState(() {
            //       searchProducts = true;
            //     });
            //   },
            // ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: Card(
                margin: EdgeInsets.zero,
                color: Colors.black,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NewProductScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
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
                      )
                    ],
                  ),
                ),
              ),
            ),
            searchProducts
                ? FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('products')
                        .where(
                          'name',
                          isGreaterThanOrEqualTo: searchController.text,
                        )
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 210,
                                child: AdProductCard(
                                  snap: (snapshot.data! as dynamic)
                                      .docs[index]
                                      .data(),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const Text('Something went wrong');
                    },
                  )
                : FutureBuilder(
                    future:
                        FirebaseFirestore.instance.collection('products').get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 210,
                                child: AdProductCard(
                                  snap: (snapshot.data! as dynamic)
                                      .docs[index]
                                      .data(),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const Text('Something went wrong');
                    },
                  ),
          ],
        ),
      ),
    );
  }
}