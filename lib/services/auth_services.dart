import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart' as model;
import 'social_signin_options.dart';
import 'storage_service.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: GoogleClientIdOptions.currentPlatform,
    scopes: ['https://www.googleapis.com/auth/contacts.readonly'],
  );

  User get user => _auth.currentUser!;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageService()
            .uploadImageToStorage('profilePics', file, false, '');

        model.User user = model.User(
          uid: cred.user!.uid,
          username: username,
          email: email,
          photoUrl: photoUrl,
        );

        _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

        res = 'success';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> logInWithGoogle() async {
    String res = 'Some error occurred';
    try {
      UserCredential userCredential;

      if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        userCredential =
            await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
        // userCredential = await FirebaseAuth.instance.signInWithRedirect(GoogleAuthProvider());
      }

      model.User user = model.User(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        username: userCredential.user!.displayName ?? '',
        phoneNum: userCredential.user!.phoneNumber ?? '',
        photoUrl: userCredential.user!.photoURL ?? '',
      );

      _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toJson());

      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
