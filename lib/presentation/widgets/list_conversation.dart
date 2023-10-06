import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/message.dart';
import '../../data/models/user.dart';
import '../../services/firestore_services.dart';
import '../screens/screens.dart';
import 'custom_network_image.dart';

class ListConversation extends StatelessWidget {
  const ListConversation({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: FireStoreServices().getDiscussionUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Text('Something went wrong');
        }
        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No discussion'),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Ink(
                height: 60,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ConversationScreen(
                          user: snapshot.data![index],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipOval(
                        child: CustomNetworkImage(
                          src: snapshot.data![index].photoUrl,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      StreamBuilder<List<Message>>(
                        stream: FireStoreServices()
                            .getMessage(snapshot.data![index].uid),
                        builder: (context, messageSnapshot) {
                          if (messageSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (messageSnapshot.hasError) {
                            debugPrint(messageSnapshot.error.toString());
                            return const Text('Something went wrong');
                          }
                          final messages = messageSnapshot.data!;
                          return Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data![index].username,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                      Text(
                                        messages.isEmpty
                                            ? 'No message'
                                            : messages[0].content!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  messages.isEmpty
                                      ? ''
                                      : DateFormat('dd-MM-yy').format(
                                          messages[0].createAt!.toDate()),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider(indent: 80),
        );
      },
    );
  }
}
