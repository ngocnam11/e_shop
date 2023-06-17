import 'package:flutter/material.dart';

class CheckoutOption extends StatelessWidget {
  const CheckoutOption({
    super.key,
    required this.option,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String option;
  final String title;
  final Widget icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              icon,
              Text(
                option,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Icon(Icons.navigate_next),
            ],
          ),
        ),
      ),
    );
  }
}
