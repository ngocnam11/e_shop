import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthRepository {
  Stream<User?> get user;
  Future<User?> signUp({
    required String email,
    required String password,
  });
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> logInWithGoogle();
  Future<void> sendForgotPasswordEmail({required String email});
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<void> logOut();
}
