import 'package:flutter/material.dart';

import 'product_card.dart';

class ProductCarousel extends StatelessWidget {
  const ProductCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return ProductCard();
        },
        separatorBuilder: (context, index) => const SizedBox(width: 24),
      ),
    );
  }
}


