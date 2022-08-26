import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/custom_navigationbar.dart';
import '../widgets/list_conversation.dart';
import '../widgets/text_field_input.dart';

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
    final searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 4,
            ),
            child: TextFieldInput(
              controller: searchController,
              textInputType: TextInputType.text,
              hintText: 'Search user',
            ),
          ),
          const Divider(),
          Expanded(
            child: ListConversation(),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavigationBar(
        currentRoute: AppRouter.chat,
      ),
    );
  }
}
