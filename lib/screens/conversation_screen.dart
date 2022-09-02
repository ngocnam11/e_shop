import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';
import '../services/auth_services.dart';
import '../services/firestore_services.dart';
import '../widgets/message_component.dart';
import '../widgets/text_field_input.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({Key? key, this.user}) : super(key: key);
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final TextEditingController msgController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(user['username']),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: FireStoreServices().getMessage(user['uid']),
                builder: (context, snapshot1) {
                  if (snapshot1.hasData) {
                    return StreamBuilder<List<Message>>(
                      stream:
                          FireStoreServices().getMessage(user['uid'], false),
                      builder: (context, snapshot2) {
                        if (snapshot2.hasData) {
                          var messages = [
                            ...snapshot1.data!,
                            ...snapshot2.data!
                          ];
                          messages.sort(
                              (i, j) => i.createAt!.compareTo(j.createAt!));
                          messages = messages.reversed.toList();
                          return messages.isEmpty
                              ? const Center(
                                  child: Text('No message'),
                                )
                              : ListView.builder(
                                  reverse: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  itemCount: messages.length,
                                  itemBuilder: ((context, index) {
                                    final msg = messages[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: MessageComponent(
                                        message: msg,
                                      ),
                                    );
                                  }),
                                );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFieldInput(
                    controller: msgController,
                    hintText: 'Aa',
                    textInputType: TextInputType.text,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    var msg = Message(
                      content: msgController.text,
                      createAt: Timestamp.now(),
                      reciverUID: user['uid'],
                      senderUID: AuthServices().currentUser.uid,
                    );
                    msgController.clear();
                    await FireStoreServices().sendMessage(msg);
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
