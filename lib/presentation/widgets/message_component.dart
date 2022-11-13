import 'package:flutter/material.dart';

import '../../data/models/message.dart';

class MessageComponent extends StatelessWidget {
  const MessageComponent({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final date = message.createAt!.toDate().toLocal();
    return Row(
      mainAxisAlignment:
          message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              constraints: BoxConstraints(
                minHeight: 40,
                minWidth: 30,
                maxWidth: width * 0.7,
              ),
              decoration: BoxDecoration(
                color: message.isMe ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: message.isMe
                      ? const Radius.circular(10)
                      : const Radius.circular(0),
                  bottomRight: message.isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(10),
                ),
              ),
              child: Text(
                message.content!,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: message.isMe ? Colors.white : Colors.black87),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(
                  right: 5,
                  bottom: 5,
                ),
                child: Text(
                  '${date.hour}h${date.minute}',
                  style: message.isMe
                      ? const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        )
                      : const TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
