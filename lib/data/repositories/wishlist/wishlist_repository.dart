import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/product.dart';
import '../../models/wishlist.dart';
import 'base_wishlist_repository.dart';

class WishlistRepository implements BaseWishlistRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  WishlistRepository({
    FirebaseFirestore? firebaseFirestore,
    FirebaseAuth? firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<Wishlist> getWishlist() {
    return _firebaseFirestore
        .collection('wishlist')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('items')
        .snapshots()
        .map((snapshot) {
      final List<Product> products =
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
      return Wishlist(products: products);
    });
  }

  @override
  Future<void> addProductToWishlist(Product product) async {
    try {
      await _firebaseFirestore
          .collection("wishlist")
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('items')
          .doc(product.id)
          .set(product.toJson());
    } on Exception catch (e) {
      log('addProductToWishlist: $e');
    }
  }

  @override
  Future<void> removeProductFromWishlist(Product product) async {
    try {
      await _firebaseFirestore
          .collection("wishlist")
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('items')
          .doc(product.id)
          .delete();
    } on Exception catch (e) {
      log('removeProductFromWishlist: $e');
    }
  }
}
