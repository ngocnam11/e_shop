import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PurchaseItem extends StatelessWidget {
  const PurchaseItem({
    super.key,
    required this.svgIconPath,
    required this.title,
    this.subTitle,
    required this.trailing,
  });

  final String svgIconPath;
  final Widget title;
  final Widget? subTitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          child: FittedBox(
            child: SvgPicture.asset(
              svgIconPath,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              title,
              const SizedBox(height: 8),
              subTitle ?? const SizedBox(),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}
