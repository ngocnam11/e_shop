import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String senderId;
  final String title;
  final String body;
  final String receiverId;
  final String imageUrl;
  final Timestamp createdAt;

  const NotificationModel({
    required this.id,
    required this.senderId,
    required this.title,
    required this.body,
    required this.receiverId,
    required this.imageUrl,
    required this.createdAt,
  });

  NotificationModel copyWith({
    String? title,
    String? body,
    String? imageUrl,
  }) {
    return NotificationModel(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'title': title,
      'body': body,
      'receiverId': receiverId,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> snap) {
    return NotificationModel(
      id: snap['id'],
      senderId: snap['senderId'],
      title: snap['title'],
      body: snap['body'],
      receiverId: snap['receiverId'],
      imageUrl: snap['imageUrl'],
      createdAt: snap['createdAt'],
    );
  }

  @override
  List<Object?> get props =>
      [id, senderId, title, body, receiverId, imageUrl, createdAt];
}
