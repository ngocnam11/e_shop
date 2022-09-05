import 'package:flutter/foundation.dart';

class GoogleClientIdOptions {
  static String? get currentPlatform {
    if (kIsWeb) {
      return '5975695317-6eo1094go1gn6vrn5iq0ksjd6ojnmmm4.apps.googleusercontent.com';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return null;
      case TargetPlatform.iOS:
        return '5975695317-roi2re0ggd68urlgtc72fhlu9lijoa84.apps.googleusercontent.com';
      default:
        throw UnsupportedError('Not support this platform.');
    }
  }
}
