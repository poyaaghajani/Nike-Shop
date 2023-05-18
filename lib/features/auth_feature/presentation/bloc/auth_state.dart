part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState(this.isLogedinMode);

  final bool isLogedinMode;

  @override
  List<Object> get props => [isLogedinMode];
}

class AuthInitState extends AuthState {
  const AuthInitState(bool isLogedinMode) : super(isLogedinMode);
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState(bool isLogedinMode) : super(isLogedinMode);
}

class AuthSuccessState extends AuthState {
  const AuthSuccessState(bool isLogedinMode) : super(isLogedinMode);
}

class AuthErrorState extends AuthState {
  final AppExeption exeption;

  const AuthErrorState(bool isLogedinMode, this.exeption)
      : super(isLogedinMode);
}
