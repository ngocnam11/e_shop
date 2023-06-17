import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/data/models/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'base_cart_repository.dart';

class CartRepository implements BaseCartRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  CartRepository({
    FirebaseFirestore? firebaseFirestore,
    FirebaseAuth? firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<Cart> getCart() {
    return _firebaseFirestore
        .collection('carts')
        .doc(_firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((snap) {
      return Cart.fromJson(snap.data()!);
    });
  }

  @override
  Future<String> addProductToCart(CartItem product) async {
    String res = 'Some error occurred';
    try {
      final uid = _firebaseAuth.currentUser!.uid;
      CartItem newProduct = CartItem(
        id: 'ci${product.productId}',
        productId: product.productId,
        color: product.color,
        size: product.size,
        quantity: product.quantity,
        price: product.price,
        sellerId: product.sellerId,
      );
      Cart cart = Cart(
        uid: uid,
        products: [newProduct],
      );
      final snap = await _firebaseFirestore.collection('carts').doc(uid).get();

      final cartData = Cart.fromJson(snap.data()!);
      if (cartData.products.isEmpty) {
        _firebaseFirestore.collection('carts').doc(uid).set(cart.toJson());
      } else {
        final products = cartData.products;
        for (var i = 0; i < products.length; i++) {
          if (products[i].id == 'ci${product.productId}' &&
              products[i].color == product.color &&
              products[i].size == product.size) {
            var quantity = products[i].quantity + 1;

            final tmp = CartItem(
              id: 'ci${product.productId}',
              productId: product.productId,
              color: product.color,
              size: product.size,
              quantity: quantity,
              price: product.price,
              sellerId: product.sellerId,
            );
            products.removeAt(i);

            products.insert(i, tmp);

            await _firebaseFirestore.collection('carts').doc(uid).set(
                  Cart(uid: uid, products: products).toJson(),
                  SetOptions(merge: true),
                );
          } else if (products[i].id ==
                  'ci${product.productId}p${product.color}c${product.size}s' &&
              products[i].color == product.color &&
              products[i].size == product.size) {
            var quantity = products[i].quantity + 1;

            final tmp = CartItem(
              id: 'ci${product.productId}p${product.color}c${product.size}s',
              productId: product.productId,
              color: product.color,
              size: product.size,
              quantity: quantity,
              price: product.price,
              sellerId: product.sellerId,
            );

            products.removeAt(i);
            products.insert(i, tmp);

            await _firebaseFirestore.collection('carts').doc(uid).set(
                  Cart(uid: uid, products: products).toJson(),
                  SetOptions(merge: true),
                );
          } else if ((products[i].id == 'ci$product.productId' &&
                  products[i].color != product.color &&
                  products[i].size == product.size) ||
              (products[i].id == 'ci$product.productId' &&
                  products[i].size != product.size &&
                  products[i].color == product.color)) {
            CartItem productTmp = CartItem(
              id: 'ci${product.productId}p${product.color}c${product.size}s',
              productId: product.productId,
              color: product.color,
              size: product.size,
              quantity: product.quantity,
              price: product.price + .0,
              sellerId: product.sellerId,
            );
            await _firebaseFirestore.collection('carts').doc(uid).update({
              'products': FieldValue.arrayUnion([productTmp.toJson()]),
            });
          } else {
            CartItem productTmp = CartItem(
              id: 'ci${product.productId}',
              productId: product.productId,
              color: product.color,
              size: product.size,
              quantity: product.quantity,
              price: product.price + .0,
              sellerId: product.sellerId,
            );
            await _firebaseFirestore.collection('carts').doc(uid).update({
              'products': FieldValue.arrayUnion([productTmp.toJson()]),
            });
          }
        }
      }

      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  @override
  Future<String> removeProductFromCart(CartItem product) async {
    String resDel = 'Some error occurred';
    try {
      final snap = await _firebaseFirestore
          .collection('carts')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      final cartData = Cart.fromJson(snap.data()!);
      final products = cartData.products;
      for (var i = 0; i < products.length; i++) {
        if (products[i].id == product.id &&
            products[i].color == product.color &&
            products[i].size == product.size) {
          var quantity = products[i].quantity - 1;

          final tmp = CartItem(
            id: product.id,
            productId: product.productId,
            color: product.color,
            size: product.size,
            quantity: quantity,
            price: product.price,
            sellerId: product.sellerId,
          );
          products.removeAt(i);

          if (quantity >= 1) {
            products.insert(i, tmp);
          }

          await _firebaseFirestore
              .collection('carts')
              .doc(_firebaseAuth.currentUser!.uid)
              .set(
                Cart(uid: _firebaseAuth.currentUser!.uid, products: products)
                    .toJson(),
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

  @override
  Future<String> deleteProductFromCart(CartItem product) async {
    String resDel = 'Some error occurred';
    try {
      final snap = await _firebaseFirestore
          .collection('carts')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      final cartData = Cart.fromJson(snap.data()!);
      final products = cartData.products;
      for (var i = 0; i < products.length; i++) {
        if (products[i].id == product.id &&
            products[i].color == product.color &&
            products[i].size == product.size) {
          products.removeAt(i);

          await _firebaseFirestore
              .collection('carts')
              .doc(_firebaseAuth.currentUser!.uid)
              .set(
                Cart(uid: _firebaseAuth.currentUser!.uid, products: products)
                    .toJson(),
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
}
