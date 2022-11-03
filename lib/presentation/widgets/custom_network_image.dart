import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.fit,
    this.isCurrentUserAvatar = false,
  });

  final String src;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isCurrentUserAvatar;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      src,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Image.asset(
          'assets/images/placeholder.jpg',
          width: width ?? double.maxFinite,
          height: height ?? double.maxFinite,
          fit: fit,
        );
      },
      width: width ?? double.maxFinite,
      height: height ?? double.maxFinite,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        debugPrint(error.toString());
        return Image.asset(
          isCurrentUserAvatar
              ? 'assets/images/default_avatar.png'
              : 'assets/images/error.jpg',
          width: width ?? double.maxFinite,
          height: height ?? double.maxFinite,
          fit: fit,
        );
      },
    );
  }
}
