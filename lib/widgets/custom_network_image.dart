import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    Key? key,
    required this.src,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  final String src;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      image: src,
      placeholder: 'assets/images/placeholder.jpg',
      width: width ?? double.maxFinite,
      height: height ?? double.maxFinite,
      fit: fit,
      placeholderFit: fit,
      imageErrorBuilder: (context, error, stackTrace) {
        debugPrint(error.toString());
        return Image.asset(
          'assets/images/error.jpg',
          width: width ?? double.maxFinite,
          height: height ?? double.maxFinite,
          fit: fit,
        );
      },
    );
  }
}
