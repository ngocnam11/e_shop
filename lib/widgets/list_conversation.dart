import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/message.dart';
import '../models/user.dart';
import '../screens/screens.dart';
import '../services/firestore_services.dart';
import 'custom_network_image.dart';

class ListConversation extends StatelessWidget {
  const ListConversation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: FireStoreServices().getDiscussionUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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
                          children: [
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
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data!
                                                          .toList()[index]
                                                          .username,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4,
                                                    ),
                                                    Text(
                                                      messages.isEmpty
                                                          ? 'No message'
                                                          : messages[0]
                                                              .content!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6,
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
                                                    .headline6,
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
                separatorBuilder: (context, index) => const Divider(indent: 80),
              );
      },
    );
  }
}
