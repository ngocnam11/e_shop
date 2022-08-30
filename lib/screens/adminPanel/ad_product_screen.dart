import 'package:firebase_auth/firebase_auth.dart';
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            // SearchBar(
            //   controller: searchController,
            //   hintText: 'Search a product',
            //   press: () {
            //     setState(() {
            //       searchProducts = true;
            //     });
            //   },
            // ),
            Ink(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NewProductScreen(),
                    ),
                  );
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
                    future: FirebaseFirestore.instance
                        .collection('products')
                        .where(
                          'uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
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
                                height: 170,
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
