import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubits/cubits.dart';
import '../router/app_router.dart';
import '../widgets/custom_navigationbar.dart';
import '../widgets/list_conversation.dart';
import '../widgets/text_field_input.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.chat),
      builder: (context) {
        context.read<NavigatonBarCubit>().setTab(NavigationTab.chat);
        return const ChatScreen();
      },
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
        children: <Widget>[
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
          const Expanded(
            child: ListConversation(),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
