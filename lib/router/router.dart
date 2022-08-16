import 'package:flutter/material.dart';

import '../screens/screens.dart';

abstract class AppRouter {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String notification = '/notification';
  static const String profile = '/profile';

  static Route onGenerateRoute(RouteSettings settings) {
    debugPrint('Route: ${settings.name}');
    switch (settings.name) {
      case login:
        return _materialPageRoute(settings, LoginScreen());
      case signup:
        return _materialPageRoute(settings, SignupScreen());
      case home:
        return _materialPageRoute(settings, HomeScreen());
      default:
        return _materialPageRoute(
          settings,
          Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
          ),
        );
    }
  }

  static MaterialPageRoute _materialPageRoute(
    RouteSettings settings,
    Widget widget,
  ) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => widget,
    );
  }
}
