import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
}
