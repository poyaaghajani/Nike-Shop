part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// when user open login/singup screen
class AuthInit extends AuthEvent {}

// when user pressed inter button
class AuthButtonPressed extends AuthEvent {
  final String email;
  final String password;

  const AuthButtonPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

// when user pressed login/singup text
class AuthModeChangePressed extends AuthEvent {}
