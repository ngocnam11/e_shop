import 'package:flutter/material.dart';

import '../models/user.dart';
import '../screens/screens.dart';
import '../services/firestore_services.dart';

class ListConversation extends StatelessWidget {
  const ListConversation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: FireStoreServices().getDiscussionUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
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
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ConversationScreen(
                            user: snapshot.data!.toList()[index],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.amber,
                            backgroundImage: NetworkImage(
                              snapshot.data!.toList()[index].photoUrl,
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!.toList()[index].username,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                Text(
                                  'Message',
                                  style: Theme.of(context).textTheme.headline6,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '11/11/2022',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
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
