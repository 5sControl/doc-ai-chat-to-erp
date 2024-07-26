part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationState extends Equatable {
  //final AuthenticationStatus status;
  //final UserModel? user;
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationLoadingState extends AuthenticationState {
  final bool isLoading;

  const AuthenticationLoadingState({required this.isLoading});

  @override
  List<Object> get props => [isLoading];
}

class AuthenticationSuccessState extends AuthenticationState {
  final UserModel user;

  const AuthenticationSuccessState({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthenticationFailureState extends AuthenticationState {
  final String errorMessage;

  const AuthenticationFailureState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class RestorePasswordSuccess extends AuthenticationState {
  const RestorePasswordSuccess();

  @override
  List<Object> get props => [];
}

class RestorePasswordError extends AuthenticationState {
  final String errorMessage;
  const RestorePasswordError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class DeleteUserState extends AuthenticationState {
  const DeleteUserState();

  @override
  List<Object> get props => [];
}