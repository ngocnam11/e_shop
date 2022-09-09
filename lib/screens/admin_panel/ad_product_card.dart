import 'package:flutter/material.dart';

import '../../config/utils.dart';
import '../../services/firestore_services.dart';
import '../../widgets/custom_network_image.dart';
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

    if (!mounted) return;

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
                CustomNetworkImage(
                  src: widget.snap['imageUrl'],
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
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
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AdEditProductScreen(
                              id: widget.snap['id'],
                            ),
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
                            title: const Text(
                              'You are about to delete a product',
                            ),
                            titleTextStyle: theme.headline5,
                            content: Text(
                              'This will delete your product \nAre you sure?',
                              style: theme.headline6!.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  deleteProduct();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
