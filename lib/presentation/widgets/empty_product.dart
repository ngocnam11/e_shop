import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyProduct extends StatelessWidget {
  const EmptyProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SvgPicture.asset(
            'assets/svgs/empty_box.svg',
            height: 220,
            width: 220,
          ),
          Text(
            'Add some stuff 👀',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}
