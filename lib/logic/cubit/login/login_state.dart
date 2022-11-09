part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isObsecure;
  final bool remember;
  final LoginStatus status;
  final String? errorMessage;

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  const LoginState({
    required this.email,
    required this.password,
    required this.isObsecure,
    required this.remember,
    required this.status,
    this.errorMessage,
  });

  factory LoginState.initial() => const LoginState(
        email: '',
        password: '',
        isObsecure: true,
        remember: false,
        status: LoginStatus.initial,
        errorMessage: '',
      );

  LoginState copyWith({
    String? email,
    String? password,
    bool? isObsecure,
    bool? remember,
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isObsecure: isObsecure ?? this.isObsecure,
      remember: remember ?? this.remember,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isObsecure,
        remember,
        status,
        errorMessage,
      ];
}
