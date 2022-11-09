import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'social_signin_options.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: GoogleClientIdOptions.currentPlatform,
    scopes: ['https://www.googleapis.com/auth/contacts.readonly'],
  );

  User get currentUser => _auth.currentUser!;

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
    final providerId =
        await _auth.fetchSignInMethodsForEmail(currentUser.email!);
    try {
      if (providerId[0] == 'google.com') {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
