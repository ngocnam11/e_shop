import 'package:flutter/material.dart';

import '../models/message.dart';

class MessageComponent extends StatelessWidget {
  const MessageComponent({Key? key, this.message}) : super(key: key);
  final Message? message;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var date = message!.createAt!.toDate().toLocal();
    return Row(
      mainAxisAlignment:
          message!.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              constraints: BoxConstraints(
                minHeight: 40,
                minWidth: 30,
                maxWidth: width / 1.1,
              ),
              decoration: BoxDecoration(
                color:
                    message!.isMe ? Colors.blue : Colors.black.withOpacity(.7),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: message!.isMe
                      ? const Radius.circular(10)
                      : const Radius.circular(0),
                  bottomRight: message!.isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(10),
                ),
              ),
              child: Text(
                message!.content!,
                style: const TextStyle(
                  color: Colors.white,
                ),
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
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
