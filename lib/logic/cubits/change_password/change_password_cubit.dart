import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repositories/repositories.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final AuthRepository _authRepository;

  ChangePasswordCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(ChangePasswordState.initial());

  void currentPasswordChanged(String currentPassword) {
    emit(state.copyWith(
      currentPassword: currentPassword,
      status: ChangePasswordStatus.initial,
    ));
  }

  void newPasswordChanged(String newPassword) {
    emit(state.copyWith(
      newPassword: newPassword,
      status: ChangePasswordStatus.initial,
    ));
  }

  void hideCurrentChanged() {
    emit(state.copyWith(
      hideCurrentPassword: !state.hideCurrentPassword,
      status: ChangePasswordStatus.initial,
    ));
  }

  void hideNewChanged() {
    emit(state.copyWith(
      hideNewPassword: !state.hideNewPassword,
      status: ChangePasswordStatus.initial,
    ));
  }

  Future<void> changePassword() async {
    if (!state.isFormValid || state.status == ChangePasswordStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: ChangePasswordStatus.submitting));
    try {
      await _authRepository.changePassword(
        currentPassword: state.currentPassword,
        newPassword: state.newPassword,
      );
      emit(state.copyWith(status: ChangePasswordStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ChangePasswordStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
