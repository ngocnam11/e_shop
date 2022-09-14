import 'package:flutter/material.dart';

import '../models/product.dart';
import 'custom_network_image.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.child,
    required this.product,
  }) : super(key: key);

  final Widget child;
  final Product product;

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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomNetworkImage(
                src: product.imageUrl,
                height: 100,
                width: 100,
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
                          product.name,
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
                  product.colors.isEmpty && product.size.isEmpty
                      ? const SizedBox()
                      : Text(
                          '${product.colors[0]}, ${product.size[0]}',
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
        ),
      ),
    );
  }
}
