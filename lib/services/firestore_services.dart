import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../data/models/delivery_address.dart';
import '../data/models/message.dart';
import '../data/models/notification.dart';
import '../data/models/order.dart';
import '../data/models/product.dart';
import '../data/models/user.dart';
import '../data/models/user_token.dart';
import 'storage_service.dart';

class FireStoreServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storage = StorageService();
  var uuid = const Uuid();

  Future<UserModel> getUserByUid({required String uid}) async {
    final snap = await _firestore.collection('users').doc(uid).get();
    UserModel user = UserModel.fromJson(snap.data()!);
    return user;
  }

  Future<Product> getProductById({required String id}) async {
    final snap = await _firestore.collection('products').doc(id).get();
    Product product = Product.fromJson(snap.data()!);
    return product;
  }

  Future<UserToken?> getTokens({required String id}) async {
    final snap = await _firestore.collection('userTokens').doc(id).get();
    if (snap.exists) {
      UserToken userToken = UserToken.fromJson(snap.data()!);
      return userToken;
    }
    return UserToken(uid: id, tokens: const []);
  }

  Stream<List<NotificationModel>> getCurrentUserNotifications() {
    final snaps = _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: _auth.currentUser!.uid)
        .snapshots();
    final notifications = snaps.map((snap) => snap.docs
        .map((doc) => NotificationModel.fromJson(doc.data()))
        .toList());
    return notifications;
  }

  // Stream<List<Product>> getProductsByRecentSearch(
  //     {required List<String> recentSearch}) {
  //   final snaps = _firestore
  //       .collection('products')
  //       .where('name', isGreaterThanOrEqualTo: recentSearch.last)
  //       .snapshots();
  //   final recommendedProducts = snaps.map((snap) =>
  //       snap.docs.map((doc) => Product.fromJson(doc.data())).toList());
  //   return recommendedProducts;
  // }

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

  Stream<List<OrderModel>> getCurrentUserOrders() {
    final snaps = _firestore
        .collection('orders')
        .where('customerId', isEqualTo: _auth.currentUser!.uid)
        .snapshots();
    final orders = snaps.map((snap) =>
        snap.docs.map((doc) => OrderModel.fromJson(doc.data())).toList());
    return orders;
  }

  Stream<List<OrderModel>> getOrdersOfSellerId() {
    final snaps = _firestore
        .collection('orders')
        .where('sellerId', isEqualTo: _auth.currentUser!.uid)
        .snapshots();
    final orders = snaps.map((snap) =>
        snap.docs.map((doc) => OrderModel.fromJson(doc.data())).toList());
    return orders;
  }

  Future<String> addProduct({
    required String uid,
    required String name,
    required String category,
    required double price,
    required int quantity,
    required Uint8List file,
    required String description,
    required List<String> colors,
    required List<String> sizes,
  }) async {
    String res = 'Some error occurred';
    try {
      String id = uuid.v4();
      String photoUrl =
          await _storage.uploadImageToStorage('products', file, true, id);
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
        sizes: sizes,
      );

      await _firestore.collection('products').doc(id).set(product.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
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
      UserModel user = await getUserByUid(uid: uid);

      DeliveryAddress deliveryAddress = DeliveryAddress(
        id: 'address${date.day}d${date.hour}h${date.minute}',
        address: address,
        city: city,
        country: country,
        isDefault: user.addresses.isEmpty ? true : false,
      );

      await _firestore.collection('users').doc(uid).update(
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

  Future<String> addFCMToken({required String token}) async {
    String addToken = 'Some error occurred';
    try {
      String uid = _auth.currentUser!.uid;

      UserToken? userToken = await getTokens(id: uid);

      UserToken newToken = UserToken(uid: uid, tokens: [token]);

      if (userToken!.tokens.isEmpty) {
        await _firestore
            .collection('userTokens')
            .doc(uid)
            .set(newToken.toJson());
      } else {
        await _firestore.collection('userTokens').doc(uid).update(
          {
            'tokens': FieldValue.arrayUnion([token]),
          },
        );
      }

      addToken = 'success';
    } catch (e) {
      addToken = e.toString();
    }

    return addToken;
  }

  Future<String> addNotification({
    required NotificationModel notification,
  }) async {
    String addNoti = 'Some error occurred';
    try {
      String id = uuid.v4();

      NotificationModel noti = NotificationModel(
        id: id,
        senderId: notification.senderId,
        title: notification.title,
        body: notification.body,
        receiverId: notification.receiverId,
        imageUrl: notification.imageUrl,
        createdAt: Timestamp.now(),
      );

      await _firestore.collection('notifications').doc(id).set(noti.toJson());
      addNoti = 'success';
    } catch (e) {
      addNoti = e.toString();
    }

    return addNoti;
  }

  Future<String> updateOrderStatus({
    required String id,
    required String orderStatus,
  }) async {
    String updateOrder = 'Some error occurred';
    try {
      await _firestore.collection('orders').doc(id).update({
        'orderStatus': orderStatus,
      });
      updateOrder = 'success';
    } catch (e) {
      updateOrder = e.toString();
    }
    return updateOrder;
  }

  Future<String> updateDeliveryAddress({
    required String uid,
    required String id,
    required String address,
    required String city,
    required String country,
    required bool isDefault,
  }) async {
    String updateSA = 'Some error occurred';
    try {
      UserModel user = await getUserByUid(uid: uid);
      final addresses = user.addresses;
      for (var i = 0; i < addresses.length; i++) {
        if (addresses[i].id == id) {
          final tempAddress = DeliveryAddress(
            id: id,
            address: address,
            city: city,
            country: country,
            isDefault: isDefault,
          );
          addresses.removeAt(i);
          addresses.insert(i, tempAddress);
          await _firestore.collection('users').doc(uid).update(
                user.copyWith(addresses: addresses).toJson(),
              );
        }
      }
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
      UserModel userData = await getUserByUid(uid: _auth.currentUser!.uid);

      userData = userData.copyWith(
        username: username,
        phoneNum: phoneNum,
        photoUrl: photoUrl,
      );

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(userData.toJson());
      resUpdate = 'success';
    } catch (e) {
      resUpdate = e.toString();
    }

    return resUpdate;
  }

  Future<String> updateProduct({
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
    String rep = 'Some error occurred';
    try {
      String? imageUrl;
      if (file != null) {
        imageUrl =
            await _storage.uploadImageToStorage('products', file, true, id);
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
        sizes: sizes,
      );

      await _firestore.collection('products').doc(id).update(product.toJson());
      rep = 'success';
    } catch (e) {
      rep = e.toString();
    }
    return rep;
  }

  Future<String> deleteProduct({required String id}) async {
    String res = 'Some error occurred';
    try {
      await _storage.deleteImageFromStorage('products', true, id);
      await _firestore.collection('products').doc(id).delete();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> deleteDeliveryAddress({required String id}) async {
    String deleteDA = 'Some error occurred';
    try {
      UserModel user = await getUserByUid(uid: _auth.currentUser!.uid);
      final addresses = user.addresses;
      for (var i = 0; i < addresses.length; i++) {
        if (addresses[i].id == id) {
          addresses.removeAt(i);
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .update(user.copyWith(addresses: addresses).toJson());
        }
      }
      deleteDA = 'success';
    } catch (e) {
      deleteDA = e.toString();
    }

    return deleteDA;
  }

  Stream<List<UserModel>> get getDiscussionUser {
    return _firestore
        .collection('users')
        .where('uid', isNotEqualTo: _auth.currentUser!.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }

  Stream<List<Message>> getMessage(String receiverUid) {
    final filter = Filter.or(
      Filter.and(
        Filter('senderUID', isEqualTo: _auth.currentUser!.uid),
        Filter('receiverUID', isEqualTo: receiverUid),
      ),
      Filter.and(
        Filter('senderUID', isEqualTo: receiverUid),
        Filter('receiverUID', isEqualTo: _auth.currentUser!.uid),
      ),
    );
    final querySnapshot = _firestore
        .collection('messages')
        .where(filter)
        .orderBy('createAt', descending: true)
        .snapshots();

    return querySnapshot.map((snapshot) => snapshot.docs
        .map((doc) => Message.fromJson(doc.data(), doc.id))
        .toList());
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
