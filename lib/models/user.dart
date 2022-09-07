import 'package:equatable/equatable.dart';

import 'delivery_address.dart';

class User extends Equatable {
  final String uid;
  final String email;
  final String username;
  final String phoneNum;
  final String photoUrl;
  final List<DeliveryAddress> addresses;
  final bool isAdmin;

  DeliveryAddress? get defaultAddress {
    return addresses.isEmpty
        ? null
        : addresses.firstWhere((address) => address.isDefault);
  }

  const User({
    required this.uid,
    required this.email,
    required this.username,
    this.phoneNum = '',
    required this.photoUrl,
    required this.addresses,
    this.isAdmin = false,
  });

  User copyWith({
    String? username,
    String? phoneNum,
    String? photoUrl,
    List<DeliveryAddress>? addresses,
  }) {
    return User(
      uid: uid,
      email: email,
      username: username ?? this.username,
      phoneNum: phoneNum ?? this.phoneNum,
      photoUrl: photoUrl ?? this.photoUrl,
      addresses: addresses ?? this.addresses,
      isAdmin: isAdmin,
    );
  }

  factory User.fromSnap(Map<String, dynamic> snap) {
    List<DeliveryAddress> addresses = [];
    if (snap["deliveryAddress"] != null) {
      snap["deliveryAddress"].forEach((address) {
        addresses.add(DeliveryAddress.fromSnap(address));
      });
    }
    return User(
      username: snap["username"],
      uid: snap["uid"],
      email: snap["email"],
      phoneNum: snap["phoneNum"],
      photoUrl: snap["photoUrl"],
      addresses: addresses,
      isAdmin: snap["isAdmin"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'phoneNum': phoneNum,
      'photoUrl': photoUrl,
      'deliveryAddress':
          List<dynamic>.from(addresses.map((address) => address.toJson())),
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
        addresses,
        isAdmin,
      ];
}