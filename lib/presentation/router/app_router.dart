import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/models/delivery_address.dart';
import '../../data/models/order.dart';
import '../../data/models/product.dart';
import '../screens/screens.dart';

class AppRouter {
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
  static const String selectOptions = '/select_options';
  static const String orderConfirm = '/order_confirm';
  static const String account = '/account';
  static const String changePassword = '/account/change_password';
  static const String myOrders = '/my_orders';
  static const String orderDetails = '/order_details';
  static const String purchase = '/purchase';
  static const String newCard = '/new_card';
  static const String admin = '/admin';
  static const String adminProduct = '/admin/product';
  static const String adminNewProduct = '/admin/product/new';
  static const String adminEditProduct = '/admin/product/edit';
  static const String adminOrder = '/admin/order';

  static String get initialRoute =>
      FirebaseAuth.instance.currentUser == null ? login : home;

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
          deliveryAddress: settings.arguments as String,
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
        return ProductScreen.route(product: settings.arguments as Product);
      case selectOptions:
        return SelectOptionsScreen.route(
          options: settings.arguments as Map<String, dynamic>,
        );
      case orderConfirm:
        return OrderConfirmScreen.route();
      case account:
        return MyAccountScreen.route();
      case changePassword:
        return ChangePasswordScreen.route();
      case myOrders:
        return MyOrdersScreen.route();
      case orderDetails:
        return OrderDetailsScreen.route(order: settings.arguments as OrderModel);
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
      case adminEditProduct:
        return AdEditProductScreen.route(id: settings.arguments as String);
      case adminOrder:
        return AdOrderScreen.route();
      default:
        return NotFoundScreen.route();
    }
  }
}
