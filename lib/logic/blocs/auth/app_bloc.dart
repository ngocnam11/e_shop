import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user.dart';
import '../../../data/repositories/repositories.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AppBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(AppStateLoading()) {
    on<AppInitialize>((event, emit) {
      _authRepository.user.listen((authUser) {
        if (authUser != null) {
          _userRepository.getUserStream(authUser.uid).listen((user) {
            add(AppUserChanged(authUser: authUser, user: user));
          });
        } else {
          add(AppUserChanged(authUser: authUser));
        }
      });
    });
    on<AppUserChanged>((event, emit) {
      try {
        if (event.authUser != null) {
          emit(AppStateAuthenticated(
            authUser: event.authUser,
            user: event.user!,
          ));
        }
        emit(const AppStateUnauthenticated());
      } catch (e) {
        emit(AppStateError(e.toString()));
      }
    });
    on<AppLogoutRequested>((event, emit) async {
      try {
        await _authRepository.logOut();
        emit(const AppStateUnauthenticated());
      } catch (e) {
        emit(AppStateError(e.toString()));
      }
    });
  }
}
