import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category.dart';
import '../models/delivery_address.dart';
import '../models/message.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user.dart' as model;
import 'auth_services.dart';
import 'storage_service.dart';

class FireStoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storage = StorageService();

  String currentUserUid = AuthServices().currentUser.uid;

  Future<model.User> getUserByUid({required String uid}) async {
    final snap = await _firestore.collection('users').doc(uid).get();
    model.User user = model.User.fromSnap(snap.data()!);
    return user;
  }

  Future<Product> getProductById({required int id}) async {
    final snap =
        await _firestore.collection('products').doc(id.toString()).get();
    Product product = Product.fromJson(snap.data()!);
    return product;
  }

  Stream<List<Product>> getProducts() {
    final snaps = _firestore.collection('products').snapshots();
    final products = snaps.map((snap) =>
        snap.docs.map((doc) => Product.fromJson(doc.data())).toList());
    return products;
  }

  Stream<List<Product>> get5Products() {
    final snaps = _firestore.collection('products').limit(5).snapshots();
    final products = snaps.map((snap) =>
        snap.docs.map((doc) => Product.fromJson(doc.data())).toList());
    return products;
  }

  Stream<List<Category>> getCategories() {
    final snaps = _firestore.collection('categories').snapshots();
    final categories = snaps.map((snap) =>
        snap.docs.map((doc) => Category.fromJson(doc.data())).toList());
    return categories;
  }

  Stream<List<Product>> getProductsByRecentSearch(
      {required List<String> recentSearch}) {
    final snaps = _firestore
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: recentSearch.last)
        .snapshots();
    final recommendedProducts = snaps.map((snap) =>
        snap.docs.map((doc) => Product.fromJson(doc.data())).toList());
    return recommendedProducts;
  }

  Stream<List<Product>> get5ProductsByRecentSearch(
      {required List<String> recentSearch}) {
    final snaps = _firestore
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: recentSearch.last)
        .limit(5)
        .snapshots();
    final recommendedProducts = snaps.map((snap) =>
        snap.docs.map((doc) => Product.fromJson(doc.data())).toList());
    return recommendedProducts;
  }

  Future<String> addProduct({
    required String uid,
    required int id,
    required String name,
    required String category,
    required double price,
    required int quantity,
    required Uint8List file,
    required String description,
    required List<String> colors,
    required List<String> size,
  }) async {
    String res = 'Some error occurred';
    try {
      String photoUrl = await _storage.uploadImageToStorage(
          'products', file, true, id.toString());
      Product product = Product(
        id: id,
        uid: uid,
        name: name,
        category: category,
        imageUrl: photoUrl,
        price: price,
        quantity: quantity,
        description: description,
        colors: colors,
        size: size,
      );

      _firestore
          .collection('products')
          .doc(id.toString())
          .set(product.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> addOrder({
    required String customerId,
    required String sellerId,
    required List<Product> products,
    // required String paymentMethod,
    required String deliveryAddress,
    required double subtotal,
    required double deliveryFee,
    required double total,
  }) async {
    String response = 'Some error occurred';
    try {
      var date = DateTime.now().toLocal();
      Order order = Order(
        id: 'ORD${date.year}Y${date.month}M${date.day}ES',
        customerId: customerId,
        sellerId: sellerId,
        products: products,
        paymentMethod: 'Cash Money',
        deliveryAddress: deliveryAddress,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        total: total,
        isAccepted: false,
        isDelivered: false,
        isCancelled: false,
        isReceived: false,
        createdAt: DateTime.now(),
      );
      _firestore.collection('orders').doc().set(order.toJson());
      response = 'success';
    } catch (e) {
      response = e.toString();
    }

    return response;
  }

  Future<String> addDeliveryAddress({
    required String uid,
    required String address,
    required String city,
    required String country,
  }) async {
    String addSA = 'Some error occurred';
    try {
      var date = DateTime.now().toLocal();
      model.User user = await getUserByUid(uid: uid);

      DeliveryAddress deliveryAddress = DeliveryAddress(
        id: 'address${date.day}d${date.hour}h${date.minute}',
        address: address,
        city: city,
        country: country,
        isDefault: user.addresses.isEmpty ? true : false,
      );

      _firestore.collection('users').doc(uid).update(
        {
          'deliveryAddress': FieldValue.arrayUnion(
            [deliveryAddress.toJson()],
          ),
        },
      );
      addSA = 'success';
    } catch (e) {
      addSA = e.toString();
    }

    return addSA;
  }

  Future<String> updateShippingAddress({
    required String uid,
    required String address,
    required String city,
    required String country,
  }) async {
    String updateSA = 'Some error occurred';
    try {
      _firestore.collection('users').doc(uid).update({
        'deliveryAddress.address': address,
        'deliveryAddress.city': city,
        'deliveryAddress.country': country,
      });
      updateSA = 'success';
    } catch (e) {
      updateSA = e.toString();
    }

    return updateSA;
  }

  Future<String> updateProfile({
    String? username,
    Uint8List? file,
    String? phoneNum,
  }) async {
    String resUpdate = 'Some error occurred';
    try {
      String? photoUrl;

      if (file != null) {
        photoUrl =
            await _storage.uploadImageToStorage('profilePics', file, false, '');
      }
      model.User userData = await getUserByUid(uid: currentUserUid);

      userData = userData.copyWith(
        username: username,
        phoneNum: phoneNum,
        photoUrl: photoUrl,
      );

      _firestore
          .collection('users')
          .doc(currentUserUid)
          .update(userData.toJson());
      resUpdate = 'success';
    } catch (e) {
      resUpdate = e.toString();
    }

    return resUpdate;
  }

  Future<String> updateProduct({
    required int id,
    String? name,
    String? category,
    Uint8List? file,
    double? price,
    int? quantity,
    String? description,
    List<String>? colors,
    List<String>? size,
  }) async {
    String rep = 'Some error occurred';
    try {
      String? imageUrl;
      if (file != null) {
        imageUrl = await _storage.uploadImageToStorage(
            'products', file, true, id.toString());
      }
      Product product = await getProductById(id: id);
      product = product.copyWith(
        name: name,
        category: category,
        imageUrl: imageUrl,
        price: price,
        quantity: quantity,
        description: description,
        colors: colors,
        size: size,
      );

      _firestore
          .collection('products')
          .doc(id.toString())
          .update(product.toJson());
      rep = 'success';
    } catch (e) {
      rep = e.toString();
    }
    return rep;
  }

  Future<String> deleteProduct({required int id}) async {
    String res = 'Some error occurred';
    try {
      await _storage.deleteImageFromStorage('products', true, id.toString());
      await _firestore.collection('products').doc(id.toString()).delete();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Stream<List<model.User>> get getDiscussionUser {
    return _firestore
        .collection('users')
        .where('uid', isNotEqualTo: AuthServices().currentUser.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => model.User.fromSnap(e.data())).toList());
  }

  Stream<List<Message>> getMessage(String reciverUID, [bool myMessage = true]) {
    return _firestore
        .collection('messages')
        .where('senderUID',
            isEqualTo: myMessage ? AuthServices().currentUser.uid : reciverUID)
        .where('reciverUID',
            isEqualTo: myMessage ? reciverUID : AuthServices().currentUser.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Message.fromJson(e.data(), e.id)).toList());
  }

  Future<bool> sendMessage(Message msg) async {
    try {
      await _firestore.collection('messages').doc().set(msg.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}
