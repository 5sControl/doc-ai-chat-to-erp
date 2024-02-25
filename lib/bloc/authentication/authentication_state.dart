part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
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

  const AuthenticationSuccessState(this.user);
  @override
  List<Object> get props => [user];
}

class AuthenticationFailureState extends AuthenticationState {
  final String errorMessage;

  const AuthenticationFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
