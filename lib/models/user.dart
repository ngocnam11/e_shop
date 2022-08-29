import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String email;
  final String username;
  final String phoneNum;
  final String photoUrl;
  final String? address;
  final String? city;
  final String? country;
  final bool isAdmin;

  const User({
    required this.uid,
    required this.email,
    required this.username,
    this.phoneNum = '',
    required this.photoUrl,
    this.address = '',
    this.city = '',
    this.country= '',
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
      address: snap["address"],
      city: snap["city"],
      country: snap["country"],
      isAdmin: snapshot["isAdmin"],
    );
  }

  Map<String, dynamic> toJson() {
    Map shippingAddress = {};
    shippingAddress['address'] = address;
    shippingAddress['city'] = city;
    shippingAddress['country'] = country;

    return {
      'uid': uid,
      'username': username,
      'email': email,
      'phoneNum': phoneNum,
      'photoUrl': photoUrl,
      'shippingAddress': shippingAddress,
      'isAdmin': isAdmin,
    };
      
  }

  @override
  List<Object?> get props =>
      [uid, email, username, phoneNum, photoUrl, address, city, country, isAdmin];
}