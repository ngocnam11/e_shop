import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/custom_navigationbar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.chat),
      builder: (_) => const ChatScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Chat'),
      bottomNavigationBar: CustomNavigationBar(
        currentRoute: AppRouter.chat,
      ),
    );
  }
}
