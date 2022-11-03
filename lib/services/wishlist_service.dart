import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/models/product.dart';
import '../data/models/wishlist.dart';
import 'auth_services.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentUserUid = AuthServices().currentUser.uid;

  List<Map<String, dynamic>> productsMapData = [];

  Future<List<Product>> getWishlist() async {
    final DocumentSnapshot docSnap =
        await _firestore.collection('wishlist').doc(currentUserUid).get();

    if (docSnap.exists) {
      List<Product> list = [];
      final wishlist = docSnap.data() as Map<String, dynamic>;

      productsMapData.clear();

      wishlist["products"].forEach((product) {
        productsMapData.insert(0, Product.fromJson(product).toJson());
        list.add(Product.fromJson(product));
      });

      return list;
    }
    return [];
  }

  Future<void> addWishlist({required Wishlist wishlist}) async {
    try {
      // List<Map<String, dynamic>> productsMapData = [];
      for (Product product in wishlist.products) {
        productsMapData.add(product.toJson());
      }
      await _firestore.collection("wishlist").doc(currentUserUid).set({
        "products": productsMapData,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> removeWishlist({required Product product}) async {
    try {
      productsMapData.remove(product.toJson());
      await _firestore.collection("wishlist").doc(currentUserUid).update({
        "products": FieldValue.arrayRemove([product.toJson()]),
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
