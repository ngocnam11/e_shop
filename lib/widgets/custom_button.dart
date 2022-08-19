import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.svg,
    required this.title,
    required this.primaryColor,
    required this.press,
    required this.textColor,
  }) : super(key: key);

  final String svg;
  final String title;
  final Color primaryColor;
  final VoidCallback press;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 10,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svg,
            width: 18,
            height: 18,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 5),
          Text(
            title,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }
}
