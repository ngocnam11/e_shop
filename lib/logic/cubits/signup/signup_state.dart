part of 'signup_cubit.dart';

class SignUpState extends Equatable {
  final String email;
  final String password;
  final bool isObsecure;
  final String username;
  final Status status;
  final String? errorMessage;

  bool get isFormValid =>
      email.isNotEmpty && password.isNotEmpty && username.isNotEmpty;

  const SignUpState({
    required this.email,
    required this.password,
    required this.isObsecure,
    required this.username,
    required this.status,
    this.errorMessage,
  });

  factory SignUpState.initial() => const SignUpState(
        email: '',
        password: '',
        isObsecure: true,
        username: '',
        status: Status.initial,
        errorMessage: '',
      );

  SignUpState copyWith({
    String? email,
    String? password,
    bool? isObsecure,
    String? username,
    Status? status,
    String? errorMessage,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      isObsecure: isObsecure ?? this.isObsecure,
      username: username ?? this.username,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isObsecure,
        username,
        status,
        errorMessage,
      ];
}
