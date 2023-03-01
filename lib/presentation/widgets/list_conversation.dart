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
        return snapshot.data!.toList().isEmpty
            ? const Center(
                child: Text('No discussion'),
              )
            : ListView.separated(
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: snapshot.data!.toList().length,
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
                                user: snapshot.data!.toList()[index],
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
                                src: snapshot.data!.toList()[index].photoUrl,
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8),
                            StreamBuilder<List<Message>>(
                              stream: FireStoreServices().getMessage(
                                  snapshot.data!.toList()[index].uid),
                              builder: (context, messageSnapshot1) {
                                if (messageSnapshot1.hasData) {
                                  return StreamBuilder<List<Message>>(
                                    stream: FireStoreServices().getMessage(
                                        snapshot.data!.toList()[index].uid,
                                        false),
                                    builder: (context, messageSnapshot2) {
                                      if (messageSnapshot2.hasData) {
                                        var messages = [
                                          ...messageSnapshot1.data!,
                                          ...messageSnapshot2.data!
                                        ];
                                        messages.sort((i, j) =>
                                            i.createAt!.compareTo(j.createAt!));
                                        messages = messages.reversed.toList();
                                        return Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      snapshot.data!
                                                          .toList()[index]
                                                          .username,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium,
                                                    ),
                                                    Text(
                                                      messages.isEmpty
                                                          ? 'No message'
                                                          : messages[0]
                                                              .content!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                messages.isEmpty
                                                    ? ''
                                                    : DateFormat('dd-MM-yy')
                                                        .format(messages[0]
                                                            .createAt!
                                                            .toDate()),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
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
