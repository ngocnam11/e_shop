import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/custom_navigationbar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Chat'),
      bottomNavigationBar: const CustomNavigationBar(
        currentRoute: AppRouter.chat,
      ),
    );
  }
}
