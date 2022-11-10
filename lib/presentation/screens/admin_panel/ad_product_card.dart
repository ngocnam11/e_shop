import 'package:flutter/material.dart';

import '../../../config/utils.dart';
import '../../../data/models/product.dart';
import '../../../services/firestore_services.dart';
import '../../router/app_router.dart';
import '../../widgets/custom_network_image.dart';

class AdProductCard extends StatefulWidget {
  const AdProductCard({super.key, required this.product});
  final Product product;

  @override
  State<AdProductCard> createState() => _AdProductCardState();
}

class _AdProductCardState extends State<AdProductCard> {
  void deleteProduct() async {
    String res = await FireStoreServices().deleteProduct(id: widget.product.id);

    if (!mounted) return;

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      showSnackBar(context, 'Product deleted!');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.product.name,
              style: theme.headline4,
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.description,
              style: theme.bodyText1,
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                CustomNetworkImage(
                  src: widget.product.imageUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 60,
                            child: Text(
                              'Price:',
                              style: theme.headline5,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '\$${widget.product.price}',
                            style: theme.headline5,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 60,
                            child: Text(
                              'Quantity:',
                              style: theme.headline5,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.product.quantity.toString(),
                            style: theme.headline5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                        AppRouter.adminEditProduct,
                        arguments: widget.product.id,
                      ),
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            'You are about to delete a product',
                          ),
                          titleTextStyle: theme.headline5,
                          content: const Text(
                            'This will delete your product \nAre you sure?',
                          ),
                          actions: <Widget>[
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
                      ),
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
