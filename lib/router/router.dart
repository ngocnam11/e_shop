import 'package:flutter/material.dart';

import '../models/delivery_address.dart';
import '../models/product.dart';
import '../screens/screens.dart';

abstract class AppRouter {
  static const String home = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot_password';
  static const String signup = '/signup';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String address = '/address';
  static const String newAddress = '/address/new';
  static const String editAddress = '/address/edit';
  static const String wishlist = '/wishlist';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String notification = '/notification';
  static const String product = '/product';
  static const String orderConfirm = '/order_confirm';
  static const String account = '/account';
  static const String purchase = '/purchase';
  static const String newCard = '/new_card';
  static const String admin = '/admin';
  static const String adminProduct = '/admin/product';
  static const String adminNewProduct = '/admin/product/new';
  static const String adminOrder = '/admin/order';

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
        return CheckoutScreen.route(
          productInCart: settings.arguments as List<Product>,
        );
      case address:
        return DeliveryAddressScreen.route();
      case newAddress:
        return NewAddressScreen.route();
      case editAddress:
        return EditAddressScreen.route(
          address: settings.arguments as DeliveryAddress,
        );
      case wishlist:
        return WishlistScreen.route();
      case chat:
        return ChatScreen.route();
      case profile:
        return ProfileScreen.route();
      case notification:
        return NotificationScreen.route();
      case product:
        return ProductScreen.route(product: settings.arguments);
      case orderConfirm:
        return OrderConfirmScreen.route();
      case account:
        return MyAccountScreen.route();
      case purchase:
        return PurchaseScreen.route();
      case newCard:
        return NewCardScreen.route();
      case admin:
        return AdHomeScreen.route();
      case adminProduct:
        return AdProductScreen.route();
      case adminNewProduct:
        return NewProductScreen.route();
      case adminOrder:
        return AdOrderScreen.route();
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
