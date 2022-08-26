import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';
import '../models/product.dart';
import '../models/user.dart' as model; 
import 'auth_services.dart';
import 'storage_service.dart';


class FireStoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      String photoUrl = await StorageService()
          .uploadImageToStorage('products', file, true, id.toString());
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

  // Future<String> addCheckout({
  //   required String uid,
  //   required String username,
  //   required String email,
  //   required String phoneNum,
  //   required String address,
  //   required String city,
  //   required String country,
  //   required List<Product> products,
  //   required String subtotal,
  //   required String deliveryFee,
  //   required String total,
  // }) async {
  //   String response = 'Some error occurred';
  //   try {
  //     Checkout checkout = Checkout(
  //       uid: uid,
  //       username: username,
  //       email: email,
  //       phoneNum: phoneNum,
  //       address: address,
  //       city: city,
  //       country: country,
  //       products: products,
  //       subtotal: subtotal,
  //       deliveryFee: deliveryFee,
  //       total: total,
  //     );
  //     _firestore.collection('checkouts').doc().set(checkout.toJson());
  //     response = 'success';
  //   } catch (e) {
  //     response = e.toString();
  //   }

  //   return response;
  // }

  Future<String> updateProfile({
    required String uid,
    required String email,
    required String username,
    required Uint8List file,
    required String phoneNum,
    required List<Map<String, String>> listAddress,
    required bool isAdmin,
  }) async {
    String resUpdate = 'Some error occurred';
    try {
      String photoUrl = await StorageService()
          .uploadImageToStorage('profilePics', file, false, '');

      model.User user = model.User(
        uid: uid,
        email: email,
        username: username,
        photoUrl: photoUrl,
        phoneNum: phoneNum,
        listAddress: listAddress,
        isAdmin: isAdmin,
      );

      _firestore.collection('users').doc(uid).update(user.toJson());
      resUpdate = 'success';
    } catch (e) {
      resUpdate = e.toString();
    }

    return resUpdate;
  }

  Future<String> updateProduct({
    required int id,
    required String uid,
    required String name,
    required String category,
    required Uint8List file,
    required double price,
    required int quantity,
    required String description,
    required List<String> colors,
    required List<String> size,
  }) async {
    String rep = 'Some error occurred';
    try {
      String imageUrl = await StorageService()
          .uploadImageToStorage('profilePics', file, true, '');
      Product product = Product(
        id: id,
        uid: uid,
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

  Future<String> deleteProduct({
    required int id,
  }) async {
    String res = 'Some error occurred';
    try {
      _firestore.collection('products').doc(id.toString()).delete();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Stream<List<model.User>> get getDiscussionUser {
    return _firestore.collection('users')
        .where('uid', isNotEqualTo: AuthServices().user.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => model.User.fromSnap(e)).toList());
  }

  Stream<List<Message>> getMessage(String reciverUID, [bool myMessage = true]) {
    return _firestore.collection('messages')
        .where('senderUID',
            isEqualTo: myMessage ? AuthServices().user.uid : reciverUID)
        .where('reciverUID',
            isEqualTo: myMessage ? reciverUID : AuthServices().user.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Message.fromJson(e.data(), e.id)).toList());
  }

  Future<bool> sendMessage(Message msg) async {
    try {
      await _firestore.collection('messages').doc().set(msg.toJson());
      return true;
    }catch(e) {
      return false;
    }
  }
}