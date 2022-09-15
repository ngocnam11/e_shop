import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart.dart';
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

  Future<model.User> getUserByUid({required String uid}) async {
    final snap = await _firestore.collection('users').doc(uid).get();
    model.User user = model.User.fromSnap(snap.data()!);
    return user;
  }

  Future<Product> getProductById({required String id}) async {
    final snap = await _firestore.collection('products').doc(id).get();
    Product product = Product.fromJson(snap.data()!);
    return product;
  }

  Future<Cart> getCartByUid({required String uid}) async {
    final snap = await _firestore.collection('carts').doc(uid).get();
    Cart cart = Cart.fromSnap(snap.data()!);
    return cart;
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

  Future<String> addProductToCart({
    required String productId,
    required String color,
    required String size,
    required int quantity,
    required double price,
  }) async {
    String res = 'Some error occurred';
    try {
      final uid = AuthServices().currentUser.uid;
      CartItem newProduct = CartItem(
        id: 'ci$productId',
        productId: productId,
        color: color,
        size: size,
        quantity: quantity,
        price: price,
      );
      Cart cart = Cart(
        uid: uid,
        products: [newProduct],
      );
      final snap = await _firestore.collection('carts').doc(uid).get();
      if (snap.data() == null) {
        _firestore
            .collection('carts')
            .doc(uid)
            .set(Cart(uid: uid, products: const []).toJson());
      }

      final cartData = Cart.fromSnap(snap.data()!);
      if (cartData.products.isNotEmpty) {
        print(cartData.products);
        final products = cartData.products;
        for (var i = 0; i < products.length; i++) {
          if (products[i].id == 'ci$productId' &&
              products[i].color == color &&
              products[i].size == size) {
            var quantity = products[i].quantity + newProduct.quantity;
            var price = products[i].price + newProduct.price + .0;

            final tmp = CartItem(
              id: 'ci$productId',
              productId: productId,
              color: color,
              size: size,
              quantity: quantity,
              price: price,
            );
            products.removeAt(i);
            print(products);
            products.insert(i, tmp);
            print(products);

            _firestore.collection('carts').doc(uid).set(
                  Cart(uid: uid, products: products).toJson(),
                  SetOptions(merge: true),
                );
          } else if (products[i].id == 'ci${productId}p${color}c${size}s' &&
              products[i].color == color &&
              products[i].size == size) {
            var quantity = products[i].quantity + newProduct.quantity;
            var price = products[i].price + newProduct.price + .0;

            final tmp = CartItem(
              id: 'ci${productId}p${color}c${size}s',
              productId: productId,
              color: color,
              size: size,
              quantity: quantity,
              price: price,
            );

            products.removeAt(i);
            products.insert(i, tmp);

            _firestore.collection('carts').doc(uid).set(
                  Cart(uid: uid, products: products).toJson(),
                  SetOptions(merge: true),
                );
          } else if ((products[i].id == 'ci$productId' &&
                  products[i].color != color &&
                  products[i].size == size) ||
              (products[i].id == 'ci$productId' &&
                  products[i].size != size &&
                  products[i].color == color)) {
            CartItem product = CartItem(
              id: 'ci${productId}p${color}c${size}s',
              productId: productId,
              color: color,
              size: size,
              quantity: quantity,
              price: price + .0,
            );
            _firestore.collection('carts').doc(uid).update({
              'products': FieldValue.arrayUnion([product.toJson()]),
            });
          } else {
            CartItem product = CartItem(
              id: 'ci$productId',
              productId: productId,
              color: color,
              size: size,
              quantity: quantity,
              price: price + .0,
            );
            _firestore.collection('carts').doc(uid).update({
              'products': FieldValue.arrayUnion([product.toJson()]),
            });
          }
        }
      } else {
        _firestore.collection('carts').doc(uid).set(cart.toJson());
      }

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
      final id = 'ORD${date.year}Y${date.month}M${date.day}ES';
      Order order = Order(
        id: id,
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
      _firestore.collection('orders').doc(id).set(order.toJson());
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
    required String uid,
    required String email,
    required String username,
    required Uint8List file,
    required String phoneNum,
    required bool isAdmin,
  }) async {
    String resUpdate = 'Some error occurred';
    try {
      String photoUrl =
          await _storage.uploadImageToStorage('profilePics', file, false, '');
      model.User userData = await getUserByUid(uid: uid);

      model.User user = model.User(
        uid: uid,
        email: email,
        username: username,
        photoUrl: photoUrl,
        phoneNum: phoneNum,
        isAdmin: isAdmin,
        addresses: userData.addresses,
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
      String imageUrl =
          await _storage.uploadImageToStorage('profilePics', file, true, '');
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
