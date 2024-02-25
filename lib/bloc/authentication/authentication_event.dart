part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class SignUpUser extends AuthenticationEvent {
  final String email;
  final String password;

  const SignUpUser(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignInUserWithEmail extends AuthenticationEvent {
  final String email;
  final String password;

  const SignInUserWithEmail(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignInUserWithGoogle extends AuthenticationEvent {

  @override
  List<Object> get props => [];
}

class SignOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
