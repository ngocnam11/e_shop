import 'package:flutter/material.dart';

import '../../config/utils.dart';
import '../../services/firestore_services.dart';
import 'ad_edit_product_screen.dart';
import 'ad_home_screen.dart';

class AdProductCard extends StatefulWidget {
  const AdProductCard({Key? key, required this.snap}) : super(key: key);
  final snap;

  @override
  State<AdProductCard> createState() => _AdProductCardState();
}

class _AdProductCardState extends State<AdProductCard> {
  void deleteProduct() async {
    String res = await FireStoreServices().deleteProduct(id: widget.snap['id']);
    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AdHomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.snap['name'],
              style: theme.headline4,
            ),
            const SizedBox(height: 10),
            Text(
              widget.snap['description'],
              style: theme.bodyText1,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.network(
                    widget.snap['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 50,
                                child: Text(
                                  'Price:',
                                  style: theme.headline5,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '\$${widget.snap['price']}',
                                style: theme.headline5,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 50,
                                child: Text(
                                  'Qty.',
                                  style: theme.headline5,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${widget.snap['quantity']}',
                                style: theme.headline4,
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AdEditProductScreen(id: widget.snap['id'],),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Product'),
                                  content: const Text(
                                      'Do you want to delete this product?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel', style: TextStyle(color: Colors.black),),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteProduct();
                                      },
                                      child: const Text('OK', style: TextStyle(color: Colors.black),),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}