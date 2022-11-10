import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user.dart';
import '../../../data/repositories/repositories.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignUpCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(SignUpState.initial());

  void emailChanged(String email) {
    emit(state.copyWith(email: email, status: SignUpStatus.initial));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password, status: SignUpStatus.initial));
  }

  void usernameChanged(String username) {
    emit(state.copyWith(username: username, status: SignUpStatus.initial));
  }

  void obsecureChanged() {
    emit(state.copyWith(
      isObsecure: !state.isObsecure,
      status: SignUpStatus.initial,
    ));
  }

  Future<void> signUpUser() async {
    if (!state.isFormValid || state.status == SignUpStatus.submitting) return;
    emit(state.copyWith(status: SignUpStatus.submitting));
    try {
      final authUser = await _authRepository.signUp(
        email: state.email,
        password: state.password,
      );

      final user = UserModel(
        uid: authUser!.uid,
        username: state.username,
        email: state.email,
      );

      await _userRepository.createUser(user);
      emit(state.copyWith(status: SignUpStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: SignUpStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
