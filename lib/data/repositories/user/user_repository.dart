import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/cart.dart';
import '../../models/user.dart';
import 'base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createUser(UserModel user) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson());
      await _firebaseFirestore
          .collection('carts')
          .doc(user.uid)
          .set(Cart(uid: user.uid, products: const []).toJson());
    } catch (_) {
      rethrow;
    }
  }

  @override
  Stream<UserModel> getUserStream(String uid) {
    log('Getting user from Cloud Firestore');
    return _firebaseFirestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => UserModel.fromJson(snap.data()!));
  }

  @override
  Future<UserModel?> fetchUser(String uid) async {
    try {
      final snap = await _firebaseFirestore.collection('users').doc(uid).get();
      if (snap.exists) {
        return UserModel.fromJson(snap.data()!);
      }
      return null;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .update(user.toJson())
          .then((_) => log('User updated'));
    } catch (_) {
      rethrow;
    }
  }
}
