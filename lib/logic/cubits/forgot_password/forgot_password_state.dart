part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  final String email;
  final Status status;
  final String? errorMessage;

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  bool get isValid => email.isNotEmpty && _emailRegExp.hasMatch(email);

  const ForgotPasswordState({
    required this.email,
    required this.status,
    this.errorMessage,
  });

  factory ForgotPasswordState.initial() => const ForgotPasswordState(
        email: '',
        status: Status.initial,
      );

  ForgotPasswordState copyWith({
    String? email,
    Status? status,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, status, errorMessage];
}
