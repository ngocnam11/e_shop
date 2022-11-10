import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../models/product.dart';
import 'base_product_repository.dart';

class ProductRepository extends BaseProductRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  ProductRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firebaseFirestore,
    FirebaseStorage? firebaseStorage,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Stream<List<Product>> getAllProducts() {
    return _firebaseFirestore
        .collection('products')
        .snapshots()
        .map((snap) => snap.docs
            .map(
              (doc) => Product.fromJson(doc.data()),
            )
            .toList());
  }

  @override
  Stream<List<Product>> getCurrentUserProducts() {
    return _firebaseFirestore
        .collection('products')
        .where('uid', isEqualTo: _firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((snap) => snap.docs
            .map(
              (doc) => Product.fromJson(doc.data()),
            )
            .toList());
  }

  @override
  Stream<List<Product>> get5Products() {
    return _firebaseFirestore
        .collection('products')
        .limit(5)
        .snapshots()
        .map((snap) => snap.docs
            .map(
              (doc) => Product.fromJson(doc.data()),
            )
            .toList());
  }

  @override
  Stream<List<Product>> getProductsByRecentSearch(List<String> recentSearch) {
    return _firebaseFirestore
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: recentSearch.last)
        .snapshots()
        .map((snap) => snap.docs
            .map(
              (doc) => Product.fromJson(doc.data()),
            )
            .toList());
  }

  @override
  Stream<List<Product>> get5ProductsByRecentSearch(List<String> recentSearch) {
    return _firebaseFirestore
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: recentSearch.last)
        .limit(5)
        .snapshots()
        .map((snap) => snap.docs
            .map(
              (doc) => Product.fromJson(doc.data()),
            )
            .toList());
  }

  @override
  Future<void> addProduct({
    required String name,
    required String category,
    required double price,
    required int quantity,
    required Uint8List file,
    required String description,
    required List<String> colors,
    required List<String> sizes,
  }) async {
    try {
      final id = const Uuid().v4();
      final photoUrl = await _getProductImageURL(file, id);

      final product = Product(
        id: id,
        uid: _firebaseAuth.currentUser!.uid,
        name: name,
        category: category,
        imageUrl: photoUrl,
        price: price,
        quantity: quantity,
        description: description,
        colors: colors,
        sizes: sizes,
      );

      await _firebaseFirestore
          .collection('products')
          .doc(id)
          .set(product.toJson());
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final snapshot =
          await _firebaseFirestore.collection('products').doc(id).get();
      return Product.fromJson(snapshot.data()!);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> updateProduct({
    required String id,
    String? name,
    String? category,
    Uint8List? file,
    double? price,
    int? quantity,
    String? description,
    List<String>? colors,
    List<String>? sizes,
  }) async {
    try {
      String? imageUrl;
      if (file != null) {
        imageUrl = await _getProductImageURL(file, id);
      }

      Product product = await getProductById(id);
      product = product.copyWith(
        name: name,
        category: category,
        imageUrl: imageUrl,
        price: price,
        quantity: quantity,
        description: description,
        colors: colors,
        sizes: sizes,
      );

      await _firebaseFirestore
          .collection('products')
          .doc(id)
          .update(product.toJson());
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await Future.wait([
        _firebaseStorage
            .ref()
            .child('products')
            .child(_firebaseAuth.currentUser!.uid)
            .child(id)
            .delete(),
        _firebaseFirestore.collection('products').doc(id).delete(),
      ]);
    } catch (_) {
      rethrow;
    }
  }

  Future<String> _getProductImageURL(Uint8List file, String id) async {
    final snapshot = await _firebaseStorage
        .ref()
        .child('products')
        .child(_firebaseAuth.currentUser!.uid)
        .child(id)
        .putData(file);
    return await snapshot.ref.getDownloadURL();
  }
}
