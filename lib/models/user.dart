import 'package:equatable/equatable.dart';

import 'delivery_address.dart';

class UserModel extends Equatable {
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

  const UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.phoneNum = '',
    this.photoUrl = 'https://i.ibb.co/yRw8xRv/noavatar.png',
    this.addresses = const [],
    this.isAdmin = false,
  });

  static const empty = UserModel(
    uid: '',
    email: '',
    username: '',
    photoUrl: '',
    addresses: [],
  );

  bool get isEmpty => this == UserModel.empty;

  bool get isNotEmpty => this != UserModel.empty;

  UserModel copyWith({
    String? username,
    String? phoneNum,
    String? photoUrl,
    List<DeliveryAddress>? addresses,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      username: username ?? this.username,
      phoneNum: phoneNum ?? this.phoneNum,
      photoUrl: photoUrl ?? this.photoUrl,
      addresses: addresses ?? this.addresses,
      isAdmin: isAdmin,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<DeliveryAddress> addresses = [];
    if (json["deliveryAddress"] != null) {
      json["deliveryAddress"].forEach((address) {
        addresses.add(DeliveryAddress.fromSnap(address));
      });
    }
    return UserModel(
      username: json["username"],
      uid: json["uid"],
      email: json["email"],
      phoneNum: json["phoneNum"],
      photoUrl: json["photoUrl"],
      addresses: addresses,
      isAdmin: json["isAdmin"],
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
