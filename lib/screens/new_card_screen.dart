import 'package:flutter/material.dart';

import '../router/router.dart';

class NewCardScreen extends StatelessWidget {
  const NewCardScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.newCard),
      builder: (_) => const NewCardScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
