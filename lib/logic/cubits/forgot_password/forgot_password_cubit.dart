import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../config/enums.dart';
import '../../../data/repositories/repositories.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(ForgotPasswordState.initial());

  void emailChanged(String email) {
    emit(state.copyWith(email: email, status: Status.initial));
  }

  Future<void> sendForgotPasswordEmail() async {
    if (!state.isValid || state.status == Status.submitting) return;
    emit(state.copyWith(status: Status.submitting));
    try {
      await _authRepository.sendForgotPasswordEmail(state.email);
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}
