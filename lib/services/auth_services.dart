import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';
import 'social_signin_options.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: GoogleClientIdOptions.currentPlatform,
    scopes: ['https://www.googleapis.com/auth/contacts.readonly'],
  );

  User get currentUser => _auth.currentUser!;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        UserModel user = UserModel(
          uid: cred.user!.uid,
          username: username,
          email: email,
        );

        _firestore.collection('users').doc(user.uid).set(user.toJson());

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
          email: email,
          password: password,
        );
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

        userCredential = await _auth.signInWithCredential(credential);
      } else {
        userCredential = await _auth.signInWithPopup(GoogleAuthProvider());
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (!snapshot.exists) {
        UserModel user = UserModel(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          username: userCredential.user!.displayName ?? '',
          phoneNum: userCredential.user!.phoneNumber ?? '',
          photoUrl: userCredential.user!.photoURL!,
        );

        _firestore.collection('users').doc(user.uid).set(user.toJson());
      }

      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> sendForgotPasswordEmail({required String toEmail}) async {
    String res = 'Some error occurred';
    try {
      await _auth.sendPasswordResetEmail(email: toEmail);
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> changeUserPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    String res = 'Some error occurred';
    try {
      if (oldPassword.isNotEmpty || newPassword.isNotEmpty) {
        final AuthCredential credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: oldPassword,
        );

        await currentUser.reauthenticateWithCredential(credential);
        await currentUser.updatePassword(newPassword);
        await logout();

        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> logout() async {
    // final providerId =
    //     await _auth.fetchSignInMethodsForEmail(currentUser.email!);
    try {
      // if (providerId[0] == 'google.com') {
      await _googleSignIn.signOut();
      // }
      await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
