import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, required this.press});

  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headline2,
        ),
        TextButton(
          onPressed: press,
          child: Text(
            'View all',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ],
    );
  }
}
