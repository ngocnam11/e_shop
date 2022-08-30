import 'package:flutter/material.dart';

import '../screens/screens.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              product: product,
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image(
                  height: 160,
                  width: 150,
                  image: NetworkImage(
                    product['imageUrl'],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    shape: BoxShape.circle,
                  ),
                  child: FittedBox(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_outline,
                        color: Colors.red[400],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            product['name'],
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            product['description'],
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            '\$${product['price']}',
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
