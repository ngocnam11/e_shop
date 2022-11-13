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
    return FadeInImage.assetNetwork(
      image: src,
      placeholder: 'assets/images/placeholder.jpg',
      width: width ?? double.maxFinite,
      height: height ?? double.maxFinite,
      fit: fit,
      placeholderFit: fit,
      fadeOutDuration: const Duration(milliseconds: 500),
      imageErrorBuilder: (context, error, stackTrace) {
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
