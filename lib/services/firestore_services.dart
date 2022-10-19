import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart.dart';
import '../models/category.dart';
import '../models/delivery_address.dart';
import '../models/message.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'auth_services.dart';
import 'storage_service.dart';

class FireStoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storage = StorageService();

  String currentUserUid = AuthServices().currentUser.uid;

  Future<UserModel> getUserByUid({required String uid}) async {
    final snap = await _firestore.collection('users').doc(uid).get();
    UserModel user = UserModel.fromJson(snap.data()!);
    return user;
  }

  Future<Cart> getCartByUid({required String uid}) async {
    final snap = await _firestore.collection('carts').doc(uid).get();
    Cart cart = Cart.fromSnap(snap.data()!);
    return cart;
  }

  Future<Product> getProductById({required String id}) async {
    final snap = await _firestore.collection('products').doc(id).get();
    Product product = Product.fromJson(snap.data()!);
    return product;
  }

  Stream<List<Product>> getCurrentUserProducts() {
    final snaps = _firestore
        .collection('products')
        .where('uid', isEqualTo: currentUserUid)
        .snapshots();
    final products = snaps.map((snap) =>
        snap.docs.map((doc) => Product.fromJson(doc.data())).toList());
    return products;
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

  Stream<List<Order>> getCurrentUserOrders() {
    final snaps = _firestore
        .collection('orders')
        .where('customerId', isEqualTo: currentUserUid)
        .snapshots();
    final orders = snaps.map(
        (snap) => snap.docs.map((doc) => Order.fromJson(doc.data())).toList());
    return orders;
  }

  Stream<List<Order>> getOrdersOfSellerId() {
    final snaps = _firestore
        .collection('orders')
        .where('sellerId', isEqualTo: currentUserUid)
        .snapshots();
    final orders = snaps.map(
        (snap) => snap.docs.map((doc) => Order.fromJson(doc.data())).toList());
    return orders;
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
    required String sellerId,
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
        sellerId: sellerId,
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
              sellerId: sellerId,
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
              sellerId: sellerId,
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
              sellerId: sellerId,
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
              sellerId: sellerId,
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

  Future<String> removeProductFromCart({
    required String id,
    required String productId,
    required String color,
    required String size,
    required double priceOfItem,
    required String sellerId,
  }) async {
    String resDel = 'Some error occurred';
    try {
      final snap =
          await _firestore.collection('carts').doc(currentUserUid).get();
      final cartData = Cart.fromSnap(snap.data()!);
      final products = cartData.products;
      for (var i = 0; i < products.length; i++) {
        if (products[i].id == id &&
            products[i].color == color &&
            products[i].size == size) {
          var quantity = products[i].quantity - 1;
          var price = products[i].price - priceOfItem + .0;

          final tmp = CartItem(
            id: id,
            productId: productId,
            color: color,
            size: size,
            quantity: quantity,
            price: price,
            sellerId: sellerId,
          );
          products.removeAt(i);
          print(products);
          products.insert(i, tmp);
          print(products);

          _firestore.collection('carts').doc(currentUserUid).set(
                Cart(uid: currentUserUid, products: products).toJson(),
                SetOptions(merge: true),
              );
        }
      }
      resDel = 'success';
    } catch (e) {
      resDel = e.toString();
    }
    return resDel;
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
    required String orderStatus,
  }) async {
    String response = 'Some error occurred';
    try {
      var date = DateTime.now().toLocal();
      final id = 'ORD${date.year}Y${date.month}M${date.day}ES${date.second}';
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
        orderStatus: orderStatus,
        createdAt: Timestamp.now(),
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
      UserModel user = await getUserByUid(uid: uid);

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

  Future<String> updateOrderStatus({
    required String id,
    required String orderStatus,
  }) async {
    String updateOrder = 'Some error occurred';
    try {
      _firestore.collection('orders').doc(id).update({
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
      UserModel userData = await getUserByUid(uid: currentUserUid);

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
      Product product = await getProductById(id: id.toString());
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

  Future<String> deleteDeliveryAddress({required String id}) async {
    String deleteDA = 'Some error occurred';
    try {
      UserModel user = await getUserByUid(uid: currentUserUid);
      final addresses = user.addresses;
      for (var i = 0; i < addresses.length; i++) {
        if (addresses[i].id == id) {
          addresses.removeAt(i);
          await _firestore.collection('users').doc(currentUserUid).update(
                user.copyWith(addresses: addresses).toJson(),
              );
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
        .where('uid', isNotEqualTo: AuthServices().currentUser.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => UserModel.fromJson(e.data())).toList());
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
