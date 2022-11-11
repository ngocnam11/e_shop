part of 'change_password_cubit.dart';

class ChangePasswordState extends Equatable {
  final String currentPassword;
  final String newPassword;
  final bool hideCurrentPassword;
  final bool hideNewPassword;
  final Status status;
  final String? errorMessage;

  bool get isFormValid =>
      currentPassword.isNotEmpty &&
      newPassword.isNotEmpty &&
      currentPassword.length >= 6 &&
      newPassword.length >= 6 &&
      currentPassword != newPassword;

  const ChangePasswordState({
    required this.currentPassword,
    required this.newPassword,
    required this.hideCurrentPassword,
    required this.hideNewPassword,
    required this.status,
    this.errorMessage,
  });

  factory ChangePasswordState.initial() => const ChangePasswordState(
        currentPassword: '',
        newPassword: '',
        hideCurrentPassword: true,
        hideNewPassword: true,
        status: Status.initial,
      );

  ChangePasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    bool? hideCurrentPassword,
    bool? hideNewPassword,
    Status? status,
    String? errorMessage,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      hideCurrentPassword: hideCurrentPassword ?? this.hideCurrentPassword,
      hideNewPassword: hideNewPassword ?? this.hideNewPassword,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        currentPassword,
        newPassword,
        hideCurrentPassword,
        hideNewPassword,
        status,
        errorMessage,
      ];
}
