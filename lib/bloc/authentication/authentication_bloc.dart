import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../models/models.dart';
import '../../services/authentication.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  // AuthService authService = AuthService();

  AuthenticationBloc()
      : super(const AuthenticationState(status: AuthenticationStatus.unknown)) {
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
      // if (user == null) {
      //   emit(const AuthenticationState(
      //       status: AuthenticationStatus.unauthenticated, user: null));
      // } else {
      //   emit(AuthenticationState(
      //       status: AuthenticationStatus.authenticated,
      //       user: UserModel(
      //           displayName: user.displayName,
      //           email: user.email,
      //           id: user.uid)));
      //   // print('User is signed in!');
      // }
    // }
    // );

    // on<SignInUserWithEmail>((event, emit) async {
    //   try {
    //     final UserModel? user =
    //         await authService.signInUserWithEmail(event.email, event.password);
    //     if (user != null) {
    //       emit(AuthenticationState(
    //           user: user, status: AuthenticationStatus.authenticated));
    //     } else {
    //       emit(const AuthenticationState(
    //           user: null, status: AuthenticationStatus.unauthenticated));
    //     }
    //   } catch (e) {
    //     // print(e.toString());
    //   }
    // });

    // on<SignInUserWithGoogle>((event, emit) async {
    //   // emit(const AuthenticationLoadingState(isLoading: true));
    //   try {
    //     final UserModel? user = await authService.signInWithGoogle();
    //     if (user != null) {
    //       emit(AuthenticationState(
    //           user: user, status: AuthenticationStatus.authenticated));
    //       // emit(const AuthenticationLoadingState(isLoading: false));
    //       // emit(AuthenticationSuccessState(user: user));
    //     } else {
    //       emit(const AuthenticationState(
    //           user: null, status: AuthenticationStatus.unauthenticated));
    //       // emit(const AuthenticationLoadingState(isLoading: false));
    //       // emit(const AuthenticationFailureState('create user failed'));
    //     }
    //   } catch (e) {
    //     // print(e.toString());
    //   }
    // });
    //
    // on<SignInUserWithApple>((event, emit) async {
    //   // emit(const AuthenticationLoadingState(isLoading: true));
    //   try {
    //     final UserModel? user = await authService.signInWithApple();
    //     if (user != null) {
    //       emit(AuthenticationState(
    //           user: user, status: AuthenticationStatus.authenticated));
    //       // emit(const AuthenticationLoadingState(isLoading: false));
    //       // emit(AuthenticationSuccessState(user: user));
    //     } else {
    //       emit(const AuthenticationState(
    //           user: null, status: AuthenticationStatus.unauthenticated));
    //       // emit(const AuthenticationLoadingState(isLoading: false));
    //       // emit(const AuthenticationFailureState('create user failed'));
    //     }
    //   } catch (e) {
    //     // print(e.toString());
    //   }
    // });

    // on<SignOut>((event, emit) async {
    //   // emit(const AuthenticationLoadingState(isLoading: true));
    //   try {
    //     authService.signOutUser();
    //   } catch (e) {
    //     // print('error');
    //   }
    //   emit(const AuthenticationState(
    //       user: null, status: AuthenticationStatus.unauthenticated));
    // });
  }
}
