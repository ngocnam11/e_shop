import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/auth_services.dart';

class Message {
  String? uid;
  String? content;
  String? senderUID;
  String? receiverUID;
  Timestamp? createAt;

  Message({
    this.uid,
    this.content,
    this.senderUID,
    this.receiverUID,
    this.createAt,
  });

  factory Message.fromJson(Map<String, dynamic> json, String id) {
    return Message(
      uid: id,
      content: json['content'],
      senderUID: json['senderUID'],
      receiverUID: json['receiverUID'],
      createAt: json['createAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderUID': senderUID,
      'receiverUID': receiverUID,
      'createAt': createAt,
    };
  }

  bool get isMe => AuthServices().currentUser.uid == senderUID;
}
