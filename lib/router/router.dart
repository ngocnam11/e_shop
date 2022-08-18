import 'package:flutter/material.dart';

import '../screens/screens.dart';

abstract class AppRouter {
  static const String home = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot_password';
  static const String signup = '/signup';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String notification = '/notification';

  static Route onGenerateRoute(RouteSettings settings) {
    debugPrint('Route: ${settings.name}');
    switch (settings.name) {
      case home:
        return _materialPageRoute(settings, HomeScreen());
      case login:
        return _materialPageRoute(settings, LoginScreen());
      case forgotPassword:
        return _materialPageRoute(settings, ForgotPasswordScreen());
      case signup:
        return _materialPageRoute(settings, SignupScreen());
      case search:
        return _materialPageRoute(settings, SearchScreen());
      case cart:
        return _materialPageRoute(settings, CartScreen());
      case wishlist:
        return _materialPageRoute(settings, WishlistScreen());
      case chat:
        return _materialPageRoute(settings, ChatScreen());
      case profile:
        return _materialPageRoute(settings, ProfileScreen());
      case notification:
        return _materialPageRoute(settings, NotificationScreen());
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
