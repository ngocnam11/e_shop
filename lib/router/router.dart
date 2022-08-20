import 'package:flutter/material.dart';

import '../screens/screens.dart';

abstract class AppRouter {
  static const String home = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot_password';
  static const String signup = '/signup';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String newaddress = '/new_address';
  static const String wishlist = '/wishlist';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String notification = '/notification';

  static Route onGenerateRoute(RouteSettings settings) {
    debugPrint('Route: ${settings.name}');

    switch (settings.name) {
      case home:
        return HomeScreen.route();
      case login:
        return LoginScreen.route();
      case forgotPassword:
        return ForgotPasswordScreen.route();
      case signup:
        return SignupScreen.route();
      case search:
        return SearchScreen.route();
      case cart:
        return CartScreen.route();
      case checkout:
        return CheckoutScreen.route();
      case newaddress:
        return NewAddressScreen.route();
      case wishlist:
        return WishlistScreen.route();
      case chat:
        return ChatScreen.route();
      case profile:
        return ProfileScreen.route();
      case notification:
        return NotificationScreen.route();
      default:
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/error'),
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: const Center(
              child: Text('Something went wrong!'),
            ),
          ),
        );
    }
  }
}
