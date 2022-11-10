part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppInitialize extends AppEvent {}

class AppUserChanged extends AppEvent {
  final User? authUser;
  final UserModel? user;

  const AppUserChanged({required this.authUser, this.user = UserModel.empty});

  @override
  List<Object?> get props => [authUser, user];
}

class AppLogoutRequested extends AppEvent {}
