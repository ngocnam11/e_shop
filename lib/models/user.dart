import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String email;
  final String username;
  final String phoneNum;
  final String photoUrl;
  final List<Map<String, String>>? listAddress;
  final bool isAdmin;

  const User({
    required this.uid,
    required this.email,
    required this.username,
    this.phoneNum = '',
    required this.photoUrl,
    this.listAddress,
    this.isAdmin = false,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      phoneNum: snapshot["phoneNum"],
      photoUrl: snapshot["photoUrl"],
      listAddress: snapshot["listAddress"],
      isAdmin: snapshot["isAdmin"],
    );
  }

  Map<String, dynamic> toJson() => {
      'uid': uid,
      'username': username,
      'email': email,
      'phoneNum': phoneNum,
      'photoUrl': photoUrl,
      'listAddress': listAddress,
      'isAdmin': isAdmin,
  };

  @override
  List<Object?> get props =>
      [uid, email, username, phoneNum, photoUrl, listAddress, isAdmin];
}