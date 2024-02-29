part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final UserModel? user;
  const AuthenticationState({required this.status, this.user});

  @override
  List<Object?> get props => [status, user];
}

// class AuthenticationInitial extends AuthenticationState {
//   @override
//   List<Object> get props => [];
// }
//
// class AuthenticationLoadingState extends AuthenticationState {
//   final bool isLoading;
//
//   const AuthenticationLoadingState({required this.isLoading});
//
//   @override
//   List<Object> get props => [isLoading];
// }
//
// class AuthenticationSuccessState extends AuthenticationState {
//   final UserModel user;
//
//   const AuthenticationSuccessState({required this.user});
//
//   @override
//   List<Object> get props => [user];
// }
//
// class AuthenticationFailureState extends AuthenticationState {
//   final String errorMessage;
//
//   const AuthenticationFailureState(this.errorMessage);
//
//   @override
//   List<Object> get props => [errorMessage];
// }
