import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import 'product_card.dart';

class ProductCarousel extends StatelessWidget {
  const ProductCarousel({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: products[index],
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 24),
      ),
    );
  }
}
