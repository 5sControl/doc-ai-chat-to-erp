import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';
import '../../services/authentication.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService authService = AuthService();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<SignUpUser>((event, emit) async {
      emit(const AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? user =
            await authService.signUpUser(event.email, event.password);
        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(const AuthenticationFailureState('create user failed'));
        }
      } catch (e) {
        print(e.toString());
      }
      emit(const AuthenticationLoadingState(isLoading: false));
    });

    on<SignInUserWithEmail>((event, emit) async {
      emit(const AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? user =
            await authService.signInUserWithEmail(event.email, event.password);
        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(const AuthenticationFailureState('create user failed'));
        }
      } catch (e) {
        print(e.toString());
      }
      emit(const AuthenticationLoadingState(isLoading: false));
    });

    on<SignInUserWithGoogle>((event, emit) async {
      emit(const AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? user = await authService.signInWithGoogle();
        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(const AuthenticationFailureState('create user failed'));
        }
      } catch (e) {
        print(e.toString());
      }
      emit(const AuthenticationLoadingState(isLoading: false));
    });

    on<SignOut>((event, emit) async {
      emit(const AuthenticationLoadingState(isLoading: true));
      try {
        authService.signOutUser();
      } catch (e) {
        print('error');
        print(e.toString());
      }
      emit(const AuthenticationLoadingState(isLoading: false));
    });
  }
}
