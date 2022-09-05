import 'package:equatable/equatable.dart';

class DeliveryAddress extends Equatable {
  final String id;
  final String address;
  final String city;
  final String country;
  final bool isDefault;

  const DeliveryAddress({
    required this.id,
    required this.address,
    required this.city,
    required this.country,
    required this.isDefault,
  });

  factory DeliveryAddress.fromSnap(Map<String, dynamic> snap) {
    return DeliveryAddress(
      id: snap['id'],
      address: snap['address'],
      city: snap['city'],
      country: snap['country'],
      isDefault: snap['isDefault'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'city': city,
      'country': country,
      'isDefault': isDefault
    };
  }

  @override
  List<Object?> get props => throw [id, address, city, country, isDefault];
}
