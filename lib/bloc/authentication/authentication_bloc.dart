import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../constants.dart';
import '../../models/models.dart';
import '../../services/authentication.dart';
import '../mixpanel/mixpanel_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return concurrent<E>().call(events.throttle(duration), mapper);
  };
}

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService authService;
  final MixpanelBloc mixpanelBloc;

  AuthenticationBloc({required this.authService, required this.mixpanelBloc})
      : super(AuthenticationInitial()) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        emit(AuthenticationSuccessState(
            user: UserModel(
                displayName: user.displayName,
                email: user.email,
                id: user.uid)));
        mixpanelBloc.add(IdentifyUser(uid: user.uid, email: user.email));
      }
    });

    on<SignUpWithEmail>((event, emit) async {
      emit(const AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? res = await authService.signUpUser(
            name: event.name, email: event.email, password: event.password);
        if (res is UserModel) {
          emit(AuthenticationSuccessState(user: res));
          mixpanelBloc.add(IdentifyUser(uid: res.id!, email: res.email));
          if (!kIsFreeApp) {
            await Purchases.logIn(res.id!);
          }
        }
      } catch (e) {
        emit(AuthenticationFailureState(
            errorMessage: e.toString().replaceAll('Exception: ', '')));
      }
    }, transformer: throttleDroppable(throttleDuration));

    on<SignInUserWithEmail>((event, emit) async {
      emit(const AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? res =
            await authService.signInUserWithEmail(event.email, event.password);
        if (res is UserModel) {
          emit(AuthenticationSuccessState(user: res));
          mixpanelBloc.add(IdentifyUser(uid: res.id!, email: res.email));
          if (!kIsFreeApp) {
            await Purchases.logIn(res.id!);
          }
        }
      } catch (e) {
        emit(AuthenticationFailureState(
            errorMessage: e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<SignInUserWithGoogle>((event, emit) async {
      emit(const AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? user = await authService.signInWithGoogle();
        if (user != null) {
          emit(AuthenticationSuccessState(user: user));
          mixpanelBloc.add(IdentifyUser(uid: user.id!, email: user.email));
          if (!kIsFreeApp) {
            await Purchases.logIn(user.id!);
          }
        } else {
          emit(const AuthenticationFailureState(errorMessage: 'Some error'));
        }
      } catch (e) {
        if (e.toString().contains('canceled')) {
          emit(AuthenticationInitial());
        } else {
          emit(AuthenticationFailureState(errorMessage: e.toString()));
        }
      }
    });

    on<SignInUserWithApple>((event, emit) async {
      emit(const AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? user = await authService.signInWithApple();
        if (user != null) {
          emit(AuthenticationSuccessState(user: user));
          mixpanelBloc.add(IdentifyUser(uid: user.id!, email: user.email));
          if (!kIsFreeApp) {
            await Purchases.logIn(user.id!);
          }
        } else {
          emit(const AuthenticationFailureState(errorMessage: 'Some error'));
        }
      } catch (e) {
        if (e is SignInWithAppleAuthorizationException) {
          if (e.code == AuthorizationErrorCode.canceled) {
            emit(AuthenticationInitial());
          }
        } else {
          emit(AuthenticationFailureState(errorMessage: e.toString()));
        }
      }
    });

    on<SignOut>((event, emit) async {
      emit(const AuthenticationLoadingState(isLoading: true));
      try {
        authService.signOutUser();
        emit(AuthenticationInitial());
        if (!kIsFreeApp) {
          await Purchases.logOut();
        }
      } catch (e) {
        emit(AuthenticationInitial());
      }
    });

    on<SendResetEmail>((event, emit) async {
      try {
        await authService.sendResetEmail(email: event.email);
        emit(const RestorePasswordSuccess());
      } catch (e) {
        if (e is FirebaseException) {
          emit(RestorePasswordError(errorMessage: e.message ?? 'Some error'));
        } else {
          emit(const RestorePasswordError(errorMessage: 'Some error'));
        }
      }
      emit(AuthenticationInitial());
    });

    on<DeleteUser>((event, emit) async {
      emit(const AuthenticationLoadingState(isLoading: true));
      try {
        authService.deleteUser();
        emit(const DeleteUserState());
        emit(AuthenticationInitial());
        if (!kIsFreeApp) {
          await Purchases.logOut();
        }
      } catch (e) {
        emit(const DeleteUserState());
        emit(AuthenticationInitial());
      }
    });
  }
}