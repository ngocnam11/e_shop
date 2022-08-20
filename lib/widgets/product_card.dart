import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            Container(
              height: 160,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey,
              ),
              child: Text(''),
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
          'Product name',
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          'Description',
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          '\$Price',
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );
  }
}