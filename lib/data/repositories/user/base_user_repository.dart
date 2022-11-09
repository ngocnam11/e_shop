import '../../models/user.dart';

abstract class BaseUserRepository {
  Future<UserModel?> fetchUser(String uid);
  Stream<UserModel> getUserStream(String uid);
  Future<void> createUser(UserModel user);
  Future<void> updateUser(UserModel user);
}
