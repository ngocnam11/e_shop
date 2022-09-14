import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/product.dart';
import '../services/firestore_services.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.child,
    required this.product,
  }) : super(key: key);

  final Widget child;
  final CartItem product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<Product>(
          future: FireStoreServices().getProductById(id: product.productId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            return Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image(
                    height: 100,
                    width: 100,
                    image: NetworkImage(
                      snapshot.data!.imageUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              snapshot.data!.name,
                              style: Theme.of(context).textTheme.headline4,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Checkbox(
                          //   value: false,
                          //   onChanged: (value) {},
                          // ),
                          const SizedBox(
                            height: 32,
                            width: 32,
                          ),
                        ],
                      ),
                      Text(
                        '${product.color![0]}, ${product.size![0]}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${product.price}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          child,
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
