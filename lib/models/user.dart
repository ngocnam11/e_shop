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
    this.country = '',
    this.isAdmin = false,
  });

  factory User.fromSnap(Map<String, dynamic> snap) {
    return User(
      username: snap["username"],
      uid: snap["uid"],
      email: snap["email"],
      phoneNum: snap["phoneNum"],
      photoUrl: snap["photoUrl"],
      address: snap["address"],
      city: snap["city"],
      country: snap["country"],
      isAdmin: snap["isAdmin"],
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
  List<Object?> get props => [
        uid,
        email,
        username,
        phoneNum,
        photoUrl,
        address,
        city,
        country,
        isAdmin,
      ];
}
