import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.child,
    required this.product,
    required this.index,
  }) : super(key: key);

  final Widget child;
  final Map<String, dynamic> product;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: Text('image')),
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
                          product.keys.elementAt(index),
                          style: Theme.of(context).textTheme.headline5,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Checkbox(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                  Text(
                    product.values.elementAt(index),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$Price',
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
