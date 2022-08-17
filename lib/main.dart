import 'package:flutter/material.dart';

import 'config/theme.dart';
import 'router/router.dart';
import 'screens/order_confirmation/order_confirm_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter eShop',
      theme: theme(),
      home: OrderConfirmScreen(),
      // initialRoute: AppRouter.login,
      // onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
