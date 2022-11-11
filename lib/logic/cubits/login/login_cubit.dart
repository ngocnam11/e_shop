import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/enums.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/repositories.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  LoginCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        _authRepository = authRepository,
        super(LoginState.initial());

  void emailChanged(String email) {
    emit(state.copyWith(email: email, status: Status.initial));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password, status: Status.initial));
  }

  void obsecureChanged() {
    emit(state.copyWith(isObsecure: !state.isObsecure, status: Status.initial));
  }

  void rememberChanged() {
    emit(state.copyWith(remember: !state.remember, status: Status.initial));
  }

  Future<void> logInWithEmailAndPassword() async {
    if (!state.isFormValid || state.status == Status.submitting) return;
    emit(state.copyWith(status: Status.submitting));
    try {
      await _authRepository.logInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: Status.submitting));
    try {
      final authUser = await _authRepository.logInWithGoogle();

      if ((await _userRepository.fetchUser(authUser.uid)) == null) {
        final user = UserModel(
          uid: authUser.uid,
          username: authUser.displayName ?? 'Google User',
          email: authUser.email!,
          phoneNum: authUser.phoneNumber ?? '',
          photoUrl: authUser.photoURL!,
        );
        await _userRepository.createUser(user);
      }

      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}
