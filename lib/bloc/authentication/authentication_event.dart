part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class SignUpWithEmail extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;

  const SignUpWithEmail(
      {required this.name, required this.email, required this.password});

  @override
  List<String> get props => [email, name, password];
}

class SignInUserWithEmail extends AuthenticationEvent {
  final String email;
  final String password;

  const SignInUserWithEmail({required this.email, required this.password});

  @override
  List<String> get props => [email, password];
}

class SignInUserWithGoogle extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class SignInUserWithApple extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class SignOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class SendResetEmail extends AuthenticationEvent {
  final String email;

  const SendResetEmail({required this.email});

  @override
  List<Object> get props => [email];
}

class DeleteUser extends AuthenticationEvent {
  const DeleteUser();

  @override
  List<Object> get props => [];
}
