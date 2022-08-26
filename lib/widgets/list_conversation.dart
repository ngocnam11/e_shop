import 'package:flutter/material.dart';

import '../screens/screens.dart';

class ListConversation extends StatelessWidget {
  const ListConversation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: 10,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConversationScreen(),),);
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
                  child: Text(index.toString()),
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
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
  }
}