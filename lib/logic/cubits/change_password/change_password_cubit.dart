import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../config/enums.dart';
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
      status: Status.initial,
    ));
  }

  void newPasswordChanged(String newPassword) {
    emit(state.copyWith(
      newPassword: newPassword,
      status: Status.initial,
    ));
  }

  void hideCurrentChanged() {
    emit(state.copyWith(
      hideCurrentPassword: !state.hideCurrentPassword,
      status: Status.initial,
    ));
  }

  void hideNewChanged() {
    emit(state.copyWith(
      hideNewPassword: !state.hideNewPassword,
      status: Status.initial,
    ));
  }

  Future<void> changePassword() async {
    if (!state.isFormValid || state.status == Status.submitting) return;
    emit(state.copyWith(status: Status.submitting));
    try {
      await _authRepository.changePassword(
        currentPassword: state.currentPassword,
        newPassword: state.newPassword,
      );
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}
