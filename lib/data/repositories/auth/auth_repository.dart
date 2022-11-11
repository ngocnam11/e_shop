import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn(
          clientId: GoogleClientIdOptions.currentPlatform,
          scopes: ['https://www.googleapis.com/auth/contacts.readonly'],
        );

  @override
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  @override
  Future<User> logInWithGoogle() async {
    try {
      late final UserCredential userCredential;
      if (kIsWeb) {
        userCredential =
            await _firebaseAuth.signInWithPopup(GoogleAuthProvider());
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser?.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        userCredential = await _firebaseAuth.signInWithCredential(credential);
      }
      return userCredential.user!;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> sendForgotPasswordEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser!;

      await Future.wait([
        user.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: user.email!,
            password: currentPassword,
          ),
        ),
        user.updatePassword(newPassword),
        logOut(),
      ]);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      rethrow;
    }
  }
}

class GoogleClientIdOptions {
  static String? get currentPlatform {
    if (kIsWeb) {
      return '5975695317-6eo1094go1gn6vrn5iq0ksjd6ojnmmm4.apps.googleusercontent.com';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return null;
      case TargetPlatform.iOS:
        return '5975695317-roi2re0ggd68urlgtc72fhlu9lijoa84.apps.googleusercontent.com';
      default:
        throw UnsupportedError('Not support this platform.');
    }
  }
}
