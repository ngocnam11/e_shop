import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/models/message.dart';
import '../../data/models/user.dart';
import '../../services/auth_services.dart';
import '../../services/firestore_services.dart';
import '../widgets/message_component.dart';
import '../widgets/text_field_input.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final TextEditingController msgController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: FireStoreServices().getMessage(user.uid),
                builder: (context, snapshot1) {
                  if (snapshot1.hasData) {
                    return StreamBuilder<List<Message>>(
                      stream: FireStoreServices().getMessage(user.uid, false),
                      builder: (context, snapshot2) {
                        if (snapshot2.hasData) {
                          final List<Message> messages = [
                            ...snapshot1.data!,
                            ...snapshot2.data!,
                          ]
                            ..sort((i, j) => i.createAt!.compareTo(j.createAt!))
                            ..reversed;
                          return messages.isEmpty
                              ? const Center(child: Text('No message'))
                              : ListView.builder(
                                  reverse: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: MessageComponent(
                                        message: messages[index],
                                      ),
                                    );
                                  },
                                );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: TextFieldInput(
                    controller: msgController,
                    hintText: 'Aa',
                    textInputType: TextInputType.multiline,
                    maxLines: 8,
                    contentPadding: const EdgeInsets.all(12),
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    var msg = Message(
                      content: msgController.text,
                      createAt: Timestamp.now(),
                      receiverUID: user.uid,
                      senderUID: AuthServices().currentUser.uid,
                    );
                    await FireStoreServices().sendMessage(msg);
                    msgController.clear();
                  },
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
