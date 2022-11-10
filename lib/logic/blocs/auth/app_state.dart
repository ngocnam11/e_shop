part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  final UserModel user;

  const AppState({this.user = UserModel.empty});

  @override
  List<Object?> get props => [user];
}

class AppStateLoading extends AppState {}

class AppStateAuthenticated extends AppState {
  final User? authUser;

  const AppStateAuthenticated({
    required this.authUser,
    required UserModel user,
  }) : super(user: user);

  @override
  List<Object?> get props => [authUser, user];
}

class AppStateUnauthenticated extends AppState {
  const AppStateUnauthenticated() : super(user: UserModel.empty);
}

class AppStateError extends AppState {
  final String error;

  const AppStateError(this.error);

  @override
  List<Object?> get props => [error];
}
