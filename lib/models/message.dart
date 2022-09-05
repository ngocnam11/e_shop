import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_services.dart';

class Message {
  String? uid;
  String? content;
  String? senderUID;
  String? reciverUID;
  Timestamp? createAt;

  Message({
    this.uid,
    this.content,
    this.senderUID,
    this.reciverUID,
    this.createAt,
  });

  Message.fromJson(Map<String, dynamic> json, String id) {
    uid = id;
    content = json['content'];
    senderUID = json['senderUID'];
    reciverUID = json['reciverUID'];
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderUID': senderUID,
      'reciverUID': reciverUID,
      'createAt': createAt,
    };
  }

  bool get isMe => AuthServices().currentUser.uid == senderUID;
}
